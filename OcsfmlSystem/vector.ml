module type SCALAR =
sig
  type s

  val add : s -> s -> s
  val sub : s -> s -> s
  val mul : s -> s -> s
  val div : s -> s -> s
  val neg : s -> s 

  val zero : s
  val one : s
end

module Vector2(S : SCALAR) =
struct
  type s = S.s  
    
  type t = { x : s ; y : s }

  let add a b = { x = S.add a.x b.x ; y = S.add a.y b.y }
  let sub a b = { x = S.sub a.x b.x ; y = S.sub a.y b.y }
  let mul s a = { x = S.mul s a.x ; y = S.mul s a.y }
  let div s a = { x = S.div s a.x ; y = S.div s a.y }

  let zero = { x = S.zero ; y = S.zero }
  let canonical = { x = S.one ; y = S.zero }, { x = S.zero ; y = S.one }
end

module Vector3(S : SCALAR) =
struct
  type s = S.s  
    
  type t = { x : s ; y : s ; z : s }

  let add a b = { x = S.add a.x b.x ; y = S.add a.y b.y ; z = S.add a.z b.z }
  let sub a b = { x = S.sub a.x b.x ; y = S.sub a.y b.y ; z = S.sub a.z b.z }
  let mul s a = { x = S.mul s a.x ; y = S.mul s a.y ; z = S.mul s a.z }
  let div s a = { x = S.div s a.x ; y = S.div s a.y ; z = S.div s a.z }

  let zero = { x = S.zero ; y = S.zero ; z = S.zero }
  let canonical = 
    { x = S.one ; y = S.zero ; z = S.zero }, 
    { x = S.zero ; y = S.one ; z = S.zero },
    { x = S.zero ; y = S.zero ; z = S.one }
end

module FloatScalar : SCALAR =
struct

  type s = float 
  let add = ( +. )
  let sub = ( -. )
  let mul = ( *. )
  let div = ( /. )
  let neg a = -.a

  let zero = 0.0
  let one = 1.0

end

module IntScalar : SCALAR =
struct

  type s = int 
  let add = ( + )
  let sub = ( - )
  let mul = ( * )
  let div = ( / )
  let neg b = -b

  let zero = 0
  let one = 1

end

module FloatVector2 = Vector2(FloatScalar)
module IntVector2 = Vector2(IntScalar)
module FloatVector3 = Vector2(FloatScalar)
module IntVector3 = Vector2(IntScalar)
