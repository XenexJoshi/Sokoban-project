open Map
open Score

module Box : sig
  val generate_box : Map.t -> int -> int -> unit
  (** [generate_box m x y] updates the game map [m] by adding a simple Box at
      coordinate (x, y). A simple box has type Box(Floor, false, 0).*)

  val contains_box : Map.t -> int -> int -> bool
  (** [contains_box m x y] states whether there exists a box at the coordinate
      (x, y) on the map [m]. The function returns true iff there is a box at the
      defined coordinate, regardless of the particular type of box.*)

  val update_pos : Map.t -> int -> int -> string -> Score.score -> bool
  (** [update_pos m x y move] updates the game map [m] by shifting the box at
      coordinate (x, y) to a new position defined by the move type [move].
      [move] includes the strings "W", "A", "S" and "D" that represent the
      allowed movement input within the game interface.*)
end
