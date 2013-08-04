
module Rule = Rule.Make (Ocamlbuild_plugin)

open Ocamlbuild_plugin
open Pathname

let compiler = List.hd (CppCompiler.available ())
let boostdir = 
	try
		Some (Sys.getenv "BOOST_ROOT")
	with 
		Not_found -> None

let link lib =
  let open CppCompiler.Library in
  match lib with
  | Library filename -> A filename
  | Framework (path, name) -> S [A "-F" ; A path ; A "-framework" ; A name]


let add_sfml_flags static = 
  let open FindSfml in
  let modules = [System ; Window ; Graphics ; Audio ; Network] in
  let sfml = find ~static compiler modules in

  let add_flags compilation_mode lib =
    flag [ "link" ; "shared" ; "c++" ; compilation_mode ; "use_libsfml_system" ]
        (S [ link lib.system ]) ;
    
    flag [ "link" ; "shared" ; "c++" ; compilation_mode ; "use_libsfml_window" ]
      (S [ link lib.system ; link lib.window ]) ;

    flag [ "link" ; "shared" ; "c++" ; compilation_mode ; "use_libsfml_graphics" ]
      (S [ link lib.system ; link lib.window ; link lib.graphics ]) ;

    flag [ "link" ; "shared" ; "c++" ; compilation_mode ; "use_libsfml_audio" ]
      (S [ link lib.system ; link lib.audio ]) ;

    flag [ "link" ; "shared" ; "c++" ; compilation_mode ; "use_libsfml_network" ]
      (S [ link lib.system ; link lib.network ]) ;


    if static || Conf.OS.(current = Windows)
    then begin
      flag [ "link" ; "static" ; "c++" ; compilation_mode ; "use_libsfml_system" ]
        (S [ link lib.system ]) ;
    
      flag [ "link" ; "static" ; "c++" ; compilation_mode ; "use_libsfml_window" ]
        (S [ link lib.system ; link lib.window ]) ;
      
      flag [ "link" ; "static" ; "c++" ; compilation_mode ; "use_libsfml_graphics" ]
        (S [ link lib.system ; link lib.window ; link lib.graphics ]) ;
      
      flag [ "link" ; "static" ; "c++" ; compilation_mode ; "use_libsfml_audio" ]
        (S [ link lib.system ; link lib.audio ]) ;

      flag [ "link" ; "static" ; "c++" ; compilation_mode ; "use_libsfml_network" ]
        (S [ link lib.system ; link lib.network ])
    end
    else begin
      flag [ "link"; "ocaml"; "native" ; "use_libocsfmlsystem" ]
        (S [ A "-cclib" ; link lib.system ]) ;
    
      flag [ "link"; "ocaml"; "native" ; "use_libocsfmlwindow" ]
        (S [ A "-cclib" ; link lib.system ; A "-cclib" ; link lib.window ]) ;
      
      flag [ "link"; "ocaml"; "native" ; "use_libocsfmlgraphics" ]
        (S [ A "-cclib" ; link lib.system ; A "-cclib" ; link lib.window ; A "-cclib" ; link lib.graphics ]) ;
      
      flag [ "link"; "ocaml"; "native" ; "use_libocsfmlaudio" ]
        (S [ A "-cclib" ; link lib.system ; A "-cclib" ; link lib.audio ]) ;

      flag [ "link"; "ocaml"; "native" ; "use_libocsfmlnetwork" ]
        (S [ A "-cclib" ; link lib.system ; A "-cclib" ; link lib.network ])
    end
  in 
  ( match sfml.release with
    | Some lib -> add_flags "release" lib
    | None -> () ) ;

  ( match sfml.debug with
    | Some lib -> add_flags "debug" lib
    | None -> () ) ;

  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path sfml.include_dir compiler)) ;
  if static then flag ["c++"; "compile"] (A "-DSFML_STATIC") ;
 
 let stub_dir s =
    Printf.sprintf "../Ocsfml%s/ocsfml_%s_stub" (String.capitalize s) s
  in
  let add_path modname = 
    A (CppCompiler.BuildFlags.add_include_path (stub_dir modname) compiler) 
  in

  flag [ "compile" ; "c++" ; "include_sfml_system" ]
    (S [ add_path "system" ]) ;

  flag [ "compile" ; "c++" ; "include_sfml_window" ]
    (S [ add_path "system" ; add_path "window" ]) ;

  flag [ "compile" ; "c++" ; "include_sfml_graphics" ]
    (S [ add_path "system" ; add_path "window" ; add_path "graphics" ]) ;

  flag [ "compile" ; "c++" ; "include_sfml_audio" ]
    (S [ add_path "system" ; add_path "audio" ]) ;

  flag [ "compile" ; "c++" ; "include_sfml_network" ]
    (S [ add_path "system" ; add_path "network" ]) ;


  List.iter (fun s ->
      flag ["link"; "ocaml"; "byte"; "use_libocsfml"^s]
	(S [A "-dllib" ; A("-locsfml"^s)]) ;
      
      flag ["link"; "ocaml"; "native"; "use_libocsfml"^s]
	(S [A "-cclib" ;  A("-locsfml"^s) ]) ;

      let d = Printf.sprintf "Ocsfml%s" (String.capitalize s) in
      dep  ["link"; "ocaml"; "native"; "use_libocsfml"^s] 
        [d^"/libocsfml"^s^"."^(CppCompiler.Library.caml_static_extension compiler)] ;
      dep  ["link"; "ocaml"; "byte"; "use_libocsfml"^s] 
        [d^"/dllocsfml"^s^"."^(CppCompiler.Library.caml_dynamic_extension compiler)] ;
      ocaml_lib (d ^ "/ocsfml" ^ s);
    ) ["system" ; "window" ; "graphics" ; "audio" ; "network"]
	

	
let add_other_flags () =
  let ocaml_dir = input_line (Unix.open_process_in "ocamlc -where") in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path ocaml_dir compiler)) ;
  let camlpp_dir =  "../camlpp" in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path camlpp_dir compiler)) ;

  (match boostdir with
	| Some d -> flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path d compiler))
	| _ -> () );

  
  flag [ "c++" ; "compile" ; "gcc"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-stdlib=libc++") ;
  flag [ "c++" ; "compile" ; "msvc"] (A "/D_VARIADIC_MAX=10") ;
  
  
  flag [ "c++" ; "link" ; "shared" ; "gcc"] (A "-lstdc++") ;
  flag [ "c++" ; "link" ; "shared" ; "clang"] (A "-lc++")


  

let _ = dispatch (function
    | Before_rules ->
      Rule.add_cpp_rules compiler ;
      Rule.add_cpp_common_tags () ;

      add_sfml_flags false ;
      add_other_flags () ;
    | After_rules -> ()
    | _ -> ()
  )
