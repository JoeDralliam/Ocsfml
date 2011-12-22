open Ocamlbuild_plugin
open Pathname

let rec parse chan =
  try
    let s = input_line chan in
    let name, value =
      try 
	let n = String.index s '=' in
	  String.sub s 0 n, 
	String.sub s (n+1) ((String.length s) - (n+1))
      with Not_found -> s, "" in
      name::value::(parse chan)
  with End_of_file -> []
    
let symbols = 
  let tmp = Hashtbl.create 10 in 
  let l = parse (open_in "config") in
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
  let gcc_cpp = get_symbol "ccpp" in

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
      Cmd (S [A "g++"; T tags; A "-std=c++0x" ;
	      A "-MM"; A "-MG"; A "-MF"; Px (env prod); P file])
  in

    rule "g++ : cpp -> cpp.depends"  
      ~dep:"%.cpp" ~prod:"%.cpp.depends"
      (deps_action "%.cpp" "%.cpp.depends");

    rule "g++ : hpp -> hpp.depends" 
      ~dep:"%.hpp" ~prod:"%.hpp.depends"
      (deps_action "%.hpp" "%.hpp.depends");

(* rajouter des régles pour .h et .inl *)

    rule "g++ : cpp & cpp.depends -> obj" ~deps:["%.cpp"; "%.cpp.depends"] ~prod:"%.obj" begin 
      fun env builder ->
	let cpp = env "%.cpp" in
	let tags = tags_of_pathname cpp ++ "compile" ++ "cl" in
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
	  Cmd (S[A"cl" ; A"/Zi" ; A"/EHsc" ; A"/Zl" ; T tags;A("/I" ^ (get_symbol "boostincludedir" )); A("/I" ^ (get_symbol "includedir" )); A("/I" ^ (get_symbol "camlppincludedir" )); A"/IC:\\ocamlms\\lib"; A"/c" ; P cpp ; A("/Fo"^(Ocamlbuild_pack.Command.string_of_command_spec(Px (env "%.obj")))) ])
    end;

    rule "g++ : cpplib -> lib" ~dep:"%.cpplib" ~prod:"%.lib" begin
      fun env builder ->
	let cpplib = env "%.cpplib" in
	let tags = tags_of_pathname cpplib ++ "archive" ++ "cl" in
	let o_files = string_list_of_file cpplib in 
	let dir = dirname cpplib in
	  List.iter Outcome.ignore_good (builder (parallel dir o_files));
	  let obtain_spec_obj o = A (dir/o) in
	  let spec_obj_list =(List.map obtain_spec_obj o_files) in
		Cmd ( S [A"lib" ; A"/NODEFAULTLIB" ; A"/LIBPATH:.\\_build" ; A ("/OUT:"^(Ocamlbuild_pack.Command.string_of_command_spec(Px (env "%.lib")))); T tags; S spec_obj_list ])
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
let includedir = "/I" ^ (get_symbol "includedir" )
(* let libdir = "/LIBPATH " ^ (get_symbol "libdir")  *)
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
	let link_prefix = "" in
	(* let link_libs = (A libdir)::(List.map (fun x -> A (link_prefix^x)) l) in *)
	let verbose = if debug then [A"-verbose"] else [] in
	let link_libs_ocaml = List.fold_left 
	  (fun l' x -> [A (link_prefix^(get_symbol ("lib"^x))^"" )] @ l') [A"-g"; A"-ccopt"; A"-DEBUG" (*A"-ccopt"; A libdir*)] l in
	let d = get_directory s in
	(*  List.iter (fun x -> dep ["g++"] [(get_directory x)^"/"^x^"_stub.hpp"]) l ; *)

	  (* when a c++ file employ the sfml "s" module is compiled *)
	  (*flag ["cl" ; "compile" ; "include_sfml_"^s ] & S link_libs;  *)

	  (* when we link an ocaml bytecode target with the c++ lib "s" *) 
	  flag ["link"; "ocaml"; "byte"; "use_libocsfml"^s] &
            S[A "-cclib"; A("-I./"^d); A"-cclib"; A("-locsfml"^s); A"-cclib"; A("-locsfml"^s); A"-cclib"; A"-lunix"];  
	  
	  (* when we link an ocaml native target with the c++ lib "s" *)
	  flag ["link"; "ocaml"; "native"; "use_libocsfml"^s] &
	    S(verbose@[A "-cclib"; A("-I./"^d); A"-cclib"; A("-locsfml"^s); A "-cclib"; A "-lunix"]); 

	  (* when we link an ocaml file against the sfml "s" module *)
	  flag ["ocaml" ; "link" ;  "use_sfml_"^s ] & S link_libs_ocaml;

	  (* if the c++ "s" lib is employed we add it to the dependencies *)
	  dep  ["link"; "ocaml"; "use_libocsfml"^s] [d^"/libocsfml"^s^".lib"] ;

	  (* to obtain the flags use_ocsfml"s" and include_ocsfml"s" *)
	  ocaml_lib (d ^ "/ocsfml" ^ s);
      in 
	add_gcc_rules () ;
	flag [ "g++" ; "include_boost"] & A("/I"^(get_symbol "boostincludedir")) ;
	flag [ "g++" ; "include_caml"] & A("/I"^(get_symbol "camlincludedir")) ;
	(* dep [ "use_cpp_external" ; "ocaml" ; "ocamldep" ] ["camlpp/ExternalCpp/pa_cpp_external.cma"] ;
	flag [ "use_cpp_external" ; "ocaml" ; "pp" ] & S[A"camlp4o"; A"-printer"; A"o"; A"camlpp/ExternalCpp/pa_cpp_external.cma"] ;*)
	List.iter create_libs_flags libs ;
	(* If `static' is true then every ocaml link in bytecode will add -custom *)
	if static then flag ["link"; "ocaml"; "byte"] (A"-custom");
  | _ -> ()
end

