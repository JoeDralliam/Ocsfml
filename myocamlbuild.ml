open Ocamlbuild_plugin

let add_gcc_rules () = 
  let gcc_cpp = "g++-mp-4.5" in

  let parallel files = List.map (fun f -> [f]) files  in

  let err_circular file path = 
    Printf.sprintf "Circular build detected (%s already seen in [%s])"
      file (String.concat "; " path)
  in

  
  let parse_deps file = 
    let dir = Pathname.dirname file in
    let deps = List.tl (List.tl (string_list_of_file file)) in
    let deps = List.filter (fun d -> d <> "\\") deps in (* remove \ *)
    let correct d = if Pathname.dirname d = dir then d else dir / d in
      List.map correct deps
  in

  let deps_action dep prod env build = 
    let file = env dep in
    let tags = tags_of_pathname file ++ "g++" in
      Cmd (S [A gcc_cpp; T tags; A "-std=c++0x" ;
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
		  List.iter Outcome.ignore_good (builder (parallel deps));
		  List.iter Outcome.ignore_good (builder (parallel dep_files));
		  build_transitive_deps (((f :: path), deps) :: (path, rest) :: todo)
	in
	  build_transitive_deps [([],[cpp])];
	  Cmd (S[A gcc_cpp ; A"-std=c++0x" ; T tags;A"-I/usr/local/include"; A"-I/usr/local/lib/ocaml"; A"-c" ; P cpp ; A"-o" ; Px (env "%.o") ])
    end;

    rule "g++ : cpplib -> a" ~dep:"%.cpplib" ~prod:"%.a" begin
      fun env builder ->
	let cpplib = env "%.cpplib" in
	let tags = tags_of_pathname cpplib ++ "archive" ++ "g++" in
	let o_files = string_list_of_file cpplib in 
	  List.iter Outcome.ignore_good (builder (parallel o_files));
	  let ar_cmd o = Cmd ( S [A"ar" ; A"-q" ; Px (env "%.a"); T tags; A o ]) in
	    Seq (List.map ar_cmd o_files)   
    end

let get_directory s =
  let s' = String.copy s in
    s'.(0) <- Char.uppercase s'.(0)

let expand_name s = (get_directory s) ^ "/ocsfml" ^ s

let static = true 
let system = "-lsfml-system"
let window = "-lsfml-window"
let graphics = "-lsfml-graphics"
let audio = "-lsfml-audio"
let network = "-lsfml-network"
let includedir = "-I/usr/local/include" 
let libdir = "-L/usr/local/lib" 
let libs = [
  "system",[system] ; 
  "window", [system ; window] ;
  "graphics", [system ; window ; graphics] ;
  "audio", [system ; audio ] ;
  "network", [system ; network ] ; 
]
;; 

let _ = dispatch begin function 
  | Before_rules ->  
      let create_libs_flags (s,l) = 
	let link_libs = (A libdir)::(List.map (fun x -> A x) l) in
	let link_libs_ocaml = 
	  List.fold_left (fun x l' -> [A"-cclib" ; A x] @ l') [A"-ccopt"; A libdir] l in

	  (* when a c++ file employ the sfml "s" module is compiled *)
	  flag ["g++" ; "compile" ; "use_sfml_"^s ] & S link_libs;  

	  (* when we link an ocaml file against the sfml "s" module *)
	  flag ["ocaml" ; "link" ;  "use_sfml_"^s ] & S link_libs_ocaml;

	  (* when we link an ocaml bytecode target with the c++ lib "s" *) 
	  flag ["link"; "ocaml"; "byte"; "use_libocsfml"^s] &
            S[A"-dllib"; A("-locsfml"^s); A"-cclib"; A("-locsfml"^s); A"-cclib"; A"-lstdc++"];  
	  
	  (* when we link an ocaml native target with the c++ lib "s" *)
	  flag ["link"; "ocaml"; "native"; "use_libocsfml"^s] &
	    S[A "-cclib"; A("-L."); A"-cclib"; A("-locsfml"^s); A"-cclib"; A"-lstdc++"]; 

	  (* if the c++ "s" lib is employed we add it to the dependencies *)
	  dep  ["link"; "ocaml"; "use_libocsfml"^s] ["libocsfml"^s^".a"] ;
  
	  (* to obtain the flags use_ocsfml"s" and include_ocsfml"s" *)
	  ocaml_lib (expand_name s);
      in 
	add_gcc_rules () ;
	flag [ "g++" ; "include_boost"] & A"-I/usr/local/include" ;
	flag [ "g++" ; "include_caml"] & A"-I/usr/local/lib/ocaml" ;
	dep [ "use_cpp_external" ; "ocaml" ; "ocamldep" ] ["pa_cpp_external.cmo"] ;
	flag [ "use_cpp_external" ; "ocaml" ; "pp" ] & S[A"camlp4o"; A"-printer"; A"o"; A"pa_cpp_external.cmo"] ;
	List.iter create_libs_flags cpp_libs ;
	(* If `static' is true then every ocaml link in bytecode will add -custom *)
	if static then flag ["link"; "ocaml"; "byte"] (A"-custom");
  | _ -> ()
end

