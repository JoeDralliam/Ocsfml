open Ocamlbuild_plugin
open Pathname

let symbols = 
  let tmp = Hashtbl.create 10 in 
  let l = string_list_of_file "config" in
  let rec fill_tbl = function
    | [] -> tmp
    | [x] -> tmp
    | x::y::rest -> (Hashtbl.add tmp x y ; fill_tbl rest) 
  in fill_tbl l

let get_symbol s = 
  try
    Hashtbl.find symbols s
  with Not_found -> failwith ("this symbol must be defined : "^ s)

let add_gcc_rules () = 
  let ccpp = get_symbol "gcc" in

  let parallel dir files = List.map (fun f -> [dir/f]) files  in

  let err_circular file path = 
    Printf.sprintf "Circular build detected (%s already seen in [%s])"
      file (String.concat "; " path)
  in

  
  let parse_deps file = 
    let dir = dirname file in
    let deps = List.tl (List.tl (string_list_of_file file)) in
    let deps = List.filter (fun d -> d <> "\\") deps in (* remove \ *)
    let correct d = if dirname d = dir then d else dir / d in
      List.map correct deps
  in

  let deps_action dep prod env build = 
    let file = env dep in
    let tags = tags_of_pathname file ++ "g++" in
      Cmd (S [A ccpp; T tags; A "-std=c++0x" ;
	      A "-MM"; A "-MG"; A "-MF"; Px (env prod); P file])
  in

    rule "g++ : cpp -> cpp.depends"  
      ~dep:"%.cpp" ~prod:"%.cpp.depends"
      (deps_action "%.cpp" "%.cpp.depends");

    rule "g++ : hpp -> hpp.depends" 
      ~dep:"%.hpp" ~prod:"%.hpp.depends"
      (deps_action "%.hpp" "%.hpp.depends");

(* rajouter des régles pour .h et .inl *)

    rule "g++ : cpp & cpp.depends -> o" ~deps:["%.cpp"; "%.cpp.depends"] ~prod:"%.o" begin 
      fun env builder ->
	let cpp = env "%.cpp" in
	let tags = tags_of_pathname cpp ++ "compile" ++ "g++" in
	let rec build_transitive_deps = function
	  | [] -> ()
	  | (_, []) :: todo -> build_transitive_deps todo
	  | (path, f :: rest) :: todo ->
	      if List.mem f path then failwith (err_circular f path) else
		let deps = parse_deps (f ^ ".depends") in
		let dep_files = List.map (fun d -> d ^ ".depends") deps in
		  List.iter Outcome.ignore_good (builder (parallel "" deps));
		  List.iter Outcome.ignore_good (builder (parallel "" dep_files));
		  build_transitive_deps (((f :: path), deps) :: (path, rest) :: todo)
	in
	  build_transitive_deps [([],[cpp])];
	  Cmd (S[A ccpp ; A"-g" ; A"-std=c++0x" ; A"-fpermissive"; T tags;A"-I/usr/local/include"; A"-I/usr/local/lib/ocaml"; A"-c" ; P cpp ; A"-o" ; Px (env "%.o") ])
    end;

    rule "g++ : cpplib -> a" ~dep:"%.cpplib" ~prod:"%.a" begin
      fun env builder ->
	let cpplib = env "%.cpplib" in
	let tags = tags_of_pathname cpplib ++ "archive" ++ "g++" in
	let o_files = string_list_of_file cpplib in 
	let dir = dirname cpplib in
	  List.iter Outcome.ignore_good (builder (parallel dir o_files));
	  let ar_cmd o = Cmd ( S [A"ar" ; A"-q" ; Px (env "%.a"); T tags; A (dir/o) ]) in
	    Seq (List.map ar_cmd o_files)   
    end

let get_directory s =
  "Ocsfml" ^ (String.capitalize s)


let static = true 
let debug = true
let system = "system"
let window = "window"
let graphics = "graphics"
let audio = "audio"
let network = "network"
let includedir = "-I" ^ (get_symbol "includedir" )
let libdir = "-L" ^ (get_symbol "libdir") 
let libs = [
  "system", [system] ; 
  "window", [system ; window] ;
  "graphics", [system ; window ; graphics] ;
  "audio", [system ; audio ] ;
  "network", [system ; network ] ; 
]
;; 

let _ = dispatch begin function 
  | Before_rules ->  
      let create_libs_flags (s,l) = 
	let link_prefix = "-lsfml-" in
	let link_libs = (A libdir)::(List.map (fun x -> A (link_prefix^x)) l) in
	let verbose = if debug then [A"-verbose"] else [] in
	let link_libs_ocaml = List.fold_left 
	  (fun l' x -> [A"-cclib" ; A (link_prefix^x)] @ l') [A"-ccopt"; A libdir] l in
	let d = get_directory s in
	(*  List.iter (fun x -> dep ["g++"] [(get_directory x)^"/"^x^"_stub.hpp"]) l ; *)

	  (* when a c++ file employ the sfml "s" module is compiled *)
	  flag ["g++" ; "compile" ; "include_sfml_"^s ] & S link_libs;  

	  (* when we link an ocaml bytecode target with the c++ lib "s" *) 
	  flag ["link"; "ocaml"; "byte"; "use_libocsfml"^s] &
            S[A "-cclib"; A("-L./"^d); A"-cclib"; A("-locsfml"^s); A"-cclib"; A("-locsfml"^s); A"-cclib"; A"-lthreads"; A"-cclib"; A"-lunix"; A"-cclib"; A"-lstdc++"];  
	  
	  (* when we link an ocaml native target with the c++ lib "s" *)
	  flag ["link"; "ocaml"; "native"; "use_libocsfml"^s] &
	    S(verbose@[A "-cclib"; A("-L./"^d); A"-cclib"; A("-locsfml"^s); A "-cclib";A "-lthreadsnat";A "-cclib"; A "-lpthread"; A "-cclib"; A "-lunix";  A"-cclib"; A"-lstdc++"]); 

	  (* when we link an ocaml file against the sfml "s" module *)
	  flag ["ocaml" ; "link" ;  "use_sfml_"^s ] & S link_libs_ocaml;

	  (* if the c++ "s" lib is employed we add it to the dependencies *)
	  dep  ["link"; "ocaml"; "use_libocsfml"^s] [d^"/libocsfml"^s^".a"] ;

	  (* to obtain the flags use_ocsfml"s" and include_ocsfml"s" *)
	  ocaml_lib (d ^ "/ocsfml" ^ s);
      in 
	add_gcc_rules () ;
	(*flag [ "g++" ; "include_boost"] & A("-I"^(get_symbol "boostincludedir")) ;
	flag [ "g++" ; "include_caml"] & A("-I"^(get_symbol "camlincludedir")) ;
	dep [ "use_cpp_external" ; "ocaml" ; "ocamldep" ] ["camlpp/ExternalCpp/pa_cpp_external.cma"] ;
	flag [ "use_cpp_external" ; "ocaml" ; "pp" ] & S[A"camlp4o"; A"-printer"; A"o"; A"camlpp/ExternalCpp/pa_cpp_external.cma"] ;*)
	List.iter create_libs_flags libs ;
	(* If `static' is true then every ocaml link in bytecode will add -custom *)
	if static then flag ["link"; "ocaml"; "byte"] (A"-custom");
  | _ -> ()
end

