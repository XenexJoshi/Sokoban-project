module Map : sig
  (** [type cell] represents the type of the tiles present in a game map.*)
  type cell =
    | Wall
    | Box of cell * bool * int
    | Goal
    | Player
    | Floor

  type t
  (** [type t] represents the representative type of the game map.*)

  val empty : t
  (** [empty] is the simplest game map that contains exactly 1 row and 1 column,
      with player positioned at the tile.*)

  val read_csv_file : string -> cell list list
  (** [red_csv_file f] generates a simple level description for a game map based
      on the information from the csv file at location f.*)

  val find_player_index : t -> (int * int) option
  (** [find_player_index m] represents the position of the character on the game
      map m represented as (x, y), where x and y represents the x-coordinate and
      y-coordinate respectively.*)

  val create : int -> int -> t
  (** [create width height] creates a new map with the given width and height,
      initially filled with [Floor]. *)

  val create_from_list : cell list list -> t
  (** [create_from_list lst] generates a game map of type t from a simple list
      representation of the game informations.*)

  val get_width : t -> int
  (** [get_width m] represents the number of columns in the game map [m].*)

  val get_height : t -> int
  (** [get_height m] represents the number of rows in the game map [m].*)

  val set_cell : t -> int -> int -> cell -> unit
  (** [set_cell t x y cell] sets the cell at position (x, y) in the map [t] to
      [cell]. *)

  val get_cell : t -> int -> int -> cell
  (** [get_cell t x y] returns the cell at position (x, y) in the map [t].
      Returns [Floor] if (x, y) is out of bounds. *)

  val empty_map : int -> int -> t
  (** [empty_map width height] creates an empty map with the given dimensions,
      with all cells set to [Floor], and places the player at position (1, 1). *)

  val check_endgame : t -> bool
  (** [check_endgame m] represents whether a game map has been completed. A game
      map is defined to be complete when all the boxes present in the game map
      have been placed in a goal tile.*)

  val print_map : t -> unit
  (** [print_map t] prints the map [t] to the terminal, using specific
      characters for each cell type. *)
end
