module Constants : sig
  (** [type gamescreen] represents the different states of the game, each
      corresponding to a separate GUI mechanics, and user input operations.*)
  type gamescreen =
    | TITLE_SCREEN
    | INITIAL_STATE
    | LEVEL_SELECT
    | MANUAL
    | LEVEL_LOAD
    | GAME_STATE
    | GAME_END
    | GAME_WON

  type widget_data = {
    x : float;
    y : float;
    width : float;
    height : float;
  }
  (** [type widget_data] represents the specifications for a particular form of
      widget used in the game pages. Each widget is characterized by its
      x-coordinate [x], y-coordinate [y], width [width], and height [height].*)

  (** [type gameplay] represents the different methods of game progression.
      [LINEAR] progression implies progression through set-level system, and
      [SINGLE] implies playing a user-chosen level.*)
  type gameplay =
    | LINEAR
    | SINGLE

  val screen_width : int
  (** [screen_width] is the width of the entire game window.*)

  val screen_height : int
  (** [screen_height] is the height of the entire game window.*)

  val game_length : int
  (** [game_length] is the height and width of the play area within the game
      window, where the game grid is generated.*)

  val game_fps : int
  (** [game_fps] is the number of frames generated per second, which corresponds
      to the refresh/redrawing rate of the game window.*)

  val title_prevail : int
  (** [title_prevail] is the duration(in frames) that the title screen persists
      on the screen during game initialization.*)

  val block_curvature : float
  (** [block_curvature] is the eccentricity of the rounded-rectangle used in the
      game logo and block tiles.*)

  val block_index : int
  (** [block_index] is the characteristic index of the game tile in the game
      map.*)

  val title_size : int
  (** [title_size] is the font size of the primary text in the game menu.*)

  val header_size : int
  (** [header_size] is the font size of the secondary text in the game page.*)

  val sub_header_size : int
  (** [sub_header_size] is the font size of the tertiary text in the game page.*)

  val lwait : int
  (** [lwait] is the duration(in frames) that the level load screen persists on
      the screen.*)

  val logo_outer : widget_data
  (** [logo_outer] is the specification for the outer rectangle of the primary
      game logo.*)

  val logo_inner : widget_data
  (** [logo_inner] is the specification for the inner rectangle of the primary
      game logo.*)

  val manual_outer_1 : widget_data
  (** [manual_outer_1] is the specification of the outer region of topmost
      widget in the game manual page of the game progression.*)

  val manual_inner_1 : widget_data
  (** [manual_inner_1] is the specification of the inner region of topmost
      widget in the game manual page of the game progression.*)

  val manual_outer_2 : widget_data
  (** [manual_outer_2] is the specification of the outer region of lowermost
      widget in the game manual page of the game progression.*)

  val manual_inner_2 : widget_data
  (** [manual_inner_2] is the specification of the inner region of lowermost
      widget in the game manual page of the game progression.*)
end
