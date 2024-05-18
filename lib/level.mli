module Level : sig
  type level = {
    mutable filename : string;
    mutable levelname : string;
    mutable opt_steps : int;
    mutable opt_time : int;
  }
  (** [type level] represents the description of a level in the game
      progression. Each level is characterized by the filename of the csv file
      that specifies the features of the level, a unique level name, and
      infomation about the optimal steps and optimal time for completing the
      particular level.*)

  val empty : level
  (** [empty] represents a placeholder level that functions as the simplest
      level that can be generated.*)

  val load_level : int -> level
  (** [load_level x] generates the type level for the level numbered [x] in the
      LINEAR game progression.*)

  val get_name : level -> string
  (** [get_name lvl] is the name of the level [lvl].*)

  val get_filepath : level -> string
  (** [get_filepath lvl] is the file location of CSV file specifying the level
      [lvl].*)

  val get_optsteps : level -> int
  (** [get_optsteps lvl] is the optimal number of steps to complete the level
      [lvl].*)

  val get_opttime : level -> int
  (** [get_opttime lvl] is the optimal time(in seconds) needed to complete the
      level [lvl].*)
end
