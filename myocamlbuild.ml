
module Rule = Rule.Make (Ocamlbuild_plugin)
    
open Ocamlbuild_plugin
open Pathname
  
let compiler = List.hd (CppCompiler.available ()) ;;
let boostdir = 
  try
    Some (Sys.getenv "BOOST_ROOT")
  with 
    Not_found -> None
    
let link_one to_c lib =
  let open CppCompiler.Library in
  match lib with
  | Library filename -> ( 
      match soname filename with
      | Some name -> A ("-l" ^ name)
      | None -> 
          if to_c then A filename
          else S []
    )
  | Framework (path, name) -> S [A "-F" ; A path ; A "-framework" ; A name]
                                
let link to_c libs =
  S (List.map (link_one to_c) libs)
    
let link_one_ocaml_native lib =
  let open CppCompiler.Library in
  match lib with
  | Library filename -> S [A "-cclib" ; A filename]
  | Framework (path, name) -> S [A "-ccopt" ; A "-F" ; A "-ccopt" ; A path ; 
                                 A "-ccopt" ; A "-framework" ; A "-ccopt" ; A name]
                                
let link_one_ocaml_byte lib =
  let open CppCompiler.Library in
  match lib with
  | Library filename -> S [A "-cclib" ; A filename ; A "-dllib" ; A filename]
  | Framework (path, name) -> S [A "-ccopt" ; A "-F" ; A "-ccopt" ; A path ; 
                                 A "-ccopt" ; A "-framework" ; A "-ccopt" ; A name]
                                

let link_ocaml_native libs =
  S (List.map link_one_ocaml_native libs)
    
                                
let link_ocaml_byte libs =
  S (List.map link_one_ocaml_byte libs)
    
let add_sfml_flags static = 
  let open FindSfml in
  let modules = [System ; Window ; Graphics ; Audio ; Network] in
  let sfml = find ~static compiler modules in
  
  let add_flags compilation_mode lib =
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_system" ] & link true [lib.system] ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_window" ] & link true [lib.system ; lib.window] ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_graphics" ] & link true [lib.system ; lib.window ; lib.graphics] ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_audio" ] & link true [lib.system ; lib.audio ] ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_network" ] & link true [lib.system ; lib.network ] ;

    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_system" ] & link false [lib.system] ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_window" ] & link false [lib.system ; lib.window] ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_graphics" ] & link false [lib.system ; lib.window ; lib.graphics] ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_audio" ] & link false [lib.system ; lib.audio ] ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_network" ] & link false [lib.system ; lib.network ]


(*
    flag [ "ocaml" ; "link" ; "library" ; "native" ; compilation_mode ; "use_libsfml_system" ] & link_ocaml_native [lib.system] ;
    flag [ "ocaml" ; "link" ; "library" ; "native" ; compilation_mode ; "use_libsfml_window" ] & link_ocaml_native [lib.system ; lib.window] ;
    flag [ "ocaml" ; "link" ; "library" ; "native" ; compilation_mode ; "use_libsfml_graphics" ] & link_ocaml_native [lib.system ; lib.window ; lib.graphics] ;
    flag [ "ocaml" ; "link" ; "library" ; "native" ; compilation_mode ; "use_libsfml_audio" ] & link_ocaml_native [lib.system ; lib.audio ] ;
    flag [ "ocaml" ; "link" ; "library" ; "native" ; compilation_mode ; "use_libsfml_network" ] & link_ocaml_native [lib.system ; lib.network ] ;
  
    flag [ "ocaml" ; "link" ; "library" ; "byte" ; compilation_mode ; "use_libsfml_system" ] & link_ocaml_byte [lib.system] ;
    flag [ "ocaml" ; "link" ; "library" ; "byte" ; compilation_mode ; "use_libsfml_window" ] & link_ocaml_byte [lib.system ; lib.window] ;
    flag [ "ocaml" ; "link" ; "library" ; "byte" ; compilation_mode ; "use_libsfml_graphics" ] & link_ocaml_byte [lib.system ; lib.window ; lib.graphics] ;
    flag [ "ocaml" ; "link" ; "library" ; "byte" ; compilation_mode ; "use_libsfml_audio" ] & link_ocaml_byte [lib.system ; lib.audio ] ;
    flag [ "ocaml" ; "link" ; "library" ; "byte" ; compilation_mode ; "use_libsfml_network" ] & link_ocaml_byte [lib.system ; lib.network ]
*)
  in
  
  
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
		 (*
      flag ["link"; "ocaml"; "use_libocsfml"^s]
        (S [ A("-LOcsfml" ^ String.capitalize s) ]) ;

      flag ["link"; "ocaml"; "use_libocsfml"^s]
        (S [ A("-locsfml"^s) ]) ;
*)
      let d = Printf.sprintf "Ocsfml%s" (String.capitalize s) in
      dep  ["link"; "ocaml"; "native"; "use_libocsfml"^s] 
        [d^"/libocsfml"^s^"."^(CppCompiler.Library.caml_static_extension compiler)] ;
      dep  ["link"; "ocaml"; "byte"; "use_libocsfml"^s] 
        [d^"/dllocsfml"^s^"."^(CppCompiler.Library.caml_dynamic_extension compiler)] ;

      ocaml_lib (d ^ "/ocsfml" ^ s);
    ) ["system" ; "window" ; "graphics" ; "audio" ; "network"] ;

  ( match sfml.release with
    | Some lib -> add_flags "release" lib
    | None -> () ) ;

  ( match sfml.debug with
    | Some lib -> add_flags "debug" lib
    | None -> () ) ;
  

  if compiler = CppCompiler.Clang
  then (
    flag ["ocamlmklib" ] (S [A"-lc++"]) ;
  )
  else if CppCompiler.frontend compiler = CppCompiler.GccCompatible
  then (
    flag ["ocamlmklib" ] (S [A "-lstdc++"]) ;
  )
  

let add_other_flags () =
  let ocaml_dir = input_line (Unix.open_process_in "ocamlc -where") in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path ocaml_dir compiler)) ;
  let camlpp_dir =  "../camlpp" in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path camlpp_dir compiler)) ;
  
  (match boostdir with
   | Some d -> flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path d compiler))
   | _ -> () );


  flag [ "c++" ; "compile" ; "gcc"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "mingw"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-stdlib=libc++") ;
  flag [ "c++" ; "compile" ; "msvc"] (A "/D_VARIADIC_MAX=10")


let _ = dispatch (function
    | Before_rules ->
      Rule.add_cpp_rules compiler ;
      Rule.add_cpp_common_tags () ;

      add_sfml_flags false ;
      add_other_flags () ;
    | After_rules -> ()
    | _ -> ()
  )
