open Ocamlbuild_plugin
open Pathname

module Rule =
struct
  let add_cpp_rules cppcompiler =
    let compiler_name = CppCompiler.name cppcompiler in
    let compile = A (CppCompiler.BuildFlags.command cppcompiler) in
    let obj = CppCompiler.object_extension cppcompiler in
    let os_name = Conf.OS.(name current) in

    let parallel dir files = List.map (fun f -> [dir/f]) files in


    rule "c++ : cpp -> (o|obj)"
      ~dep:"%.cpp"
      ~prod:("%." ^ obj) (fun env builder ->
          let cpp = env "%.cpp" in
          let obj = env ("%." ^ obj) in
          let tags = tags_of_pathname cpp ++ "compile" ++ "c++" ++ compiler_name ++ os_name in

          let nolink = CppCompiler.BuildFlags.nolink cppcompiler in
          let output = CppCompiler.BuildFlags.output_obj cppcompiler obj in

          Cmd (S [ compile ; A nolink ; A cpp ; T tags ; A output ] )
        ) ;

    if CppCompiler.(frontend cppcompiler = GccCompatible)
    then 
      rule "c++ : cpplib -> a"
        ~dep:"%(path)/%(libname).cpplib"
        ~prod:"%(path)/lib%(libname).a" (fun env builder ->
            let cpplib = env "%(path)/%(libname).cpplib" in
            let archive = env "%(path)/lib%(libname).a" in
            let tags = tags_of_pathname cpplib ++ "link" ++ "static" ++ "c++" ++ compiler_name ++ os_name in

            let dir = dirname cpplib in
            let o_files = string_list_of_file cpplib in
            List.iter Outcome.ignore_good (builder (parallel dir o_files));

            let obtain_spec_obj o = A (dir/o) in
            let spec_obj_list =(List.map obtain_spec_obj o_files) in
	    Cmd(S[A "ar" ; A "-q" ; Px archive ; T tags; S spec_obj_list ])
          )
    else 
      rule "c++ : cpplib -> lib"
        ~dep:"%(path)/%(libname).cpplib"
        ~prod:"%(path)/lib%(libname).lib" (fun env builder ->
            let cpplib = env "%(path)/%(libname).cpplib" in
            let archive = env "%(path)/lib%(libname).lib" in
            let tags = tags_of_pathname cpplib ++ "link" ++ "static" ++ "c++" ++ compiler_name ++ os_name in

            let dir = dirname cpplib in
            let o_files = string_list_of_file cpplib in
            List.iter Outcome.ignore_good (builder (parallel dir o_files));

            let obtain_spec_obj o = A (dir/o) in
            let spec_obj_list =(List.map obtain_spec_obj o_files) in
	    Cmd(S[A "link.exe" ; A "/NOLOGO" ; A ("/OUT:" ^ archive) ; T tags; S spec_obj_list ])
          ) ;

    if Conf.OS.(current = Windows)
    then 
      rule "c++ : cpplib -> dll"
        ~dep:"%(path)/%(libname).cpplib"
        ~prod:"%(path)/dll%(libname).dll" (fun env builder ->
            let link = A "flexlink" in
            let cpplib = env "%(path)/%(libname).cpplib" in
            let dynamiclib = env "%(path)/dll%(libname).dll" in
            let tags = tags_of_pathname cpplib ++ "link" ++ "shared" ++ "c++" ++  compiler_name ++ os_name in
            let o_files = string_list_of_file cpplib in
            let dir = dirname cpplib in
            List.iter Outcome.ignore_good (builder (parallel dir o_files));
            let obtain_spec_obj o = A (dir/o) in
            let spec_obj_list = (List.map obtain_spec_obj o_files) in
            Cmd( S[ link ; S spec_obj_list ; T tags ; A "-o" ; Px dynamiclib] )
          )
    else 
      rule "c++ : cpplib -> so"
        ~dep:"%(path)/%(libname).cpplib"
        ~prod:"%(path)/dll%(libname).so" (fun env builder ->
            let link = compile in
            let cpplib = env "%(path)/%(libname).cpplib" in
            let dynamiclib = env "%(path)/dll%(libname).so" in
            let tags = tags_of_pathname cpplib ++ "link" ++ "shared" ++ "c++" ++  compiler_name ++ os_name in
            let o_files = string_list_of_file cpplib in
            let dir = dirname cpplib in
            List.iter Outcome.ignore_good (builder (parallel dir o_files));
            let obtain_spec_obj o = A (dir/o) in
            let spec_obj_list = (List.map obtain_spec_obj o_files) in
            Cmd (S [ link ; S spec_obj_list ; T tags ; A "-o" ; Px dynamiclib] )
          )



  let add_cpp_common_tags () =
    flag [ "compile" ; "c++" ; "gcc" ] (A "-fPIC") ;
    flag [ "compile" ; "c++" ; "gcc" ; "release" ] (A "-O3") ;
    flag [ "compile" ; "c++" ; "gcc" ; "debug" ] (A "-g") ;

    flag [ "compile" ; "c++" ; "clang" ] (A "-fPIC") ;
    flag [ "compile" ; "c++" ; "clang" ; "release" ] (A "-O3") ;
    flag [ "compile" ; "c++" ; "clang" ; "debug" ] (A "-g") ;

    flag [ "compile" ; "c++" ; "msvc" ] 
      (S [A "/nologo" ; A "/MD" ; A "/EHs"]) ;


    flag [ "link" ; "shared" ; "linux" ] (A "-shared") ;
    flag [ "link" ; "shared" ; "mac" ] (A "-shared") ;

    flag [ "link" ; "shared" ; "mac" ; "clang" ]
      (S [A "-flat_namespace" ; A "-undefined" ; A "suppress"]) ;

    flag [ "link" ; "shared" ; "windows" ; "msvc" ]
      (S [A "-chain" ; A "msvc" ; A "-merge-manifest" ])
end


let compiler = CppCompiler.Gcc

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
  let ocaml_dir = "/usr/local/lib/ocaml" in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path ocaml_dir compiler)) ;
  let camlpp_dir =  "../camlpp" in
  flag [ "c++" ; "compile" ] (A (CppCompiler.BuildFlags.add_include_path camlpp_dir compiler)) ;

  flag [ "c++" ; "compile" ; "gcc"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-std=c++0x") ;
  flag [ "c++" ; "compile" ; "clang"] (A "-stdlib=libc++") ;

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
