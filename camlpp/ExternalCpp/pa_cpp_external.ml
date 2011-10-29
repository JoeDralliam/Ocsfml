open Camlp4 
  
module Id : Sig.Id = 
struct 
  let name = "external_cpp" 
  let version = "0.1" 
end 

module Make (Syntax : Sig.Camlp4Syntax) = 
struct 
  open Sig 
  include Synthese.Make(Syntax)
			
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
	 generate_all cpp
     | "external" ; OPT "cpp" ; i = a_LIDENT ; ":" ; t = ctyp; "=" ; s = a_STRING -> 
	 <:str_item< external $i$ : $t$ = $Ast.LCons (s^"__impl", Ast.LNil)$ >> 
     | "external" ; "c" ; i = a_LIDENT ; ":" ; t = ctyp; "=" ; s = string_list -> 
	 <:str_item<external $i$ : $t$ = $s$ >> 
     ]
   ];

   cpp_class_declaration:
   [ LEFTA
     [ c1 = SELF; "and"; c2 = SELF -> c1 @ c2
     | ci = cpp_class_info_for_class_expr; "="; ce = cpp_class_expr -> [ci,ce]
     ] 
   ];

   cpp_class_info_for_class_expr:
   [ 
     [ is_virtual = OPT [ "virtual" -> () ]; 
       (caml_class_name, params) = class_name_and_param ;  
       module_name = OPT [ "("; s = a_UIDENT ; ")" -> s ] ; 
       cpp_class_name = OPT [":"; cpp_name = a_STRING -> cpp_name ] ->
	 mk_class_info ~is_virtual ~caml_class_name ~module_name ~cpp_class_name ~params
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
	str_items = cpp_class_structure; "end" ->
	    mk_cpp_class_expr 
	      ~expr:(fun x -> <:class_expr< object (*$csp$*) $x$ end >>) 
	      ~str_items ~csp  ()

     | "object" ; "auto" ; "(" ; s = patt ; t = ctyp ; ")" ; 
	str_items = full_cpp_class_structure ; "end" -> 
	  mk_cpp_class_expr  
	    ~expr:(fun x -> <:class_expr< object (*$csp$*) $x$ end >>) 
	    ~auto:true ~str_items ~csp ()

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
     [ "external" ; "inherit"; (caml_name,ce) = cpp_class_longident_and_param ; 
       cpp_name = OPT [ ":" ; s = a_STRING -> s] ; pb = opt_as_lident -> 
	 mk_inherit ~caml_name ~cpp_name 
	   ~expr:(fun x -> <:class_str_item< inherit $ce$ begin $x$ end as $pb$ >>)

     | "external" ; "method" ; caml_name = label; ":"; 
       caml_type = poly_type ; "=" ; cpp_name = a_STRING -> 
	 mk_method ~caml_name ~caml_type ~cpp_name
	  
     | "constructor" ; caml_name = label; ":"; parameters_type = ctyp ; 
       "=" ; cpp_name = a_STRING -> 
	 mk_constructor ~caml_name ~parameters_type ~cpp_name

     | class_str_item = class_str_item -> mk_class_str_item ~class_str_item
     ] 
   ];
    

   full_cpp_class_structure:
     [
       [ 
	 l = LIST0 [ cst = full_cpp_class_str_item; semi -> cst ] -> l 
       ]
     ];

   
   full_cpp_class_str_item:
   [ LEFTA
     [ "external" ; "inherit"; (caml_name,ce) = cpp_class_longident_and_param ; 
       cpp_name = OPT [ ":" ; s = a_STRING -> s] ; pb = opt_as_lident -> 
	 mk_inherit ~caml_name ~cpp_name 
	   ~expr:(fun x -> <:class_str_item< inherit $ce$ begin $x$ end as $pb$ >>)

     | "external" ; "method" ; caml_name = label; ":"; 
       caml_type = poly_type ; "=" ; cpp_name = a_STRING -> 
	 mk_method ~caml_name ~caml_type ~cpp_name
	  
     | "constructor" ; caml_name = label; ":"; parameters_type = ctyp ; 
       "=" ; cpp_name = a_STRING -> 
	 mk_constructor ~caml_name ~parameters_type ~cpp_name

     | (class_str_item, class_sig_item) = full_class_str_item -> 
	 mk_full_class_str_item ~class_str_item ~class_sig_item
     ] 
   ];

   (*tous les items doivent avoir un type explicite -  ce n'est pas encore le cas *)
   full_class_str_item:
      [ LEFTA
        [ "inherit"; o = opt_override; ce = class_longident_and_param; pb = opt_as_lident ->
            <:class_str_item< inherit $override:o$ $ce$ as $pb$ >>,
	    <:class_sig_item< inherit $cs$ >>

        | o = value_val_opt_override; mf = opt_mutable; 
	  lab = label; ":" ; t = poly_type ; 
	  "=" ; e = expr ->
            <:class_str_item< value $override:o$ $mutable:mf$ $lab$ = $e$ >>,
	    <:class_sig_item< value $mutable:mf$ $lab$ : $t$ >>

        | o = value_val_opt_override; mf = opt_mutable; "virtual"; l = label; ":"; t = poly_type ->
            if o <> <:override_flag<>> then
              raise (Stream.Error "override (!) is incompatible with virtual")
            else
              <:class_str_item< value virtual $mutable:mf$ $l$ : $t$ >>,
	    <:class_sig_item< value $mutable:mf$ virtual $lab$ : $t$ >>

        | o = value_val_opt_override; "virtual"; mf = opt_mutable; l = label; ":"; t = poly_type ->
            if o <> <:override_flag<>> then
              raise (Stream.Error "override (!) is incompatible with virtual")
            else
              <:class_str_item< value $mutable:mf$ virtual $l$ : $t$ >>,
	    <:class_sig_item< value $mutable:mf$ virtual $l$ : $t$ >>

        | o = method_opt_override; pf = opt_private; l = label; ":" ; t = poly_type ; e = fun_binding ->
            <:class_str_item< method $override:o$ $private:pf$ $l$ : $t$ = $e$ >>,
	    <:class_sig_item< method $private:pf$ $l$ : $t$ >> 

	| o = method_opt_override; "virtual"; pf = opt_private; l = label; ":"; t = poly_type ->
            if o <> <:override_flag<>> then
              raise (Stream.Error "override (!) is incompatible with virtual")
            else
              <:class_str_item< method virtual $private:pf$ $l$ : $t$ >>,
	    <:class_sig_item< method virtual $private:pf$ $l$ : $t$ >>

        | o = method_opt_override; pf = opt_private; "virtual"; l = label; ":"; t = poly_type ->
            if o <> <:override_flag<>> then
              raise (Stream.Error "override (!) is incompatible with virtual")
            else
              <:class_str_item< method virtual $private:pf$ $l$ : $t$ >>,
	    <:class_sig_item< method virtual $private:pf$ $l$ : $t$ >>

        | type_constraint; t1 = ctyp; "="; t2 = ctyp ->
            <:class_str_item< type $t1$ = $t2$ >>,
	    <:class_sig_item< type $t1$ = $t2$ >>

        | "initializer"; se = expr -> 
	    <:class_str_item< initializer $se$ >>,
	    <:class_sig_item< >>
	] ]
    ;

   END 
end 
  
module M = Register.OCamlSyntaxExtension(Id)(Make)

