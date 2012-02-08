open Camlp4
open Sig

module Make(Syntax : Camlp4Syntax) =
struct

  include CppExternalAst.Make(Syntax)

  let _loc = Loc.ghost

  exception DebugSigItemConversion of Ast.str_item


  (** Fabrique le nom canonique du class 
      type associé à un class info
      @param ci class_info
      @return nom du class type (string)
  *)
  let mk_class_type_name ci =
    ci.caml_class_name ^ "_class_type" 


  module TypeMap = Map.Make(
    struct
      type t = Ast.ctyp
      let compare = Pervasives.compare
    end)

  let external_classes =
    let module M = Map.Make(struct type t = string let compare = Pervasives.compare end) in
  object 
    val mutable c : string M.t = M.empty 
    method add x y = c <- M.add x y c 
    method get x = try Some (M.find x c) with Not_found -> None 
  end


  let rec arg_count ?(acc=0) = function
    | <:ctyp< $t0$ -> $t1$ >> -> arg_count ~acc:(acc+1) t1
    | t -> acc
      
  (** Génère un class_decl à partir 
      d'un class_info et d'un class_expr 
      @param class_info_and_expr class_info * class_expr
      @return le class_decl généré
  *)
  let generate_class_and_module map (ci, ce) =
    
    let v = match ci.is_virtual with
      | true -> <:virtual_flag< (* virtual *) >>
      | false -> <:virtual_flag< >> 
    in
      
    let t_name_str = "t_" ^ ci.caml_class_name in
    let t_name_str' = "t_" ^ ci.caml_class_name ^ "'" in
    let t_name = <:ident< $lid:t_name_str$ >> in
    let t_name' = <:ident< $lid:t_name_str'$ >> in
    let class_type_name = mk_class_type_name ci in


    let map = 
      TypeMap.add (snd ce.class_self_patt) 
      <:ctyp< $lid:class_type_name$ >> map 
    in
      
    let type_matching = function
      | e when TypeMap.mem e map -> TypeMap.find e map
      | e -> e
    in
      
    let map_types = Ast.map_ctyp type_matching in
	  
    let mk_auto_cpp_class_str_item map = function
      | Method(s1,typ,s2) -> Method(s1, map#ctyp typ, s2)
      | Constructor(s1,typ,s2) -> Constructor(s1, map#ctyp typ, s2)
      | t -> t
    in

    let mk_auto_cpp_class_expr map cpp_ce = 
      { cpp_ce with 
	  str_items = List.map (mk_auto_cpp_class_str_item map) cpp_ce.str_items ;
	  class_self_patt = (fst cpp_ce.class_self_patt, map#ctyp (snd cpp_ce.class_self_patt))
      }
    in

    let auto_ce = mk_auto_cpp_class_expr map_types ce in



    (** Création du class type *)

    let process_class_sig_item = function
      | Method (label, type_meth, _) ->
	  <:class_sig_item< method $lid:label$ : $type_meth$ >>
      | Inherit (class_name,_,_,_) ->
	  <:class_sig_item< inherit $lid:class_name$ >>
      | FullClassStrItem(_,class_sig_item) -> class_sig_item
      | Constructor _ -> <:class_sig_item< >>
      | ClassStrItem _ -> failwith "la classe n'a pas du être déclarée en auto"
    in
      
    let mk_class_type () =
      let sig_items = Ast.cgSem_of_list (List.map process_class_sig_item ce.str_items) in
	<:str_item<
          class type $virtual:v$ $lid:class_type_name$ [ $ci.params$ ] =
          object ( $snd ce.class_self_patt$ )
            value $lid:t_name_str$ : t ;
	    method $lid:"rep__"^ci.cpp_class_name$ : t ;
	    method destroy : unit ;
	    $sig_items$ ;
	  end >>
    in





    (** Création de la class *)

    let return_object typ = 
      let self = snd ce.class_self_patt in
      let rec get_return_type = function
	| <:ctyp< ! $_$ . $t$ >> -> get_return_type t
	| <:ctyp< $_$ -> $t$ >> -> get_return_type t
	| t -> t
      in
      get_return_type typ = self
    in


    let app_params_to_func func params = 
      List.fold_left (fun e x -> <:expr< $e$ $x$ >>) func params
    in
	
    let process_class_str_item = function
      | Method (label, type_meth, _) ->
	  let fun_params, get_params =
	    match type_meth with
	      | <:ctyp< unit -> $t$ >> -> [ <:patt< $lid:"p1"$>> ],[]
	      | <:ctyp< ! $t0$ . unit -> $t$ >> -> [ <:patt< $lid:"p1"$>> ],[]
	      | type_meth ->
		  let n = ref 0 in
		  let rec aux = function
		    | <:ctyp< ! $t0$ . $t1$ >> -> aux t1 
		    | <:ctyp< $t0$ -> $t1$ >> ->  (aux t1) @ (aux t0)
		    | <:ctyp< ~ $s$ : $t0$ >> -> [ <:patt< ~ $s$ >>, <:expr< ~ $s$ >> ]
		    | <:ctyp< ? $s$ : $t0$ >> -> [ <:patt< ? $s$ >>, <:expr< ? $s$ >> ]
		    | t -> let pn = "p"^(incr n; string_of_int !n) in
			[ <:patt< $lid:pn$ >>, <:expr< $lid:pn$ >> ]
		  in List.(split (rev (tl (aux type_meth)))) 
	  in
	  let func = <:expr< $uid:ci.module_name$.$lid:label$ $id:t_name$ >> in
       	  let method_body = app_params_to_func func get_params in
	  let expr = List.fold_right (fun x mb -> <:expr< fun $x$ -> $mb$ >>) 
	    fun_params method_body in 
       	    <:class_str_item< method $label$ : $type_meth$ =  $expr$ >>
           
      | Inherit(parent_name,inherit_expr,_,_) -> 
	  let inherit_body = <:expr< ( $uid:ci.module_name$.$lid:"to_"^parent_name$ $id:t_name'$ ) >> in
	    inherit_expr inherit_body

      | ClassStrItem e -> e
      | FullClassStrItem (e,_) -> e

      | _ -> <:class_str_item< >>
    in

    let mk_class () =

      let val_t = <:class_str_item< value $lid:t_name_str$ : $uid:ci.module_name$.$lid:"t"$ = $id:t_name'$ >> in
      let rep_method = <:class_str_item< method $lid:"rep__"^ci.cpp_class_name$ = $id:t_name$ >> in
      let destroy_method = <:class_str_item< method destroy =  $uid:ci.module_name$.destroy $id:t_name$ >> in
      let class_str_items = val_t::rep_method::destroy_method::
	(List.map process_class_str_item auto_ce.str_items) in 
      let class_body = Ast.crSem_of_list class_str_items in 
      let patt = <:patt< $lid:t_name_str'$ >> in
      let self_patt = <:patt< ($fst ce.class_self_patt$ : $snd ce.class_self_patt$) >>
      in
	<:class_expr< 
	  $virtual:v$ $lid:ci.caml_class_name$ [ $ci.params$ ] =
	  fun $patt$ ->
          object ( $self_patt$ )
	    $class_body$
	  end  >>
    in



      
    (** Création du module type *)

    let rec sig_item_of_str_item = function 
      | <:str_item< >> -> <:sig_item< >>
      | <:str_item< class type $class_type_decl$ >> -> <:sig_item< class type $typ:class_type_decl$ >>
      | <:str_item< $stmt1$ ; $stmt2$ >> ->  
	  <:sig_item< $sig_item_of_str_item stmt1$ ; $sig_item_of_str_item stmt2$ >>
      | <:str_item< # $s$ >> -> <:sig_item< # $s$ >>
      | <:str_item< # $s$ $e$ >> -> <:sig_item< # $s$ $e$ >>
      | <:str_item< exception $t$ >> -> <:sig_item< exception $t$ >>
      | <:str_item< exception $t$ = $i$ >> -> <:sig_item< exception $t$ >>
      | <:str_item< external $id$ : $type_ext$ = $string_list$ >> -> 
		      <:sig_item< external $lid:id$ : $typ:type_ext$ = $str_list:string_list$ >>
      | <:str_item< module rec $mb$ >> -> <:sig_item< module rec $mb$ >>
      | <:str_item< module type $s$ = $mt$ >> -> <:sig_item< module type $s$ = $mt$ >>
      | <:str_item< open $i$ >> -> <:sig_item< open $i$ >>
      | <:str_item< type $type_def$>> -> <:sig_item< type $typ:type_def$>> 
      | s -> raise (DebugSigItemConversion s)

    in

    (** Création du module *)

    (* ancienne version - à supprimer si ça marche *)
    (* let rec adapt_to_module = function 
      | <:ctyp< ! $t0$ . $t1$  >> -> adapt_to_module t1
      | <:ctyp< unit -> $t0$ -> $t1$ >> as tot -> tot
      | <:ctyp< unit -> $t0$ >> -> <:ctyp< $t0$ >>
      | tot -> tot
    in *)

    let adapt_to_module t =  
      let self = snd ce.class_self_patt in
      let aux = function 
	| <:ctyp< ! $t0$ . $t1$  >> -> t1
	| typ when typ = self -> t
	| typ -> typ
      in
      (Ast.map_ctyp aux)#ctyp
    in

    let make_string_list cpp_name ft =
      let base_nom = ci.cpp_class_name^"_"^cpp_name in
      let open Ast in
      let base_list = LCons (base_nom^"__impl", LNil) in
	if (arg_count ft) > 5
	then LCons (base_nom^"__byte", base_list)
	else base_list
    in

    let process_mod_str_item = function
      | Method (label, tf, cpp_name) ->
	  let t = <:ctyp< $lid:"t"$ >> in
	  let type_func = <:ctyp< $t$ -> $adapt_to_module t tf$>> in
	  let string_list = make_string_list cpp_name type_func in 
	    <:str_item< external $label$ : $type_func$ = $string_list$ >> 

      | Inherit(parent_name, _, cpp_parent_class_name, parent_module_name) ->
	  let upcast_func_name = "upcast__"^cpp_parent_class_name^"_of_"^ ci.cpp_class_name ^"__impl" in
	  let upcast_func_list = Ast.( LCons (upcast_func_name, LNil)) in
	  let type_func = <:ctyp< t -> $uid:parent_module_name$.t >> in
	    <:str_item< external $"to_"^parent_name$ : $type_func$ = $upcast_func_list$ >>

      | Constructor(label, tf, cpp_name) ->
	  let rec enfouir = function
	    | <:ctyp< $t0$ -> $t1$ >> -> <:ctyp< $t0$ -> $enfouir t1$ >>
	    | t' -> <:ctyp< $t'$ -> $lid:"t"$ >> in
	    (** if there is only one function as argument you should before create an alias to its type *)
	  let type_func = enfouir tf in
	  let string_list = make_string_list cpp_name type_func in 
	    <:str_item< external $label$ : $type_func$ = $string_list$ >>
	  
      | _ -> <:str_item< >>
    in

    let mk_module () =
      let type_t = <:str_item< type $lid:"t"$ >> in
      let class_type = if auto_ce.is_auto then mk_class_type () else <:str_item< >> in
      let destroy_fct = <:str_item< external destroy : $lid:"t"$ -> unit = 
	$make_string_list "destroy" <:ctyp< t -> unit >> $ >> in
      let mod_str_items = type_t :: class_type :: destroy_fct ::
	(List.map process_mod_str_item auto_ce.str_items) in 
      let mod_body = Ast.stSem_of_list mod_str_items in
      let mod_type_body = sig_item_of_str_item mod_body in
	<:module_expr< struct $mod_body$ end >>, 
        <:module_type< sig $mod_type_body$ end >>
    in

    let mk_create_helper () =
      let ext_name = "external_cpp_create_"^ci.cpp_class_name in
      <:str_item< 
	  let $lid:ext_name$ t = new $lid:ci.caml_class_name$ t in
	  Callback.register $str:ext_name$ $lid:ext_name$
	 >>
    in
    let class_decl = mk_class () in
    let mod_expr, mod_type = mk_module () in
    let helper_decl = 
     (* if ci.is_virtual 
      then <:str_item< >> 
      else *) mk_create_helper ()
    in	  
      mk_class_declaration ~class_decl ~mod_expr ~helper_decl ~mod_type ~mod_name:ci.module_name
	

  let extract_type_info acc (ci,ce) =
    let class_type_name = mk_class_type_name ci in
      TypeMap.add <:ctyp< $lid:ci.caml_class_name$ >> 
      <:ctyp< $uid:ci.module_name$.$lid:class_type_name$ >> acc





  (** Génère un str_item correspondant aux entrées
      @param class_list une liste des classes définies
      aprés un external cpp ( (class_info * class_expr) list )
      @return le str_item correspondant
  *)

  (* FIXME : le paramètre only_module n'est pas employé *)
  let generate_all only_module = function 
    | [] -> failwith "empty class" 
    | [x] -> 
	let declaration = generate_class_and_module TypeMap.empty x in
	if only_module
	then <:str_item< module $declaration.mod_name$ = $declaration.mod_expr$ >>
	else
	  Ast.stSem_of_list
	    [ <:str_item< module $declaration.mod_name$ = $declaration.mod_expr$ >> ;
	      <:str_item< class $declaration.class_decl$ >> ;
	      declaration.helper_decl ]
    | l -> 
	let is_not_auto (ci,ce) = not ce.is_auto in
	  if List.filter is_not_auto l <> []
	  then 
	    let error_msg = 
	      String.concat ", " 
		("some classes should be specified as auto : " ::
		(List.map (fun (ci,_) -> ci.caml_class_name) l))
	    in
	    failwith error_msg
	  else
	    let types_map = List.fold_left extract_type_info TypeMap.empty l in
	    let declaration_list = List.map (generate_class_and_module types_map) l in
	    let head,tail = List.( hd declaration_list, tl declaration_list ) in
	    let module_binding = 
	      let mk_module d = <:module_binding< $d.mod_name$ : $d.mod_type$ = $d.mod_expr$ >> in
	      let bind mod_bind d = <:module_binding< $mod_bind$ and $mk_module d$ >> in
		List.fold_left bind (mk_module head) tail in
	    if only_module
	    then <:str_item< module rec $module_binding$ >>
	    else
	      let class_binding =
		let bind class_bind d = <:class_expr< $class_bind$ and $d.class_decl$ >> in
		List.fold_left bind head.class_decl tail in
	      let helpers_decl = Ast.stSem_of_list 
		(List.map (fun x -> x.helper_decl) declaration_list) in
	      Ast.stSem_of_list
		[ <:str_item< module rec $module_binding$ >> ;
		  <:str_item< class $class_binding$ >> ;
		  helpers_decl ]
end
