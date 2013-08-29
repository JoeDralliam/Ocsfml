open Ocamlbuild_plugin
open Pathname

let link_to_static_sfml_libraries = false ;;
let compiler = List.hd (CppCompiler.available ()) ;;  
    
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
  | Framework (path, name) -> S [A ("-F" ^ path) ; A "-framework" ; A name]
                                
let link to_c libs =
  S (List.map (link_one to_c) libs)
    
    
let add_sfml_flags static = 
  let open FindSfml in
  let modules = SfmlConfiguration.([System ; Window ; Graphics ; Audio ; Network]) in
  let sfml = Sfml.find ~static compiler modules in
  
  let libs_of_components lib =
    List.map (fun cp -> Sfml.LibraryMap.find cp lib)
  in

  let add_flags compilation_mode lib =
    let open SfmlConfiguration in
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_system" ] & link true (libs_of_components lib [System]) ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_window" ] & link true (libs_of_components lib [System ; Window]);
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_graphics" ] & link true (libs_of_components lib [System ; Window ; Graphics]) ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_audio" ] & link true (libs_of_components lib [System ; Audio ]) ;
    flag [ "ocamlmklib" ; "c" ; compilation_mode ; "use_libsfml_network" ] & link true (libs_of_components lib [System ; Network ]) ;

    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_system" ] & link false (libs_of_components lib [System]) ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_window" ] & link false (libs_of_components lib [System ; Window]) ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_graphics" ] & link false (libs_of_components lib [System ; Window ; Graphics]) ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_audio" ] & link false (libs_of_components lib [System ; Audio ]) ;
    flag [ "ocamlmklib" ; "ocaml" ; compilation_mode ; "use_libsfml_network" ] & link false (libs_of_components lib [System ; Network ])
  in
  
  
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path sfml.Sfml.includedir compiler)) ;
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
        [d^"/libocsfml"^s^"."^(!Options.ext_lib)] ;
      dep  ["link"; "ocaml"; "byte"; "use_libocsfml"^s] 
        [d^"/dllocsfml"^s^"."^(!Options.ext_dll)] ;

      ocaml_lib (d ^ "/ocsfml" ^ s);
    ) ["system" ; "window" ; "graphics" ; "audio" ; "network"] ;

  add_flags "release" sfml.Sfml.library ;
  

  if compiler = CppCompiler.Clang
  then (
    flag ["ocamlmklib" ] (S [A"-lc++"]) ;
  )
  else if CppCompiler.frontend compiler = CppCompiler.GccCompatible
  then (
    flag ["ocamlmklib" ] (S [A "-lstdc++"]) ;
  )
  

let add_other_flags () =
  let open FindBoost.Boost in
  let boost = find compiler [] in
  flag [ "c++" ; "compile"] (A (CppCompiler.BuildFlags.add_include_path boost.FindBoost.Boost.includedir compiler)) ;

  let ocaml_dir = input_line (Unix.open_process_in "ocamlc -where") in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path ocaml_dir compiler)) ;
  let camlpp_dir =  "../camlpp" in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path camlpp_dir compiler)) ;
  
  flag [ "c++" ; "compile" ; "gcc"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "mingw"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-stdlib=libc++") ;
  flag [ "c++" ; "compile" ; "msvc"] (A "/D_VARIADIC_MAX=10")


let _ = dispatch (function
    | Before_rules ->
      Rule.add_cpp_rules compiler ;
      Rule.add_cpp_common_tags () ;

      add_sfml_flags link_to_static_sfml_libraries ;
      add_other_flags ()
    | After_rules -> 
      flag ["ocaml"; "doc" ; "colorize_code"] & A "-colorize-code" ;
      flag ["ocaml"; "doc" ; "custom_intro"] & S [ A "-intro" ; A "../Documentation/intro.camldoc" ]
    | _ -> ()
  )
