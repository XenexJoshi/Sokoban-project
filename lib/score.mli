open Level

module Score : sig
  type score = {
    mutable time : float;
    mutable moves : int;
    mutable cumulative : int;
    mutable current : int;
    mutable gametime : float;
  }
  (** [type score] represents the scoreboard that keeps track of the play time,
      and total scores during the player's gameplay.*)

  val empty : score
  (** [empty] represents a type score that acts as a placeholder when type score
      is required.*)

  val initialize_scorecard : unit -> score
  (** [initialzie scorecard ()] generates a type score, where each field is
      initialized to the base minimum value.*)

  val incr_moves : score -> unit
  (** [incr_moves sc] updates the moves [sc] by incrementing the move field by 1
      when called.*)

  val reset_scoreboard : score -> unit
  (** [reset_scoreboard sc] resets the time, moves and current field of score
      [sc], while conserving the cumulative and gametime field.*)

  val set_time : score -> int -> unit
  (** [set_time sc x] updates the time field of the score [sc], by setting it
      equal to time correponding to [x] frames.*)

  val incr_current : score -> unit
  (** [incr_current sc] updates the score [sc] by incrementing the current field
      by 200 when called.*)

  val update_per_move : score -> unit
  (** [update_per_move sc] increments the move field of [sc] by 1 when a valid
      move has been made causing the character to shift in position on the
      gameboard.*)

  val score_to_string : score -> string
  (** [score_to_string sc] is the string representation of the instantaneous
      total score(cumulative + current) during the game progression.*)

  val time_to_string : score -> string
  (** [time_to_sting sc] is the string representation of the time elaspsed in
      the current level represented in MM:SS format.*)

  val end_level_scores : score -> Level.level -> unit
  (** [end_level_scores sc lvl] updated the cumulative game score for the level
      [lvl] to score [sc] by appending appropriate time and movement bonus based
      on the player's gameplay.*)

  val moves : score -> string
  (** [moves sc] is the string representation of the number of moves taken by
      the player in the current level.*)

  val get_time : score -> float
  (** [get_time sc] represents the time(in seconds) elapsed in the current game
      level.*)

  val get_moves : score -> int
  (** [get_moves sc] represents the moves taken by the character in the current
      game level.*)

  val get_current : score -> int
  (** [get_current sc] represents the score accumulated by the player in the
      current level.*)

  val get_total : score -> int
  (** [get_total sc] represents the total score accumulated by the player since
      the start of the gamepaly, including bonus points.*)

  val get_gametime : score -> int
  (** [get_gametime sc] represents the total time spent by the player in the
      playthrough since the start of the LINEAR game progression.*)

  val add_gametime : score -> unit
  (** [add_gametime sc] appends the current time to the cumulative gametime
      through the game progression.*)

  val gametime_to_string : score -> string
  (** [gametime_to_string] is the string representation of the total time
      elapsed during the gameplay represented as MM:SS.*)
end
