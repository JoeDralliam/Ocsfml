open Camlp4
open Sig

module Make(Syntax : Camlp4Syntax) =
struct

  include Syntax

  let _loc = Loc.ghost

  (** transforme un identifiant commençant par une minuscule 
      en identifiant commençant par une majuscule
      @param lid un identifiant commençant par une minuscule (string)
      @return un identifiant commençant par une majuscule
  *)
  let lid_to_uid = String.capitalize 


  (**
     Décrit les éléments rencontrés lors de l'analyse d'une classe externe
     Il peut s'agir :
     {ul 
     { - d'un héritage : 
         nom de la classe dont il hérite (caml),
         fonction fabriquant l'expression d'héritage dans le code final,
         nom (optionnel) de la classe dont il hérite (cpp)
     }
     { - d'une méthode externe : 
         nom de la méthode en caml, 
         type caml, 
         nom de la méthode en cpp }
     { - d'un constructeur cpp : 
         nom de la fonction en caml, 
         type des paramètres caml, 
         nom de la méthode en cpp }
     { - d'un élément classique (définition caml d'un élément d'une classe) }
     }
  *)
  type cpp_clas_str_item = 
      Inherit of string * (Ast.expr -> Ast.class_str_item) * string 
    | Method of string * Ast.ctyp * string
    | Constructor of string * Ast.ctyp * string
    | ClassStrItem of Ast.class_str_item
    | FullClassStrItem of Ast.class_str_item * Ast.class_sig_item


  (** fabrique un cpp_class_str_item correspondant à un héritage *)
  let mk_inherit ~caml_name ~inherit_expr ~cpp_name =
    let cpp_parent_class_name = 
      match cpp_name with
	| None -> caml_name
	| Some name -> name in
      Inherit (caml_name, inherit_expr, cpp_parent_class_name)

  (** fabrique un cpp_class_str_item correspondant à une méthode *)
  let mk_method ~caml_name ~caml_type ~cpp_name =
    Method (caml_name, caml_type, cpp_name)

  (** fabrique un cpp_class_str_item correspondant à un constructeur *)
  let mk_constructor ~caml_name ~parameters_type ~cpp_name =
    Constructor (caml_name, parameters_type, cpp_name)

  (** fabrique un cpp_class_str_item correspondant à un class_str_item classique *)
  let mk_class_str_item ~class_str_item =
    ClassStrItem class_str_item

  (** fabrique un cpp_class_str_item correspondant 
      à un class_str_item et un class_sig_item classique *)
  let mk_full_class_str_item ~class_str_item ~class_sig_item =
    FullClassStrItem (class_str_item, class_sig_item)





  (** type d'une expression de classe externe composé de :
      {ul
      { - expr : associe une expression de classe au corps de la classe }
      { - str_items : la liste des instructions dans le corps de la classe }
      { - class_self_patt : le pattern et le type représentant la classe elle même }
      { - is_auto : vrai si la classe fait appel à son propre type }
      }
  *)
  type cpp_class_expr = 
    { 
      expr : Ast.class_str_item -> Ast.class_expr; 
      str_items : cpp_clas_str_item list ;
      class_self_patt : Ast.patt * Ast.ctyp ;
      is_auto : bool ;
    }


  (** fabrique un cpp_class_expr *)
  let mk_cpp_class_expr ?(auto=false) ~expr ~str_items ~csp () =
    let class_self_patt = 
      match csp with
	| None -> <:patt< self >>, <:ctyp< 'self >>
	| Some (s, t0) -> 
	    let t =
	      match t0 with
		| Some t -> t
		| None -> <:ctyp< 'self >>
	    in s, t
    in
      {
	expr = expr ;
	str_items = str_items;
	class_self_patt = class_self_patt;
	is_auto = auto
      }






  (** contient les informations sur la classe :
      {ul
      { - is_virtual : la classe est_elle abstraite ? }
      { - caml_class_name : le nom de la classe }
      { - module_name : le nom du module associé }
      { - params : types paramétrant la classe ('a) }
      }
  *)
  type class_info = 
      {
	is_virtual : bool;
	caml_class_name : string; 
	module_name : string;
	cpp_class_name : string;
	params : Ast.ctyp
      }

	
  (** fabrique un class info *)
  let mk_class_info ~is_virtual ~caml_class_name ~module_name ~cpp_class_name ~params =
    {
      is_virtual = (match is_virtual with Some _ -> true | None -> false);
      caml_class_name = caml_class_name; 
      module_name = (match module_name with Some s -> s | None -> lid_to_uid caml_class_name);
      cpp_class_name = (match cpp_class_name with Some s -> s | None -> caml_class_name);
      params = params
    }





  (** déclaration d'une classe externe, contient : 
      {ul
      {- class_decl : une expression de classe }
      {- mod_decl : l'expression de module correspondant }
      {- helper_decl : fonction permettant de créer la classe depuis le cpp }
      }
  *)    
  type class_decl =
      {
	class_decl : Ast.class_expr;
	mod_name : string ;
	mod_expr : Ast.module_expr;
	mod_type : Ast.module_type;
	helper_decl : Ast.str_item;
      }


  (** fabrique une class_decl *)
  let mk_class_declaration ~class_decl ~mod_name ~mod_expr ~mod_type ~helper_decl =
      {
	class_decl = class_decl; 
	mod_expr = mod_expr;
	helper_decl = helper_decl;
	mod_name = mod_name ;
	mod_type = mod_type
      }



end
