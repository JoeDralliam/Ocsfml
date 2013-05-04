open Ocamlbuild_plugin
open Pathname


module CommandLineArguments =
struct
  let read_word i =
    let ch = ref (input_char i) and str = ref "" in
    
    while !ch = ' ' || !ch = '\n' || !ch = '\t' 
    do ch := input_char i done ; 
    

    while !ch <> ' ' && !ch <> '\n' && !ch <> '\t' 
    do 
      str := String.concat "" [!str ; String.make 1 !ch] ; 
      ch := input_char i 
    done; 
    !str

  let read_words input =
    let res = ref [||] in
    try
      while true
      do
        res := Array.append !res [| read_word input |]
      done;
      !res
    with
      | End_of_file -> !res


  type r = {
    mutable os: string ;
    mutable cxx: string ;
    mutable use_sfml_static_libraries: bool ;
    mutable link_sfml_to_static_lib: bool ;
    mutable dynlink_byte : bool ; (*  @OCSFML_LINK_BYTECODE_DYNAMIC@ *)
    mutable dynlink_nat : bool ; (* @OCSFML_LINK_NATIVE_DYNAMIC@  *)
    mutable system : string ;
    mutable window : string ;
    mutable graphics : string ;
    mutable audio : string ;
    mutable network : string ;
    mutable sfml_include_dir : string ;(* "-I" ^ "@SFML_DIR@" *)
    mutable boost_include_dir : string ;
    mutable ocaml_include_dir : string
  }

  let new_r () =
    { 
      os = "" ;
      cxx = "" ; 
      use_sfml_static_libraries = (Sys.os_type = "Win32") ;
      link_sfml_to_static_lib = (Sys.os_type = "Win32") ;
      dynlink_byte = (Sys.os_type = "Unix") ; (*  @OCSFML_LINK_BYTECODE_DYNAMIC@ *)
      dynlink_nat = (Sys.os_type = "Unix") ; (* @OCSFML_LINK_NATIVE_DYNAMIC@  *)
      system = "" ;
      window = "" ;
      graphics = "" ;
      audio = "" ;
      network = "" ;
      sfml_include_dir = begin
        try 
          let dir = Sys.getenv "SFML_DIR" in
          ("-I"^dir^"/include")
        with 
          | Not_found -> "" 
      end ;
      boost_include_dir = begin
        try
          ("-I" ^ Sys.getenv "BOOST_ROOT")
        with
          | Not_found -> "" 
      end ;
      ocaml_include_dir = begin
        try
          ("-I" ^ Sys.getenv "OCAMLLIB")
        with
          | Not_found -> "" 
      end ;

    }

  let oses =
    if Sys.os_type = "Unix"
    then [ "linux" ; "mac" ]
    else [ "windows" ]

  let cxx_toolchains =
    if Sys.os_type = "Unix"
    then [ "gcc" ; "clang" ]
    else if Sys.os_type = "Win32"
    then [ "mingw" ; "msvc" ]
    else failwith "Cygwin is not supported"

  let parse () =
    let r = new_r () in
    let os = (
      "-os",
      Arg.Symbol (oses, fun os ->  r.os <- os),
      ""
    ) in
    let cxx_toolchain = (
      "-cxx-toolchain", 
      Arg.Symbol (cxx_toolchains, fun cxx -> (r.cxx <- cxx)), 
      "C++ compiler & linker"
    ) in
    let use_sfml_static_lib = (
      "-use-sfml-static-libraries",
      Arg.Bool (fun b -> r.use_sfml_static_libraries <- b),
      ""
    ) in
    let link_sfml_to_static_lib = (
      "-link-sfml-to-static-lib",
      Arg.Bool (fun b -> r.link_sfml_to_static_lib <- b),
      ""
    ) in
    let dynlink_byte = (
      "-link-bytecode-dynamic",
      Arg.Bool (fun b -> r.dynlink_nat <- b),
      ""
    ) in
    let dynlink_nat = (
      "-link-native-dynamic",
      Arg.Bool (fun b -> r.dynlink_nat <- b),
      ""
    ) in
    let system = ("-system", Arg.String (fun s -> r.system <- s), "") in
    let window = ("-window", Arg.String (fun s -> r.window <- s), "") in
    let graphics = ("-graphics", Arg.String (fun s -> r.graphics <- s), "") in
    let audio = ("-audio", Arg.String (fun s -> r.audio <- s), "") in
    let network = ("-network", Arg.String (fun s -> r.network <- s), "") in
    let sfml_include = 
      ("-sfml-include-dir", 
       Arg.String (fun s -> r.sfml_include_dir <- s), 
       "") in (* "-I" ^ "@SFML_DIR@" *)
    let boost_include = 
      ("-boost-include-dir", 
       Arg.String (fun s -> r.boost_include_dir <- s), 
       "") in
    let ocaml_include = 
      ("-ocaml-include-dir", 
       Arg.String (fun s -> r.ocaml_include_dir <- s), 
       "") in

    let specs = [os ; cxx_toolchain ; use_sfml_static_lib ; link_sfml_to_static_lib ;
                 dynlink_byte ; dynlink_nat ; 
                 system ; window ; graphics ; audio ; network ; 
                 sfml_include ; boost_include ; ocaml_include] in


    let argv = read_words (open_in "options") in
    Arg.parse_argv ~current:(ref 0) argv specs (fun s -> print_endline s) "Parsing failure" ; 
    r

end

module CxxCompilation =
struct
  type l = Library | Archive

  type t = {
    cxx_compiler : string ;
    dll_linker   : string ;

    obj_flag     : string ; (* -o, /Fo *)
    obj_extension: string ; (* .o, .obj *)

    lib_flag     : string ;
    lib_extension: string ; (* .a, .lib *)
    dll_extension: string ; (* .so, .dll *)
    
    cxx_flags    : spec list ;
    lib_flags    : spec list ;
    dll_flags    : spec list ;
    lib_kind     : l ;
    
  }

  let compiler toolchain =
    match toolchain with
      | "gcc" | "mingw" -> "g++"
      | "clang" -> "clang++"
      | "msvc" -> "cl.exe"
      | _ -> assert false

  let obj_flag toolchain =
    match toolchain with
      | "gcc" | "clang" | "mingw" -> "-o"
      | "msvc" -> "/Fo"
      | _ -> assert false


  let obj_ext toolchain =
    match toolchain with
      | "gcc" | "clang" | "mingw" -> "o"
      | "msvc" -> "obj"
      | _ -> assert false


  let lib_flag toolchain =
    match toolchain with
      | "gcc" | "clang" | "mingw" -> "-q"
      | "msvc" -> "/OUT:"
      | _ -> assert false

  let lib_ext toolchain =
    match toolchain with
      | "gcc" | "clang" | "mingw" -> "a"
      | "msvc" -> "lib"
      | _ -> assert false


  let dll_ext toolchain =
    match Sys.os_type with
      | "Unix" ->  "so"
      | "Win32" -> "dll"
      | _ -> assert false


  let cxx_flags toolchain external_cpp =
    match toolchain with
      | "clang" ->
          [A "-O3" ; A "-fvisibility=hidden" ; A "-fPIC" ; A "-Wno-switch" ; 
           A ("-I" ^ external_cpp); A "-std=c++0x" ; A "-stdlib=libc++"; A "-c"]
      | "gcc" | "mingw" ->
          [A "-O3" ; A "-fvisibility=hidden" ; A "-fPIC" ; 
           A ("-I" ^ external_cpp); A "-std=c++0x" ; A "-fpermissive" ; A "-c"]
      | "msvc" -> 
          [A "/nologo" ; A "/Ox" ; A "/MD" ; A ("/I" ^ external_cpp) ;
           A "/D_VARIADIC_MAX=10"; A "/EHs" ; A "/c"]
      | _ -> assert false



  let lib_flags toolchain =
    if toolchain = "msvc"
    then [A "/NOLOGO" ; A "/LIBPATH:./build"]
    else []

  let dll_flags toolchain os =
    match toolchain with
      | "clang" when os = "mac" -> 
          [A "-shared" ; A "-flat_namespace" ; A "-undefined" ; A "suppress"] 
      | "gcc" | "mingw" | "clang" -> [A "-shared"]

      | "msvc" -> 
          let opt = if Sys.word_size = 32 then "msvc" else "msvc64" in
          [A "-chain"; A opt ; A "-merge-manifest" ]
      | _ -> assert false

  let lib_kind toolchain =
    match toolchain with
      | "gcc" | "clang" | "mingw" -> Archive
      | "msvc" -> Library
      | _ -> assert false

  let linker toolchain =
    match toolchain with
      | "gcc" -> "g++"
      | "clang" -> "clang++"
      | "msvc" -> "flexlink"
      | "mingw" -> "flexlink"
      | _ -> assert false

  let from_arguments r =
    let open CommandLineArguments in
        {
          cxx_compiler  = compiler  r.cxx ;
          dll_linker    = linker    r.cxx ;
          obj_flag      = obj_flag  r.cxx ;
          obj_extension = obj_ext   r.cxx ;
          lib_flag      = lib_flag  r.cxx ;
          lib_extension = lib_ext   r.cxx ;
          dll_extension = dll_ext   r.cxx ;
          cxx_flags     = cxx_flags r.cxx "../camlpp" ; (*FIXME set absolute path*)
          lib_flags     = lib_flags r.cxx ;
          dll_flags     = dll_flags r.cxx r.os ;
          lib_kind      = lib_kind  r.cxx 
        }

  let stdlib r =
    let open CommandLineArguments in
        match r.cxx with
          | "msvc" -> 
              if r.use_sfml_static_libraries
              then [ A "-cclib" ; A "user32.lib"]
              else []
          | "clang" -> [A "-cclib" ; A "-lc++"]
          | "gcc" | "mingw" -> [A "-cclib" ; A "-lstdc++"]
          | _ -> assert false
end


let add_compile_rules t =
  let open CxxCompilation in
      let cpp_compiler = t.cxx_compiler in
      
      let parallel dir files = List.map (fun f -> [dir/f]) files in
      

  (*  let deps_action dep prod env build =
      let cmake = "@CMAKE_COMMAND@" in
      let file = "../"^(env dep)^".depends" in
      Cmd( S [A cmake;A "-E";A "copy" ; P file ; Px (env prod)] )
      in
  *)


      let match_obj = "%." ^ t.obj_extension in

      rule "c++ : cpp -> (o|obj)" 
        ~deps:["%.cpp"] 
        ~prod:match_obj begin 
          fun env builder ->
	    let cpp = env "%.cpp" in
	    let tags = tags_of_pathname cpp ++ "compile" ++ "c++" in
	    let obj_name = env match_obj in
	    let obj_flag = t.obj_flag ^ obj_name in
	    Cmd (S ([A cpp_compiler] @ t.cxx_flags @ [T tags ; P cpp ; A obj_flag ]))
        end;

      let match_cpplib = "%(path)/%(libname).cpplib" in
      let match_staticlib = "%(path)/lib%(libname)." ^ t.lib_extension in
      let match_libname = "%(libname)" in

      rule "c++ : cpplib -> (a|lib)" ~dep:match_cpplib ~prod:match_staticlib begin
        fun env builder ->
          let cpplib = env match_cpplib in
          let staticlib = env match_staticlib in
          let module_name = env match_libname in
          let tags = tags_of_pathname cpplib ++ "archive" ++ "c++" ++ module_name in
          let o_files = string_list_of_file cpplib in
          let dir = dirname cpplib in
          let lib_flag = t.lib_flag in
          List.iter Outcome.ignore_good (builder (parallel dir o_files));
          let make_archive () =
	    let obtain_spec_obj o = A (dir/o) in
	    let spec_obj_list =(List.map obtain_spec_obj o_files) in
	    Cmd ( S [A "ar"; A lib_flag ; Px staticlib; T tags; S spec_obj_list ])
          in
          let make_library () =
	    let obtain_spec_obj o = A (dir/o) in
	    let spec_obj_list =(List.map obtain_spec_obj o_files) in
	    Cmd(S ([A "lib.exe" ; A (lib_flag^staticlib); T tags; S spec_obj_list ] @ t.lib_flags))
          in
          if t.lib_kind = Archive 
          then make_archive () else make_library () 
      end;   
      
      let match_dynamiclib = "%(path)/dll%(libname)."^t.dll_extension in

      rule "c++ : cpplib -> (so|dll)" ~dep:match_cpplib ~prod:match_dynamiclib begin
        fun env builder ->
          let linker = t.dll_linker in
          let cpplib = env match_cpplib in
          let dynamiclib = env match_dynamiclib in
          let module_name = env match_libname in
          let tags = tags_of_pathname cpplib ++ "shared" ++ "c++" ++ module_name in
          let o_files = string_list_of_file cpplib in
          let dir = dirname cpplib in
          List.iter Outcome.ignore_good (builder (parallel dir o_files));
          let obtain_spec_obj o = A (dir/o) in
          let spec_obj_list =(List.map obtain_spec_obj o_files) in
          Cmd( S ([A linker] @ t.dll_flags @ [S spec_obj_list ; T tags ; A"-o"; Px dynamiclib]) )
      end

let get_directory s =
  "Ocsfml" ^ (String.capitalize s)

let get_stub_directory s = 
  "../" ^ (get_directory s) ^ "/ocsfml_" ^ s ^ "_stub"


let debug = false


let _ = dispatch begin function 
  | Before_rules ->  



      let r = CommandLineArguments.parse () in
      let open CommandLineArguments in
          let t = CxxCompilation.from_arguments r in
          let libs = [
            "system", [r.system], ["system"] ; 
            "window", [r.system ; r.window], ["system"; "window"] ;
            "graphics", [r.system ; r.window ; r.graphics], ["system"; "window"; "graphics"] ;
            "audio", [r.system ; r.audio ], ["system"; "audio"] ;
            "network", [r.system ; r.network ], ["system"; "network"]
          ] in

          let ocsfml_link_bytecode = 
            if r.dynlink_byte
            then "-dllib"
            else "-cclib"
          in



          let create_libs_flags (s,l, i) = 
	(* let link_libs = (A libdir)::(List.map (fun x -> A (link_prefix^x)) l) in *)
	    let verbose = if debug then [A"-verbose"] else [] in
	    let libs_sfml = List.fold_left
	      (fun l' x -> [ A x ] @ l') [] l in
	    let link_libs_ocaml = List.fold_left 
	      (fun l' x -> [A "-cclib" ; A x ] @ l') [(*A"-ccopt"; A libdir*)] l in
	    let d = get_directory s in
	(*  List.iter (fun x -> dep ["g++"] [(get_directory x)^"/"^x^"_stub.hpp"]) l ; *)
	    
	(* when a c++ file employ the sfml "s" module is compiled *)
	    List.iter (fun i_dep -> flag ["c++"; "compile" ; "ocsfml"^s] & A( "-I" ^ (get_stub_directory i_dep) ) ) i ;
	    
	    flag["c++" ; "shared" ; "ocsfml"^s] & S( libs_sfml );
	    
	    let link_sfml_cmxa = if r.link_sfml_to_static_lib
	      then ( flag["c++" ; "archive" ; "ocsfml"^s] & S( libs_sfml ) ; [] )
	      else link_libs_ocaml in
	    
	(* when we link an ocaml bytecode target with the c++ lib "s" *) 
	    flag ["link"; "ocaml"; "byte"; "use_libocsfml"^s] &
	      S(verbose
	        @[  A ocsfml_link_bytecode ; A("-locsfml"^s)]
	        @(CxxCompilation.stdlib r));  
	    
	(* when we link an ocaml native target with the c++ lib "s" *)
	    flag ["link"; "ocaml"; "native"; "use_libocsfml"^s] &
	      S(verbose
	        @[ A "-cclib" ;  A("-locsfml"^s) ]
	        @link_sfml_cmxa
	        @(CxxCompilation.stdlib r)); 
	    
	(* when we link an ocaml file against the sfml "s" module *)

	    
	(* if the c++ "s" lib is employed we add it to the dependencies *)
	    dep  ["link"; "ocaml"; "native"; "use_libocsfml"^s] [d^"/libocsfml"^s^"."^t.CxxCompilation.lib_extension] ;
	    dep  ["link"; "ocaml"; "byte"; "use_libocsfml"^s] [d^"/dllocsfml"^s^"."^t.CxxCompilation.dll_extension] ;
	(* to obtain the flags use_ocsfml"s" and include_ocsfml"s" *)
	    ocaml_lib (d ^ "/ocsfml" ^ s);
          in 
          add_compile_rules t;


          if r.sfml_include_dir <> ""
          then flag [ "c++" ; "compile" ] & A( r.sfml_include_dir ) ;


          if r.boost_include_dir <> ""
          then flag [ "c++" ; "compile" ] & A( r.boost_include_dir ) ; 

          if r.ocaml_include_dir <> ""
          then flag [ "c++" ; "compile" ] & A( r.ocaml_include_dir ) ;

          if r.use_sfml_static_libraries then flag ["c++"; "compile"] & A( "-DSFML_STATIC" ) ;

          List.iter create_libs_flags libs ;
      (* If `static' is true then every ocaml link in bytecode will add -custom *)
          if not r.dynlink_byte then flag ["link"; "ocaml"; "byte"] (A"-custom");


  | After_rules ->
      begin
        flag ["ocaml"; "doc" ; "colorize_code"] & A "-colorize-code" ;
        flag ["ocaml"; "doc" ; "custom_intro"] & S [ A "-intro" ; A "../Documentation/intro.camldoc" ]
      end
  | _ -> ()
end

