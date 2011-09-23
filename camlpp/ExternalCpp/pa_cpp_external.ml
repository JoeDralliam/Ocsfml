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
     | "object" ; "auto" ; "(" ; s = patt ; t = ctyp ")" ; 
	l = full_cpp_class_structure ; "end" -> 
	  create_cpp_class_expr ~auto:true (fun x -> <:class_expr< object (*$csp$*) $x$ end >>) l csp
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
    

   cpp_class_structure:
     [
       [ 
	 l = LIST0 [ cst = full_cpp_class_str_item; semi -> cst ] -> l 
       ]
     ];

   (*tous les items doivent avoir un type explicite*)
   full_cpp_class_str_item:
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
