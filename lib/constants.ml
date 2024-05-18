module Constants = struct
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

  type gameplay =
    | LINEAR
    | SINGLE

  let screen_width = 800
  let screen_height = 600
  let game_length = 600
  let game_fps = 60
  let title_prevail = 120
  let block_curvature = 0.4
  let block_index = 1
  let title_size = 60
  let header_size = 30
  let sub_header_size = 20
  let lwait = 90
  let logo_outer = { x = 200.0; y = 120.0; width = 400.0; height = 200.0 }
  let logo_inner = { x = 230.0; y = 150.0; width = 340.0; height = 140.0 }
  let manual_outer_1 = { x = 250.0; y = 20.0; width = 250.0; height = 70.0 }
  let manual_inner_1 = { x = 260.0; y = 30.0; width = 230.0; height = 50.0 }
  let manual_outer_2 = { x = 180.0; y = 380.0; width = 450.0; height = 70.0 }
  let manual_inner_2 = { x = 190.0; y = 390.0; width = 430.0; height = 50.0 }
end
