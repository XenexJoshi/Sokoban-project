open Map
open Score

module Character : sig
  val x : int ref
  (** [x] is the x-coordinate of the player on the map.*)

  val y : int ref
  (** [y] is the y-coordinate of the player on the map.*)

  val on : Map.cell ref
  (** [on] represents the type of the cell the player is currently on.*)

  val update_pos : Map.t -> string -> Score.score -> unit
  (** [update_pos] changes the position of the character on the map based on the
      user input [input].*)
end
