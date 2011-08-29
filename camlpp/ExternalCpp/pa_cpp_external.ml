open Camlp4 
  
module Id : Sig.Id = 
struct 
  let name = "cpp_external" 
  let version = "0.0" 
end 

module Make (Syntax : Sig.Camlp4Syntax) = 
struct 
  open Sig 
  include Syntax 

  let _loc = Loc.ghost

  let lid_to_uid s = let s' = String.copy s in s'.[0] <- Char.uppercase s'.[0] ; s'

  let rec arg_count ?(n=0) = function
      Ast.TyArr (_,_,t) -> arg_count ~n:(n+1) t
    | Ast.TyPol (_,_,t) -> arg_count ~n t
    | _ -> n

  let rec enfouir t0 = function
      Ast.TyArr (loc,t',t) -> Ast.TyArr (loc,t',enfouir t0 t)
    | t -> <:ctyp< $t$ -> $t0$ >>

  let rec range ?(acc=[]) a b = if a > b then acc else range ~acc:(b::acc) a (b-1)
  let create_params_expr e i = List.fold_left (fun e i -> <:expr< $e$ $lid:"p"^ (string_of_int i)$>>) e (range 1 i)
  let create_params_patt e i = List.fold_right (fun i e -> <:expr< fun $lid:"p"^ (string_of_int i)$ -> $e$ >>)  (range 1 i) e


  type cpp_clas_str_item =
      Inherit of string * (Ast.expr -> Ast.class_str_item) * string option
    | Method of string * Ast.ctyp * string
    | Constructor of string * Ast.ctyp * string
    | ClassStrItem of Ast.class_str_item

  type cpp_class_expr =
    { cpp_class_name : string option ; expr : Ast.class_str_item -> Ast.class_expr; str_items : cpp_clas_str_item list }

  let get_class_name = function
    | <:class_expr< $lid:s$ $_$ >> -> s
    | _ -> assert false

  let rec simplify_type = function
    | (Ast.TyArr (_,<:ctyp<unit>>,t)) as t' -> if arg_count t = 0 then t else t'
    | Ast.TyPol (loc,t0,t) -> Ast.TyPol (loc,t0,simplify_type t)
    | t -> t

  let rec adapt_to_module = function
    | Ast.TyPol (_,_,t) -> adapt_to_module t
    | t -> t

  let mk_class_body class_name cpp_class_name module_name str_items =
    let t_name = "t_"^class_name in
    let t_name' = "t_"^class_name^"'" in
    let aux = function
      | Inherit(parent_name,s,_) -> s <:expr< ( $module_name$.$lid:"to_"^parent_name$ $lid:t_name'$ ) >> 
      | Method(label, type_method, cpp_name) -> 
	  let count = arg_count type_method in
	  let t' = simplify_type type_method in
	    if t' <> type_method 
	    then <:class_str_item< method $label$ () = $module_name$.$lid:label$ $lid:t_name$ >>
	    else let appel_func = <:expr< $module_name$.$lid:label$ $lid:t_name$ >> in
	    let ajout_param = <:expr< $create_params_expr appel_func count$ >> in
	      <:class_str_item< method $label$ : $type_method$ = $create_params_patt ajout_param count$>>
      | Constructor _ -> <:class_str_item< >> 
      | ClassStrItem e -> e
    in
      Ast.crSem_of_list (
	<:class_str_item< value $lid:t_name$ = $lid:t_name'$ >> ::
<:class_str_item< method $lid:"rep__"^cpp_class_name$ = $lid:t_name$ >> :: 
	  (List.map aux str_items)) ;;

  let mk_module_body class_name cpp_class_name str_items =  
    let t_name = "t_"^class_name in
    let aux = function
      | Inherit(parent_name,_,p) -> 
	  let cpp_parent_class_name = match p with
	    | Some s -> s 
	    | None -> class_name in
	  let sl = Ast.LCons (("upcast__"^cpp_parent_class_name^"_of_"^ cpp_class_name ^"__impl"), Ast.LNil) in
	    <:str_item< external $"to_"^parent_name$ : $lid:t_name$ -> $uid:lid_to_uid parent_name$.$lid:"t_"^parent_name$ = $sl$ >>
      | Method(label, type_method, cpp_name) -> <:str_item< external $label$ : $lid:t_name$ -> $simplify_type (adapt_to_module type_method)$ = $Ast.LCons (cpp_class_name^"_"^cpp_name^"__impl", Ast.LNil)$ >>
      | Constructor(label, type_method, cpp_name) -> <:str_item< external $label$ : $enfouir <:ctyp<$lid:t_name$>> (adapt_to_module type_method)$ = $Ast.LCons (cpp_class_name^"_"^cpp_name^"__impl", Ast.LNil)$ >>
      | ClassStrItem _ -> <:str_item< >>
    in
      Ast.stSem_of_list (<:str_item< type $lid:t_name$>>::(List.map aux str_items)) 

  let generate_class_and_module ci ce =
    let (class_info, class_name) = ci in
    let { cpp_class_name = cpp_class_name_opt ; expr = expr; str_items = str_items } = ce in
    let module_name = lid_to_uid class_name in 
    let cpp_class_name = match cpp_class_name_opt with None -> class_name | Some s -> s in
    let items = (Method("destroy", <:ctyp< unit -> unit >>, "destroy"))::str_items in
      <:class_expr< $class_info$ = fun $lid:"t_"^class_name^"'"$ -> $expr (mk_class_body class_name cpp_class_name <:expr< $lid:module_name$>> items)$ >> , 
    <:str_item< module $module_name$ = struct $mk_module_body class_name cpp_class_name items$ end >>

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
   [ [ "external"; "class" ; (cd,md) = cpp_class_declaration -> 
	 Ast.stSem_of_list [md ; <:str_item< class $cd$ >> ]
	 | "external" ; OPT "cpp" ; i = a_LIDENT ; ":" ; t = ctyp; "=" ; s = a_STRING -> <:str_item< external $i$ : $t$ = $Ast.LCons (s^"__impl", Ast.LNil)$ >> 
	 | "external" ; "c" ; i = a_LIDENT ; ":" ; t = ctyp; "=" ; s = string_list -> <:str_item<external $i$ : $t$ = $s$ >> ]
   ];

   cpp_class_str_item:
      [ LEFTA
          [ "external" ; "inherit"; (ci,ce) = cpp_class_longident_and_param ; cpp_class_name = OPT [ ":" ; s = a_STRING -> s] ; pb = opt_as_lident -> 
	      Inherit(ci,(fun x -> <:class_str_item< inherit $ce$ begin $x$ end as $pb$ >>), cpp_class_name)
	  | "external" ; "method" ; l = label; ":"; topt = poly_type ; "=" ; cpp_name = a_STRING -> Method(l,topt, cpp_name)	  
	  | "constructor" ; l = label; ":"; topt = poly_type ; "=" ; cpp_name = a_STRING -> Constructor(l,topt, cpp_name) 
	  | e = class_str_item -> ClassStrItem(e)
	  ] 
      ];

   cpp_class_longident_and_param:
      [ [ ci = a_LIDENT; "["; t = comma_ctyp; "]" ->
	    let ci' = <:ident<$lid:ci$>> in
ci,<:class_expr< $id:ci'$ [ $t$ ] >>
        | ci = a_LIDENT ->let ci' = <:ident<$lid:ci$>> in ci,<:class_expr< $id:ci'$ >>
      ] ]
    ;

    cpp_class_structure:
      [[ l = LIST0 [ cst = cpp_class_str_item; semi -> cst ] -> l ]];

   cpp_class_expr:
      [ "apply" NONA
        [ ce = SELF; e = expr LEVEL "label" -> 
	    {ce with expr = (fun x -> <:class_expr< $ce.expr x$ $e$ >>)} ]
      | "simple"
        [  ce = class_longident_and_param -> {cpp_class_name = None; expr = (fun x -> ce) ; str_items = [] }
        | "object"; csp = opt_class_self_patt; l = cpp_class_structure; "end" ->
	    { cpp_class_name = None ; expr = (fun x -> <:class_expr< object ($csp$) $x$ end >>) ; str_items = l }
        | "("; ce = SELF; ":"; ct = class_type; ")" -> 
	    {ce with expr = (fun x -> <:class_expr< ($ce.expr x$ : $ct$) >>) }
        | "("; ce = SELF; ")" -> ce 
	] ];

   cpp_class_fun_binding:
   [ [ "="; ce = cpp_class_expr -> ce
     | ":"; cpp_name = a_STRING; "="; ce = cpp_class_expr -> { ce with cpp_class_name = Some cpp_name }
     ] ];

   cpp_class_info_for_class_expr:
   [ 
     [ mv = opt_virtual; (i, ot) = class_name_and_param ->
         <:class_expr< $virtual:mv$ $lid:i$ [ $ot$ ] >>, i
     ] 
   ];
      
   cpp_class_declaration:
   [ LEFTA
       [ (c1,m1) = SELF; "and"; (c2,m2) = SELF ->
           <:class_expr< $c1$ and $c2$ >>, Ast.stSem_of_list [m1 ; m2] 
           | ci = cpp_class_info_for_class_expr; ce = cpp_class_fun_binding ->
	       generate_class_and_module ci ce
   ] ];
      
   

    
    END 
end 
  
module M = Register.OCamlSyntaxExtension(Id)(Make)
