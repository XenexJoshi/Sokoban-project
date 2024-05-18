open Raylib
open Cs3110_final_project.Constants
open Cs3110_final_project.Character
open Cs3110_final_project.Map
open Cs3110_final_project.Score
open Cs3110_final_project.Page
open Cs3110_final_project.Level
open Cs3110_final_project.Level_select

let level = ref 0
let selected_level = ref 0
let initial_control = ref 0
let level_data = ref Level.empty
let t = ref Map.empty
let game_state = ref Constants.TITLE_SCREEN
let counter = ref 0
let frame_counter = ref 0
let score_keeper = ref Score.empty
let game_type = ref Constants.LINEAR
let end_game_pointer = ref 0
let lwait = ref 0

let main () =
  let () =
    Raylib.init_window Constants.screen_width Constants.screen_height "Sokoban"
  in
  let () = set_target_fps Constants.game_fps in
  let rec loop () =
    if window_should_close () then close_window ()
    else
      match !game_state with
      | TITLE_SCREEN ->
          if !counter = Constants.title_prevail then game_state := INITIAL_STATE
          else Page.draw_title_screen ();
          counter := !counter + 1;
          loop ()
      | INITIAL_STATE ->
          Page.draw_initial_state !initial_control;
          if is_key_pressed Down then
            initial_control := (!initial_control + 1) mod 2;
          if is_key_down Up then
            if !initial_control = 0 then initial_control := 1
            else initial_control := 0;
          if is_key_pressed Enter then
            if !initial_control = 0 then
              let () = game_type := Constants.LINEAR in
              let () = game_state := MANUAL in
              loop ()
            else
              let () = game_state := LEVEL_SELECT in
              let () = game_type := Constants.SINGLE in
              loop ()
          else loop ()
      | LEVEL_SELECT ->
          Level_select.draw_level_select !selected_level;
          (if is_key_pressed Key.Up && !selected_level > 0 then
             selected_level := !selected_level - 1
           else if
             is_key_pressed Key.Down
             && !selected_level < Level_select.count_files
           then selected_level := !selected_level + 1
           else if is_key_pressed Key.Enter then
             if !selected_level = Level_select.count_files then
               let () = game_state := INITIAL_STATE in
               let () = level := 0 in
               let () = level_data := Level.empty in
               let () = game_type := Constants.LINEAR in
               loop ()
             else
               let level_info = Level.load_level (!selected_level + 1) in
               let () = level := !selected_level + 1 in
               let () = game_state := GAME_STATE in
               let () = score_keeper := Score.initialize_scorecard () in
               let () = frame_counter := 0 in
               let () = level_data := Level.load_level !level in
               let () =
                 t :=
                   Map.create_from_list
                     (Map.read_csv_file (Level.get_filepath level_info))
               in
               let x, y =
                 Option.value (Map.find_player_index !t) ~default:(0, 0)
               in
               let () =
                 Character.x := y;
                 Character.y := x
               in
               loop ());
          loop ()
      | MANUAL ->
          Page.draw_manual ();
          if is_key_pressed Enter then
            let () = game_state := GAME_STATE in
            let () = level := 1 in
            let () = level_data := Level.load_level !level in
            let () =
              t :=
                Map.create_from_list
                  (Map.read_csv_file (Level.get_filepath !level_data))
            in
            let x, y =
              Option.value (Map.find_player_index !t) ~default:(0, 0)
            in
            let () =
              Character.x := y;
              Character.y := x
            in
            loop ()
          else loop ()
      | GAME_STATE ->
          frame_counter := !frame_counter + 1;
          Score.set_time !score_keeper !frame_counter;
          Page.draw_game_state !t !score_keeper !level_data;
          if is_key_pressed Left || is_key_pressed A then
            Character.update_pos !t "A" !score_keeper
          else if is_key_pressed Right || is_key_pressed D then
            Character.update_pos !t "D" !score_keeper
          else if is_key_pressed Up || is_key_pressed W then
            Character.update_pos !t "W" !score_keeper
          else if is_key_pressed Down || is_key_pressed S then
            Character.update_pos !t "S" !score_keeper;
          if is_key_down Q then
            let () = level := 0 in
            if !game_type = Constants.LINEAR then
              let () = Score.add_gametime !score_keeper in
              let () = game_state := GAME_END in
              loop ()
            else
              let () = score_keeper := Score.initialize_scorecard () in
              let () = game_state := LEVEL_SELECT in
              let () = level := 0 in
              let () = level_data := Level.empty in
              let () = game_type := Constants.SINGLE in
              loop ()
          else if is_key_down R then
            let () = Score.add_gametime !score_keeper in
            let () = frame_counter := 0 in
            let () = Score.reset_scoreboard !score_keeper in
            let () =
              t :=
                Map.create_from_list
                  (Map.read_csv_file (Level.get_filepath !level_data))
            in
            let x, y =
              Option.value (Map.find_player_index !t) ~default:(0, 0)
            in
            let () =
              Character.x := y;
              Character.y := x
            in
            loop ()
          else if Map.check_endgame !t then
            if !game_type = Constants.SINGLE then
              let () = score_keeper := Score.empty in
              let () = level := 0 in
              let () = t := Map.empty in
              let () = level_data := Level.empty in
              let () = game_state := LEVEL_SELECT in
              loop ()
            else if
              !game_type = Constants.LINEAR && !level = Level_select.count_files
            then
              let () = game_state := GAME_WON in
              loop ()
            else
              let () = game_state := LEVEL_LOAD in
              let () = level := !level + 1 in
              let () = level_data := Level.load_level !level in
              let () = frame_counter := 0 in
              let () = Score.end_level_scores !score_keeper !level_data in
              let () = Score.reset_scoreboard !score_keeper in
              loop ()
          else loop ()
      | LEVEL_LOAD ->
          Page.draw_load_level !level !score_keeper !level_data;
          if !lwait = Constants.lwait then
            let () =
              t :=
                Map.create_from_list
                  (Map.read_csv_file (Level.get_filepath !level_data))
            in
            let x, y =
              Option.value (Map.find_player_index !t) ~default:(0, 0)
            in
            let () =
              Character.x := y;
              Character.y := x
            in
            let () = game_state := GAME_STATE in
            let () = lwait := 0 in
            loop ()
          else
            let () = lwait := !lwait + 1 in
            loop ()
      | GAME_END ->
          Page.draw_end_screen !end_game_pointer !score_keeper;
          if is_key_pressed Left || is_key_pressed Right then
            if !end_game_pointer = 0 then end_game_pointer := 1
            else end_game_pointer := 0;
          if is_key_pressed Enter then
            if !end_game_pointer = 0 then (
              game_state := TITLE_SCREEN;
              frame_counter := 0;
              score_keeper := Score.initialize_scorecard ();
              counter := 0;
              t := Map.empty;
              let x, y =
                Option.value (Map.find_player_index !t) ~default:(0, 0)
              in
              Character.x := y;
              Character.y := x;
              level := 0;
              loop ())
            else close_window ()
          else loop ()
      | GAME_WON ->
          Page.draw_game_won !end_game_pointer !score_keeper;
          if is_key_pressed Left || is_key_pressed Right then
            if !end_game_pointer = 0 then end_game_pointer := 1
            else end_game_pointer := 0;
          if is_key_pressed Enter then
            if !end_game_pointer = 0 then (
              game_state := TITLE_SCREEN;
              frame_counter := 0;
              counter := 0;
              score_keeper := Score.initialize_scorecard ();
              level := 0;
              t := Map.empty;
              let x, y =
                Option.value (Map.find_player_index !t) ~default:(0, 0)
              in
              Character.x := y;
              Character.y := x;
              level := 0;
              loop ())
            else close_window ()
          else loop ()
  in

  loop ()

let () = main ()
