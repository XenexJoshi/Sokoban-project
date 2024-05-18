open Map
open Score
open Level

module Page : sig
  val draw_title_screen : unit -> unit
  (** [draw_title_screen ()] generates the user-viewed interface for the title
      screen of the game.*)

  val draw_initial_state : int -> unit
  (** [draw_initial_state x] generates the interactable user interface for the
      main menu after the game is initialized, where [x] represents the position
      of the pointer on the screen.*)

  val draw_manual : unit -> unit
  (** [draw_manual ()] generates the user-viewed interface for the manual page
      displaying the game instructions.*)

  val draw_game_state : Map.t -> Score.score -> Level.level -> unit
  (** [draw_game_state m sc lvl] generated the user-viewed interface showing the
      scores from [sc] for the level [lvl], while displaying the actively
      updated game map [m] for the corresponding level.*)

  val draw_load_level : int -> Score.score -> Level.level -> unit
  (** [draw_load_level x sc lvl] generates the load screen before generating the
      game map for the level [lvl] at index [x], while displaying the user score
      from [sc].*)

  val draw_end_screen : int -> Score.score -> unit
  (** [draw_end_screen x sc] generates the end screen displayed when the user
      quits the game, while displaying the score from [sc], and queries whether
      the user prefers to restart the game of quit, where the position of the
      pointer is represented by [x].*)

  val draw_game_won : int -> Score.score -> unit
  (** [draw_game_won x sc] generated the end screen displayed when the user has
      completed the progression of the game, and queries whether the user
      prefers to restart or quit the game, while displaying the score from [sc],
      where the position of the pointer is represented by [x].*)
end
