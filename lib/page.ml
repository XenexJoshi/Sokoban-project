open Raylib
open Constants
open Score
open Map
open Level

module Page = struct
  let draw_title_screen () =
    begin_drawing ();
    let () = clear_background Raylib.Color.white in
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.skyblue
    in
    let a =
      Raylib.Rectangle.create Constants.logo_outer.x Constants.logo_outer.y
        Constants.logo_outer.width Constants.logo_outer.height
    in
    let () =
      draw_rectangle_rounded a Constants.block_curvature Constants.block_index
        Raylib.Color.black
    in
    let b =
      Raylib.Rectangle.create Constants.logo_inner.x Constants.logo_inner.y
        Constants.logo_inner.width Constants.logo_inner.height
    in
    let () =
      draw_rectangle_rounded b Constants.block_curvature Constants.block_index
        Raylib.Color.raywhite
    in
    let () =
      draw_text "SOKOBAN"
        (int_of_float Constants.logo_inner.x + 30)
        (int_of_float Constants.logo_inner.y + 40)
        Constants.title_size Raylib.Color.red
    in
    let () =
      draw_text "LOADING GAME......"
        (int_of_float Constants.logo_inner.x + 50)
        (int_of_float
           (Constants.logo_outer.y +. Constants.logo_outer.height +. 40.))
        Constants.header_size Raylib.Color.black
    in
    let () =
      draw_text "Credits: "
        ((Constants.screen_width / 2) + 10)
        (Constants.screen_height - 150)
        Constants.sub_header_size Raylib.Color.red
    in
    let () =
      let credit_list = [ "Xenex Joshi - xj233" ] in
      for i = 0 to List.length credit_list - 1 do
        let text = List.nth credit_list i in
        draw_text text
          ((Constants.screen_width / 2) + 100)
          (Constants.screen_height - 150 + (i * 30))
          Constants.sub_header_size Raylib.Color.black
      done
    in
    end_drawing ()

  let draw_initial_state index =
    let color_play, color_select =
      match index with
      | 0 -> (Raylib.Color.red, Raylib.Color.black)
      | _ -> (Raylib.Color.black, Raylib.Color.red)
    in
    begin_drawing ();
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.beige
    in
    let a =
      Raylib.Rectangle.create Constants.logo_outer.x Constants.logo_outer.y
        Constants.logo_outer.width Constants.logo_outer.height
    in
    let () =
      draw_rectangle_rounded a Constants.block_curvature Constants.block_index
        Raylib.Color.black
    in
    let b =
      Raylib.Rectangle.create Constants.logo_inner.x Constants.logo_inner.y
        Constants.logo_inner.width Constants.logo_inner.height
    in
    let () =
      draw_rectangle_rounded b Constants.block_curvature Constants.block_index
        Raylib.Color.raywhite
    in
    let () =
      draw_text "SOKOBAN"
        (int_of_float Constants.logo_inner.x + 30)
        (int_of_float Constants.logo_inner.y + 40)
        Constants.title_size Raylib.Color.red
    in
    let () =
      draw_text "PLAY"
        (int_of_float Constants.logo_inner.x)
        (int_of_float
           (Constants.logo_outer.y +. Constants.logo_outer.height +. 40.))
        Constants.header_size color_play
    in
    let () =
      draw_text "LEVEL SELECT"
        (int_of_float Constants.logo_inner.x)
        (int_of_float
           (Constants.logo_outer.y +. Constants.logo_outer.height +. 90.))
        Constants.header_size color_select
    in
    end_drawing ()

  let draw_manual () =
    begin_drawing ();
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.beige
    in
    let a =
      Raylib.Rectangle.create Constants.manual_outer_1.x
        Constants.manual_outer_1.y Constants.manual_outer_1.width
        Constants.manual_outer_1.height
    in
    let () =
      draw_rectangle_rounded a Constants.block_curvature Constants.block_index
        Raylib.Color.gold
    in
    let b =
      Raylib.Rectangle.create Constants.manual_inner_1.x
        Constants.manual_inner_1.y Constants.manual_inner_1.width
        Constants.manual_inner_1.height
    in
    let () =
      draw_rectangle_rounded b Constants.block_curvature Constants.block_index
        Raylib.Color.raywhite
    in
    let () =
      draw_text "How To Play?"
        (int_of_float Constants.manual_inner_1.x + 15)
        (int_of_float Constants.manual_inner_1.y + 10)
        Constants.header_size Raylib.Color.red
    in
    let () =
      draw_text
        "Use the ARROW KEYS or WASD keys to move the player character on the" 10
        190 Constants.sub_header_size Raylib.Color.black
    in
    let () =
      draw_text "screen." 10 220 Constants.sub_header_size Raylib.Color.black
    in
    let () =
      draw_text
        "The objective of the game is to push the blocks to the goal state. " 10
        130 Constants.sub_header_size Raylib.Color.black
    in
    let () =
      draw_text
        "Press R to restart the current level, and Q to quit the game \
         progression."
        10 280 Constants.sub_header_size Raylib.Color.black
    in
    let x =
      Raylib.Rectangle.create Constants.manual_outer_2.x
        Constants.manual_outer_2.y Constants.manual_outer_2.width
        Constants.manual_outer_2.height
    in
    let y =
      Raylib.Rectangle.create Constants.manual_inner_2.x
        Constants.manual_inner_2.y Constants.manual_inner_2.width
        Constants.manual_inner_2.height
    in
    let () =
      draw_rectangle_rounded x Constants.block_curvature Constants.block_index
        Raylib.Color.black
    in
    let () =
      draw_rectangle_rounded y Constants.block_curvature Constants.block_index
        Raylib.Color.green
    in
    let () =
      draw_text "Press ENTER to proceed."
        (int_of_float Constants.manual_inner_2.x + 10)
        (int_of_float Constants.manual_inner_2.y + 10)
        Constants.header_size Raylib.Color.red
    in
    end_drawing ()

  let draw_game_state t score_keeper level_data =
    begin_drawing ();

    let () = clear_background Raylib.Color.beige in
    let () =
      draw_rectangle 0 0 Constants.game_length Constants.game_length
        Raylib.Color.lightgray
    in
    let x_block = Map.get_width t in
    let y_block = Map.get_height t in
    let x_size = float_of_int Constants.game_length /. float_of_int x_block in
    let y_size = float_of_int Constants.game_length /. float_of_int y_block in
    let rec create_rect t i j =
      if j = y_block then ()
      else
        let a =
          Raylib.Rectangle.create
            (float_of_int i *. x_size)
            (float_of_int j *. y_size)
            x_size y_size
        in
        let color =
          match Map.get_cell t i j with
          | Wall -> Raylib.Color.black
          | Box (_, false, _) -> Raylib.Color.brown
          | Box (_, true, _) -> Raylib.Color.orange
          | Goal -> Raylib.Color.green
          | Player -> Raylib.Color.red
          | Floor -> Raylib.Color.white
        in
        let () =
          draw_rectangle_rounded a Constants.block_curvature
            Constants.block_index color
        in
        let () =
          draw_rectangle_rounded_lines a Constants.block_curvature
            Constants.block_index 2.0 Raylib.Color.black
        in
        create_rect t i (j + 1)
    in
    let rec create_map t i =
      if i = x_block then ()
      else
        let () = create_rect t i 0 in
        create_map t (i + 1)
    in
    create_map t 0;
    let () =
      draw_text "TIME:"
        (Constants.game_length + 40)
        (70 * Constants.game_length / 100)
        40 Raylib.Color.black
    in
    let () =
      draw_text
        (Score.time_to_string score_keeper)
        (Constants.game_length + 50)
        ((70 * Constants.game_length / 100) + 40)
        40 Raylib.Color.black
    in
    let () =
      draw_text "SCORE:"
        (Constants.game_length + 35)
        (55 * Constants.game_length / 100)
        40 Raylib.Color.black
    in
    draw_text
      (Score.score_to_string score_keeper)
      (Constants.game_length + 40)
      ((55 * Constants.game_length / 100) + 40)
      40 Raylib.Color.black;
    let level_name = Level.get_name level_data in
    let lvl_lst = String.split_on_char ' ' level_name in
    List.iteri
      (fun i str ->
        draw_text str
          (Constants.game_length + 30)
          (150 + (i * 40))
          40 Raylib.Color.darkpurple)
      lvl_lst;
    end_drawing ()

  let draw_load_level level score_keeper level_data =
    begin_drawing ();
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.beige
    in
    let () =
      draw_text
        ("LEVEL " ^ string_of_int level)
        (2 * Constants.screen_width / 10)
        (1 * Constants.screen_height / 5)
        40 Raylib.Color.black
    in
    let () =
      draw_text
        (Level.get_name level_data)
        (3 * Constants.screen_width / 10)
        (2 * Constants.screen_height / 5)
        40 Raylib.Color.darkpurple
    in
    let () =
      draw_text
        ("SCORE: " ^ Score.score_to_string score_keeper)
        (2 * Constants.screen_width / 5)
        (3 * Constants.screen_height / 5)
        40 Raylib.Color.black
    in
    end_drawing ()

  let draw_end_screen pointer score =
    begin_drawing ();
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.beige
    in
    let () =
      draw_text "GAME OVER"
        (3 * Constants.screen_width / 10)
        (2 * Constants.screen_height / 10)
        50 Raylib.Color.red
    in
    let () =
      draw_text "Keep Trying !!!"
        (4 * Constants.screen_width / 10)
        (3 * Constants.screen_height / 10)
        30 Raylib.Color.black
    in
    let () =
      draw_text "TOTAL SCORE: "
        (3 * Constants.screen_width / 20)
        (4 * Constants.screen_height / 10)
        30 Raylib.Color.black
    in
    let () =
      draw_text
        (Score.score_to_string score)
        (5 * Constants.screen_width / 20)
        (5 * Constants.screen_height / 10)
        30 Raylib.Color.green
    in
    let () =
      draw_text "TIME ELAPSED: "
        (6 * Constants.screen_width / 10)
        (4 * Constants.screen_height / 10)
        30 Raylib.Color.black
    in
    let () =
      draw_text
        (Score.gametime_to_string score)
        (7 * Constants.screen_width / 10)
        (5 * Constants.screen_height / 10)
        30 Raylib.Color.green
    in
    let () =
      draw_text "Thank you for playing."
        (3 * Constants.screen_width / 10)
        (3 * Constants.screen_height / 5)
        Constants.header_size Raylib.Color.black
    in
    let () =
      draw_text "Restart?"
        (4 * Constants.screen_width / 10)
        (7 * Constants.screen_height / 10)
        40 Raylib.Color.black
    in
    let color1, color2 =
      match pointer with
      | 0 -> (Raylib.Color.red, Raylib.Color.black)
      | _ -> (Raylib.Color.black, Raylib.Color.red)
    in
    let () =
      draw_text "Yes!"
        (3 * Constants.screen_width / 10)
        (4 * Constants.screen_height / 5)
        Constants.header_size color1
    in
    draw_text "No."
      (7 * Constants.screen_width / 10)
      (4 * Constants.screen_height / 5)
      Constants.header_size color2;
    end_drawing ()

  let draw_game_won pointer score =
    begin_drawing ();
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.beige
    in
    let () =
      draw_text "YOU HAVE COMPLETED THE GAME."
        (1 * Constants.screen_width / 20)
        (1 * Constants.screen_height / 5)
        40 Raylib.Color.darkgreen
    in
    let () =
      draw_text "TOTAL SCORE: "
        (3 * Constants.screen_width / 20)
        (4 * Constants.screen_height / 10)
        30 Raylib.Color.black
    in
    let () =
      draw_text
        (Score.score_to_string score)
        (5 * Constants.screen_width / 20)
        (5 * Constants.screen_height / 10)
        30 Raylib.Color.green
    in
    let () =
      draw_text "TIME ELAPSED: "
        (6 * Constants.screen_width / 10)
        (4 * Constants.screen_height / 10)
        30 Raylib.Color.black
    in
    let () =
      draw_text
        (Score.gametime_to_string score)
        (7 * Constants.screen_width / 10)
        (5 * Constants.screen_height / 10)
        30 Raylib.Color.green
    in
    let () =
      draw_text "Thank you for playing."
        (3 * Constants.screen_width / 10)
        (3 * Constants.screen_height / 5)
        Constants.header_size Raylib.Color.black
    in
    let () =
      draw_text "Restart?"
        (4 * Constants.screen_width / 10)
        (7 * Constants.screen_height / 10)
        40 Raylib.Color.black
    in
    let color1, color2 =
      match pointer with
      | 0 -> (Raylib.Color.red, Raylib.Color.black)
      | _ -> (Raylib.Color.black, Raylib.Color.red)
    in
    let () =
      draw_text "Yes!"
        (3 * Constants.screen_width / 10)
        (4 * Constants.screen_height / 5)
        Constants.header_size color1
    in
    draw_text "No."
      (7 * Constants.screen_width / 10)
      (4 * Constants.screen_height / 5)
      Constants.header_size color2;
    end_drawing ()
end
