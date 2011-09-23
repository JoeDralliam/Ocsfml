open Camlp4 
  
module Id : Sig.Id = 
struct 
  let name = "external_cpp" 
  let version = "0.1" 
end 

module Make (Syntax : Sig.Camlp4Syntax) = 
struct 
  open Sig 
  include Syntax 

  let _loc = Loc.ghost

  let lid_to_uid s = let s' = String.copy s in s'.[0] <- Char.uppercase s'.[0] ; s'

  type cpp_clas_str_item = 
      Inherit of string * (Ast.expr -> Ast.class_str_item) * string option
    | Method of string * Ast.ctyp * string
    | Constructor of string * Ast.ctyp * string
    | ClassStrItem of Ast.class_str_item

  type cpp_class_expr =
    { 
      expr : Ast.class_str_item -> Ast.class_expr; 
      str_items : cpp_clas_str_item list ;
      class_self_patt : Ast.patt * Ast.ctyp
    }

  let create_cpp_class_expr expr str_items csp =
    {
      expr = expr ;
      str_items = str_items;
      class_self_patt = 
	(match csp with
	   | Some (s, t0 ) -> 
	       s, (match t0 with
		     | Some t -> t
		     | None -> <:ctyp< 'self >>)
	   | None -> <:patt< self >>, <:ctyp< 'self >>)
    }

  type class_info = 
      {
	is_virtual : bool;
	caml_class_name : string; 
	module_name : string;
	cpp_class_name : string;
	params : Ast.ctyp
      }

  let create_class_info is_virtual caml_class_name module_name cpp_class_name params =
    {
      is_virtual = (match is_virtual with Some _ -> true | None -> false);
      caml_class_name = caml_class_name; 
      module_name = (match module_name with Some s -> s | None -> lid_to_uid caml_class_name);
      cpp_class_name = (match cpp_class_name with Some s -> s | None -> caml_class_name);
      params = params
    }

  type class_decl =
      {
	class_decl : Ast.class_expr;
	mod_decl : Ast.module_binding;
	helper_decl : Ast.str_item;
	is_rec : bool;
      }

  let create_class_declaration ?(is_rec=false) class_decl mod_decl helper_decl =
      {
	class_decl = class_decl; 
	mod_decl = mod_decl;
	helper_decl = helper_decl;
	is_rec = is_rec;
      }

  let app_params_to_func func params =
    List.fold_left (fun e x -> <:expr< $e$ $x$ >>) func params
	      
  let generate_class_and_module ci ce =
    
    let v = match ci.is_virtual with
      | true -> <:virtual_flag< virtual >>
      | false -> <:virtual_flag< >> 
    in
      
    let t_name = <:ident< $lid:"t_" ^ ci.caml_class_name$ >> in
      
    let process_class_sig_item = function
      | Method (label, type_meth, _) ->
	  <:class_sig_item< method $lid:label$ : $type_meth$ >>
      | Inherit (class_name,_,_) ->
	  <:class_sig_item< inherit $lid:class_name$ >>
      | _ -> <:class_sig_item< >>
	  (*
	    il manque les commandes caml classiques ; 
	    mais comment transformer un class_str_item en class_sig_item ?
	  *)
    in
      
    let class_type_name = ci.caml_class_name ^ "_class_type" in
      
    let mk_class_type () =
      let sig_items = Ast.cgSem_of_list (List.map process_class_sig_item ce.str_items) in
	<:str_item<
          class type $virtual:v$ $lid:class_type_name$ [ $list:ci.params$ ] =
          object
	    $sig_items$
	  end >>
    in

    let process_class_str_item = function
      | Method (label, type_meth, _) ->
	  let fun_params, get_params =
	    let n = ref 1 in
	    let rec aux = function
	      | <:ctyp< ! $t0$ . $t1$ >> -> aux t1 
	      | <:ctyp< $t0$ -> $t1$ >> -> (aux t0) @ (aux t1)
	      | <:ctyp< ~ $s$ : $t0$ -> $t1$ >> -> [ <:patt< ~ $s$ >>, <:expr< ~ $s$ >> ] @ (aux t1)
	      | <:ctyp< ? $s$ : $t0$ -> $t1$ >> -> [ <:patt< ? $s$ >>, <:expr< ? $s$ >> ] @ (aux t1)
	      | t -> let pn = "p"^(incr n; string_of_int !n) in
		  [ <:patt< $lid:pn$ >>, <:expr< $lid:pn$ >> ]
	    in List.split (aux type_meth) in
	  let func = <:expr< $ci.module_name$.$label$ $t_name$ >> in
	  let method_body = app_params_to_func func get_params in
	    <:class_str_item< method $label$ : $type_meth$ =  fun $fun_params$ -> $method_body$ >>

      | Inherit(parent_name,inherit_expr,_) -> 
	  let inherit_body = <:expr< ( $ci.module_name$.$lid:"to_"^parent_name$ $lid:t_name^"'"$ ) >> in
	    inherit_expr inherit_body

      | ClassStrItem e -> e

      | _ -> <:class_str_item< >>
    in

    let mk_class () =
      let val_t = <:class_str_item< value $lid:t_name$ = $lid:t_name^"'"$ >> in
      let rep_method = <:class_str_item< method $lid:"rep__"^ci.cpp_class_name$ = $lid:t_name$ >> in
      let class_str_items = val_t::rep_method::(List.map process_class_str_item ce.str_items) in
      let class_body = Ast.crSem_of_list class_str_items in
	<:class_expr< 
	  $virtual:v$ $lid:ci.caml_class_name$ [ $list:ci.params$ ] =
          object
	    $class_body$
	  end >>
    in

    let rec adapt_to_module = function
      | <:ctyp< ! $t0$ . $t1$  >> -> adapt_to_module t1
      | <:ctyp< unit -> $t0$ -> $t1$ >> as tot -> tot
      | <:ctyp< unit -> $t0$ >> -> <:ctyp< $lid:"t"$ -> $t0$ >>
      | tot -> tot
    in
      
    let rec erase_self_type = function
      | <:ctyp< $t0$ $t1$ >> -> 
	<:ctyp< $erase_self_type t0$ $erase_self_type t1$ >> 
      | <:ctyp< $t0$ -> $t1$ >> ->
	<:ctyp< $erase_self_type t0$ -> $erase_self_type t1$ >>
      | t when t = snd ce.class_self_patt -> <:ctyp< #$class_type_name$ >>
      | t -> t
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
	  let type_func = <:ctyp< $lid:t$ -> $erase_self_type (adapt_to_module tf)$>> in
	  let string_list = make_string_list cpp_name type_func in 
	    <:str_item< external $label$ : $type_func$ = $string_list$ >>
      | Inherit(parent_name, _, p) ->
	  let cpp_parent_class_name = match p with
	    | Some s -> s 
	    | None -> ci.caml_class_name in
	  let upcast_func_name = "upcast__"^cpp_parent_class_name^"_of_"^ cpp_class_name ^"__impl" in
	  let upcast_func_list = Ast.( LCons (upcast_func_name, LNil)) in
	  let type_func = <:ctyp< $lid:"t"$ -> $uid:lid_to_uid parent_name$.$lid:"t"$ >> in
	    <:str_item< external $"to"^parent_name$ : $type_func$ = $sl$ >>

      | Constructor(label, tf, cpp_name) ->
	  let rec enfouir = function
	    | <:ctyp< $t0$ -> $t1$ >> -> enfouir t1
	    | t' -> <:ctyp< $t'$ -> $lid:"t"$ >> in
	    (** if there is only one function as argument you should before create un alias to its type *)
	  let type_func = enfouir tf in
	  let string_list = make_string_list cpp_name type_func in 
	    <:str_item< external $label$ : $type_func$ = $string_list$ >>
	  
      | _ -> <:str_item< >>
    in
(** abandonner l'espoir de pouvoir faire des définitions récursives : il faudrait générer la signature du module *)
    let mk_module () =
      let type_t = <:str_item< type $lid:"t"$ >> in
      let class_type = mk_class_type () in
      let upcast_to_parent =  
	let upcast_name = "to_"^parent_name in
	let upcast_cpp_name = "upcast__"^cpp_parent_class_name^"_of_"^ cpp_class_name ^"__impl" in
	let upcast_type = <:ctyp< $lid:t_name$ -> $uid:lid_to_uid parent_name$.$lid:"t"$ >> in
	let string_list = Ast.(LCons (upcast_name, LNil)) in
	<:str_item< external $upcast_name$ : $upcast_type$ = $string_list$ >>
      in
      let mod_str_items = type_t :: class_type :: upcast_to_parent :: 
	(List.map process_mod_str_item ce.str_items) in
      let mod_body = Ast.stSem_of_list mod_str_items in
<:module_binding< $uid:ci.module_name$ = struct $mod_body$ end >>
    in

    let mk_create_helper () =
      let ext_name = "external_cpp_create_"^ci.cpp_class_name in
      <:str_item< 
	  let $lid:ext_name$ t = new $lid:class_name$ t in
	  Callback.register $str:ext_name$ $lid:ext_name$
	 >>
    in

      create_class_declaration 
	(mk_class ())
	(mk_module ())
	(if ci.is_virtual then mk_create_helper () else <:str_item< >>)

			
  let mk_anti ?(c = "") n s = "\\$"^n^c^":"^s;; 
			
  let string_list = Gram.Entry.mk "string_list";;

  DELETE_RULE Gram str_item:"external";a_LIDENT;":";ctyp;"=";string_list END; 

  EXTEND Gram 
    GLOBAL: str_item string_list;

   string_list:
     [ [ `ANTIQUOT((""|"str_list"),s) -> Ast.LAnt (mk_anti "str_list" s)
        | `STRING (_,x); xs = string_list -> Ast.LCons (x, xs)
        | `STRING (_,x) -> Ast.LCons (x, Ast.LNil) ] ];

   str_item: LEVEL "top" 
   [ 
     [ "external"; "class" ; cpp = cpp_class_declaration -> 
	 if cpp.is_rec 
	 then Ast.stSem_of_list [ <:str_item<module rec $cpp.mod_decl$>> ; <:str_item< class $cpp.class_decl$ >> ; cpp.helper_decl ]
	 else Ast.stSem_of_list [ <:str_item<module $cpp.mod_decl$>> ; <:str_item< class $cpp.class_decl$ >> ; cpp.helper_decl ]
     | "external" ; OPT "cpp" ; i = a_LIDENT ; ":" ; t = ctyp; "=" ; s = a_STRING -> 
	 <:str_item< external $i$ : $t$ = $Ast.LCons (s^"__impl", Ast.LNil)$ >> 
     | "external" ; "c" ; i = a_LIDENT ; ":" ; t = ctyp; "=" ; s = string_list -> 
	 <:str_item<external $i$ : $t$ = $s$ >> 
     ]
   ];

   cpp_class_declaration:
   [ LEFTA
     [c1 = SELF; "and"; c2 = SELF ->
	 create_class_declaration 
	   ~is_rec:true 
	   <:class_expr< $c1.class_decl$ and $c2.class_decl$ >> 
           <:module_binding< $c1.mod_decl$ and $c2.mod_decl$ >>  
	   (Ast.stSem_of_list [c1.helper_decl ; c2.helper_decl ])
     | ci = cpp_class_info_for_class_expr; "="; ce = cpp_class_expr ->
         generate_class_and_module ci ce
     ] 
   ];

   cpp_class_info_for_class_expr:
   [ 
     [ is_virtual = OPT [ "virtual" -> () ]; 
       (caml_class_name, params) = class_name_and_param ;  
       module_name = OPT [ "("; s = a_UIDENT ; ")" -> s ] ; 
       cpp_class_name = OPT [":"; cpp_name = a_STRING -> cpp_name ] ->
	 create_class_info is_virtual caml_class_name module_name cpp_class_name params
     ] 
   ];

   cpp_class_expr:
   [ "apply" NONA
     [ ce = SELF; e = expr LEVEL "label" -> 
	    {ce with expr = (fun x -> <:class_expr< $ce.expr x$ $e$ >>)} 
     ]
   | "simple"
     [  ce = class_longident_and_param -> create_cpp_class_expr (fun x -> ce) [] None 
     | "object"; 
	csp = OPT [ "(" ; 
		    s = patt ; 
		    st = OPT [":" ; t = ctyp -> t ] ; 
		    ")" -> s,st ] ;
	l = cpp_class_structure; "end" ->
	    create_cpp_class_expr (fun x -> <:class_expr< object (*$csp$*) $x$ end >>) l csp 
     | "("; ce = SELF; ":"; ct = class_type; ")" -> 
	    {ce with expr = (fun x -> <:class_expr< ($ce.expr x$ : $ct$) >>) } 
     | "("; ce = SELF; ")" -> ce 
     ] 
   ];

   cpp_class_longident_and_param:
   [ 
     [ ci = a_LIDENT; "["; t = comma_ctyp; "]" ->
	 let ci' = <:ident<$lid:ci$>> in
	   ci,<:class_expr< $id:ci'$ [ $t$ ] >>
     | ci = a_LIDENT ->let ci' = <:ident<$lid:ci$>> in ci,<:class_expr< $id:ci'$ >>
     ] 
   ];

   cpp_class_structure:
   [
     [ 
       l = LIST0 [ cst = cpp_class_str_item; semi -> cst ] -> l 
     ]
   ];

   cpp_class_str_item:
   [ LEFTA
     [ "external" ; "inherit"; (ci,ce) = cpp_class_longident_and_param ; cpp_class_name = OPT [ ":" ; s = a_STRING -> s] ; pb = opt_as_lident -> 
	 Inherit(ci,(fun x -> <:class_str_item< inherit $ce$ begin $x$ end as $pb$ >>), cpp_class_name)
     | "external" ; "method" ; l = label; ":"; topt = poly_type ; "=" ; cpp_name = a_STRING -> Method(l,topt, cpp_name)	  
     | "constructor" ; l = label; ":"; topt = ctyp ; "=" ; cpp_name = a_STRING -> Constructor(l,topt, cpp_name) 
     | e = class_str_item -> ClassStrItem(e)
     ] 
   ];
    
   END 
end 
  
module M = Register.OCamlSyntaxExtension(Id)(Make)
