open OUnit2
open Cs3110_final_project.Map
open Cs3110_final_project.Box
open Cs3110_final_project.Character
open Cs3110_final_project.Score
open Cs3110_final_project.Level

let t () = Map.empty_map 2 2
let sc = Score.empty

let test_map_generation =
  "test suite for map generation"
  >::: [
         ( "checking empty map with player" >:: fun _ ->
           let m = Map.empty_map 1 1 in
           assert_equal Map.Player (Map.get_cell m 0 0) );
         ( "checking rectangular map" >:: fun _ ->
           let m = Map.empty_map 1 2 in
           assert_equal Map.Player (Map.get_cell m 0 0);
           assert_equal Map.Floor (Map.get_cell m 1 0) );
         ( "checking simple map with different blocks" >:: fun _ ->
           let m = Map.empty_map 2 2 in
           Map.set_cell m 1 1 Wall;
           Box.generate_box m 0 1;
           Map.set_cell m 1 0 Goal;
           assert_equal Map.Player (Map.get_cell m 0 0);
           assert_equal Map.Wall (Map.get_cell m 1 1);
           assert_equal Map.Goal (Map.get_cell m 1 0);
           assert_bool "" (Box.contains_box m 0 1) );
       ]

let test_character_movement_1 =
  "test suite to check character movement"
  >::: [
         ( "checking empty initialization" >:: fun _ ->
           let t = t () in
           assert_equal 0 (fst (Option.get (Map.find_player_index t)));
           assert_equal 0 (snd (Option.get (Map.find_player_index t))) );
         ( "left motion" >:: fun _ ->
           let t = t () in
           Character.update_pos t "D" sc;
           assert_equal 0 (fst (Option.get (Map.find_player_index t)));
           assert_equal 1 (snd (Option.get (Map.find_player_index t))) );
       ]

let test_character_movement_2 =
  "test suite to check character movement"
  >::: [
         ( "down motion" >:: fun _ ->
           let t = t () in
           Character.update_pos t "S" sc;
           assert_equal 1 (fst (Option.get (Map.find_player_index t)));
           assert_equal 0 (snd (Option.get (Map.find_player_index t))) );
         ( "right motion" >:: fun _ ->
           let t = t () in
           Character.update_pos t "A" sc;
           assert_equal 0 (fst (Option.get (Map.find_player_index t)));
           assert_equal 0 (snd (Option.get (Map.find_player_index t))) );
       ]

let test_character_movement_3 =
  "test suite to check character movement"
  >::: [
         ( "upward motion" >:: fun _ ->
           let t = t () in
           Character.update_pos t "W" sc;
           assert_equal 0 (fst (Option.get (Map.find_player_index t)));
           assert_equal 0 (snd (Option.get (Map.find_player_index t))) );
         ( "cyclical permutation" >:: fun _ ->
           let t = t () in
           Character.update_pos t "D" sc;
           Character.update_pos t "S" sc;
           Character.update_pos t "A" sc;
           Character.update_pos t "W" sc;
           assert_equal 0 (fst (Option.get (Map.find_player_index t)));
           assert_equal 0 (snd (Option.get (Map.find_player_index t))) );
       ]

let t_restr () = Map.empty_map 1 1

let test_bounded_motion =
  "test suite to check game bounds"
  >::: [
         ( "testing W bounds" >:: fun _ ->
           let t_restr = t_restr () in
           Character.update_pos t_restr "W" sc;
           assert_equal (0, 0) (Option.get (Map.find_player_index t_restr)) );
         ( "testing A bounds" >:: fun _ ->
           let t_restr = t_restr () in
           Character.update_pos t_restr "A" sc;
           assert_equal (0, 0) (Option.get (Map.find_player_index t_restr)) );
         ( "testing S bounds" >:: fun _ ->
           let t_restr = t_restr () in
           Character.update_pos t_restr "S" sc;
           assert_equal (0, 0) (Option.get (Map.find_player_index t_restr)) );
         ( "testing D bounds" >:: fun _ ->
           let t_restr = t_restr () in
           Character.update_pos t_restr "D" sc;
           assert_equal (0, 0) (Option.get (Map.find_player_index t_restr)) );
       ]

let t_wall () =
  let x = Map.empty_map 3 3 in
  let () =
    Map.set_cell x 2 0 Wall;
    Map.set_cell x 0 2 Wall;
    Map.set_cell x 2 2 Wall
  in
  x

let test_player_wall_interaction_1 =
  "test suite for player-wall interaction"
  >::: [
         ( "testing left wall" >:: fun _ ->
           let t_wall = t_wall () in
           Character.update_pos t_wall "D" sc;
           Character.update_pos t_wall "D" sc;
           assert_equal (0, 1) (Option.get (Map.find_player_index t_wall)) );
         ( "testing bottom wall" >:: fun _ ->
           let t_wall = t_wall () in
           Character.update_pos t_wall "S" sc;
           Character.update_pos t_wall "S" sc;
           assert_equal (1, 0) (Option.get (Map.find_player_index t_wall)) );
       ]

let test_player_wall_interaction_2 =
  "test suite for player-wall interaction"
  >::: [
         ( "testing right wall" >:: fun _ ->
           let t_wall = t_wall () in
           Character.update_pos t_wall "D" sc;
           Character.update_pos t_wall "S" sc;
           Character.update_pos t_wall "S" sc;
           Character.update_pos t_wall "A" sc;
           assert_equal (2, 1) (Option.get (Map.find_player_index t_wall)) );
         ( "testing top wall" >:: fun _ ->
           let t_wall = t_wall () in
           Character.update_pos t_wall "D" sc;
           Character.update_pos t_wall "S" sc;
           Character.update_pos t_wall "D" sc;
           Character.update_pos t_wall "W" sc;
           assert_equal (1, 2) (Option.get (Map.find_player_index t_wall)) );
       ]

let box_map () =
  let x = Map.empty_map 3 3 in
  let () =
    Box.generate_box x 1 0;
    Box.generate_box x 1 1
  in
  x

let test_box_push_1 =
  "test suite for box motion"
  >::: [
         ( "testing left push" >:: fun _ ->
           let bmap = box_map () in
           Character.update_pos bmap "D" sc;
           assert_equal (0, 1) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 2 0) );
         ( "testing down push" >:: fun _ ->
           let bmap = box_map () in
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "S" sc;
           assert_equal (1, 1) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 1 2) );
       ]

let test_box_push_2 =
  "test suite for box motion"
  >::: [
         ( "testing right push" >:: fun _ ->
           let bmap = box_map () in
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "W" sc;
           Character.update_pos bmap "A" sc;
           assert_equal (1, 1) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 0 1) );
         ( "testing up push" >:: fun _ ->
           let bmap = box_map () in
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "A" sc;
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "W" sc;
           assert_equal (1, 1) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 1 0) );
       ]

let bwall_map () =
  let x = Map.empty_map 4 4 in
  let () =
    Box.generate_box x 1 0;
    Box.generate_box x 1 2;
    Box.generate_box x 3 2
  in
  let () =
    Map.set_cell x 0 2 Wall;
    Map.set_cell x 2 0 Wall;
    Map.set_cell x 1 3 Wall;
    Map.set_cell x 3 1 Wall
  in
  x

let test_contains_box =
  "test suite for contains box"
  >::: [
         ( "testing within pre-set map" >:: fun _ ->
           let bwall = bwall_map () in
           assert_bool "" (Box.contains_box bwall 1 0);
           assert_bool "" (Box.contains_box bwall 1 2);
           assert_bool "" (Box.contains_box bwall 3 2) );
         ( "testing generate box" >:: fun _ ->
           let m = Map.empty_map 2 2 in
           Box.generate_box m 1 0;
           Box.generate_box m 0 1;
           assert_bool "" (Box.contains_box m 1 0);
           assert_bool "" (Box.contains_box m 0 1) );
       ]

let test_box_wall_interaction1 =
  "test suite for box-wall interactions"
  >::: [
         ( "testing right wall" >:: fun _ ->
           let bmap = bwall_map () in
           let () = Character.update_pos bmap "D" sc in
           assert_equal (0, 0) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 1 0) );
         ( "testing bottom wall" >:: fun _ ->
           let bmap = bwall_map () in
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "S" sc;
           assert_equal (1, 1) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 1 2) );
       ]

let test_box_wall_interaction2 =
  "test suite for box-wall interactions"
  >::: [
         ( "testing left wall" >:: fun _ ->
           let bmap = bwall_map () in
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "A" sc;
           assert_equal (2, 2) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 1 2) );
         ( "testing top wall" >:: fun _ ->
           let bmap = bwall_map () in
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "S" sc;
           Character.update_pos bmap "D" sc;
           Character.update_pos bmap "W" sc;
           assert_equal (3, 3) (Option.get (Map.find_player_index bmap));
           assert_bool "" (Box.contains_box bmap 3 2) );
       ]

let init_sc = Score.initialize_scorecard ()

let test_initialize_scorecard =
  "test suite for Score.initialize_scorecard"
  >::: [
         ("time" >:: fun _ -> assert_equal 0. (Score.get_time init_sc));
         ("moves" >:: fun _ -> assert_equal 0 (Score.get_moves init_sc));
         ("cumulative" >:: fun _ -> assert_equal 0 (Score.get_total init_sc));
         ("current" >:: fun _ -> assert_equal 0 (Score.get_current init_sc));
       ]

let test_score_empty =
  "test suite for Score.empty"
  >::: [
         ("time" >:: fun _ -> assert_equal 0. (Score.get_time init_sc));
         ("moves" >:: fun _ -> assert_equal 0 (Score.get_moves init_sc));
         ("cumulative" >:: fun _ -> assert_equal 0 (Score.get_total init_sc));
         ("current" >:: fun _ -> assert_equal 0 (Score.get_current init_sc));
       ]

let test_set =
  "test suite for the setters for a score's field"
  >::: [
         ( "set_time for non-rounding" >:: fun _ ->
           Score.set_time init_sc 60;
           assert_equal (60. /. 60.) (Score.get_time init_sc) );
         ( "set time with roundung" >:: fun _ ->
           Score.set_time init_sc 125;
           assert_equal (125. /. 60.) (Score.get_time init_sc) );
         ( "update_per_move" >:: fun _ ->
           assert_equal 0 (Score.get_moves init_sc);
           Score.update_per_move init_sc;
           assert_equal 1 (Score.get_moves init_sc);
           Score.update_per_move init_sc;
           assert_equal 2 (Score.get_moves init_sc) );
         ( "incr_current" >:: fun _ ->
           assert_equal 0 (Score.get_current init_sc);
           Score.incr_current init_sc;
           assert_equal 200 (Score.get_current init_sc) );
       ]

let sc_board : Score.score =
  { time = 100.; moves = 20; cumulative = 5000; current = 200; gametime = 0. }

let test_reset_scoreboard =
  "test suite for Score.reset_scoreboard"
  >::: [
         ( "checking reset" >:: fun _ ->
           assert_equal 100. (Score.get_time sc_board);
           assert_equal 20 (Score.get_moves sc_board);
           assert_equal 5000 (Score.get_total sc_board);
           assert_equal 200 (Score.get_current sc_board);
           Score.reset_scoreboard sc_board;
           assert_equal 0. (Score.get_time sc_board);
           assert_equal 0 (Score.get_moves sc_board);
           assert_equal 5000 (Score.get_total sc_board);
           assert_equal 0 (Score.get_current sc_board) );
       ]

let tst_a : Score.score =
  { time = 0.; moves = 0; cumulative = 0; current = 10000; gametime = 12. }

let tst_b : Score.score =
  { time = 100.; moves = 10; cumulative = 100; current = 0; gametime = 0. }

let tst_c : Score.score =
  { time = 1200.; moves = 200; cumulative = 500; current = 500; gametime = 2. }

let test_moves =
  "test suite for Score.moves"
  >::: [
         ("string of moves" >:: fun _ -> assert_equal 0 (Score.get_moves tst_a));
         ("string of moves" >:: fun _ -> assert_equal 10 (Score.get_moves tst_b));
         ( "string of moves" >:: fun _ ->
           assert_equal 200 (Score.get_moves tst_c) );
       ]

let test_score_to_string =
  "test suite for Score.score_to_string"
  >::: [
         ("x < 5" >:: fun _ -> assert_equal "00000" (Score.score_to_string sc));
         ( "x > 5" >:: fun _ ->
           assert_equal "10000" (Score.score_to_string tst_a) );
         ( "x > 5" >:: fun _ ->
           assert_equal "00100" (Score.score_to_string tst_b) );
         ( "x > 5" >:: fun _ ->
           assert_equal "01000" (Score.score_to_string tst_c) );
       ]

let test_time_to_string =
  "test suite for Score.time_to_string"
  >::: [
         ("0 sec" >:: fun _ -> assert_equal "00:00" (Score.time_to_string tst_a));
         ( "100 sec" >:: fun _ ->
           assert_equal "01:40" (Score.time_to_string tst_b) );
         ( "1200 sec" >:: fun _ ->
           assert_equal "20:00" (Score.time_to_string tst_c) );
       ]

let test_gametime_to_string =
  "test suite for Score.gametime_to_string"
  >::: [
         ( "testing gametime" >:: fun _ ->
           assert_equal 12 (Score.get_gametime tst_a);
           Score.add_gametime tst_a;
           assert_equal 12 (Score.get_gametime tst_a);
           assert_equal "00:12" (Score.gametime_to_string tst_a) );
         ( "testing gametime and add" >:: fun _ ->
           assert_equal 0 (Score.get_gametime tst_b);
           Score.add_gametime tst_b;
           assert_equal 100 (Score.get_gametime tst_b);
           assert_equal "01:40" (Score.gametime_to_string tst_b) );
         ( "testing gametime and add" >:: fun _ ->
           assert_equal 2 (Score.get_gametime tst_c);
           Score.add_gametime tst_c;
           assert_equal 1202 (Score.get_gametime tst_c);
           assert_equal "20:02" (Score.gametime_to_string tst_c) );
       ]

let test_incr_current =
  "test suite for incr_current"
  >::: [
         ( "testing incr_current" >:: fun _ ->
           assert_equal 10000 (Score.get_current tst_a);
           Score.incr_current tst_a;
           assert_equal 10200 (Score.get_current tst_a);
           Score.incr_current tst_a;
           assert_equal 10400 (Score.get_current tst_a) );
         ( "testing incr_current" >:: fun _ ->
           assert_equal 0 (Score.get_current tst_b);
           Score.incr_current tst_b;
           assert_equal 200 (Score.get_current tst_b) );
         ( "testing incr_current" >:: fun _ ->
           assert_equal 500 (Score.get_current tst_c);
           Score.incr_current tst_c;
           assert_equal 700 (Score.get_current tst_c) );
       ]

let test_set_time =
  "test suite for set time"
  >::: [
         ( "120 frames" >:: fun _ ->
           Score.set_time tst_a 120;
           assert_equal (120. /. 60.) (Score.get_time tst_a);
           assert_equal "00:02" (Score.time_to_string tst_a) );
         ( "200 frames" >:: fun _ ->
           Score.set_time tst_b 200;
           assert_equal (200. /. 60.) (Score.get_time tst_b) );
         ( "2134 frames" >:: fun _ ->
           Score.set_time tst_c 2134;
           assert_equal (2134. /. 60.) (Score.get_time tst_c) );
       ]

let lvl = Level.empty

let test_level_empty =
  "test suite for Level.empty"
  >::: [
         ("filename" >:: fun _ -> assert_equal "data/" (Level.get_filepath lvl));
         ("levelname" >:: fun _ -> assert_equal "" (Level.get_name lvl));
         ("opt_steps" >:: fun _ -> assert_equal 0 (Level.get_optsteps lvl));
         ("opt_time" >:: fun _ -> assert_equal 0 (Level.get_opttime lvl));
       ]

let test_sc_1 : Score.score =
  { time = 1200.; moves = 200; cumulative = 500; current = 1000; gametime = 0. }

let test_lv_1 : Level.level =
  { filename = ""; levelname = ""; opt_steps = 100; opt_time = 600 }

let test_sc_2 : Score.score =
  { time = 200.; moves = 60; cumulative = 10000; current = 1000; gametime = 0. }

let test_lv_2 : Level.level =
  { filename = ""; levelname = ""; opt_steps = 40; opt_time = 60 }

let test_end_level_scores =
  "test suite for end_level_score"
  >::: [
         ( "testing level state lv_1" >:: fun _ ->
           assert_equal "data/" (Level.get_filepath test_lv_1);
           assert_equal "" (Level.get_name test_lv_1);
           assert_equal 100 (Level.get_optsteps test_lv_1);
           assert_equal 600 (Level.get_opttime test_lv_1);
           assert_equal 1200. (Score.get_time test_sc_1);
           assert_equal 200 (Score.get_moves test_sc_1);
           assert_equal 500 (Score.get_total test_sc_1);
           assert_equal 1000 (Score.get_current test_sc_1);
           Score.end_level_scores test_sc_1 test_lv_1;
           assert_equal 0 (Score.get_current test_sc_1);
           assert_equal 3000 (Score.get_total test_sc_1) );
         ( "testing level state lv_2" >:: fun _ ->
           assert_equal "data/" (Level.get_filepath test_lv_2);
           assert_equal "" (Level.get_name test_lv_2);
           assert_equal 40 (Level.get_optsteps test_lv_2);
           assert_equal 60 (Level.get_opttime test_lv_2);
           assert_equal 200. (Score.get_time test_sc_2);
           assert_equal 60 (Score.get_moves test_sc_2);
           assert_equal 10000 (Score.get_total test_sc_2);
           assert_equal 1000 (Score.get_current test_sc_2);
           Score.end_level_scores test_sc_2 test_lv_2;
           assert_equal 0 (Score.get_current test_sc_2);
           assert_equal 12416 (Score.get_total test_sc_2) );
       ]

let _ = run_test_tt_main test_map_generation
let _ = run_test_tt_main test_character_movement_1
let _ = run_test_tt_main test_character_movement_2
let _ = run_test_tt_main test_character_movement_3
let _ = run_test_tt_main test_bounded_motion
let _ = run_test_tt_main test_player_wall_interaction_1
let _ = run_test_tt_main test_player_wall_interaction_2
let _ = run_test_tt_main test_contains_box
let _ = run_test_tt_main test_box_push_1
let _ = run_test_tt_main test_box_push_2
let _ = run_test_tt_main test_box_wall_interaction1
let _ = run_test_tt_main test_box_wall_interaction2
let _ = run_test_tt_main test_initialize_scorecard
let _ = run_test_tt_main test_score_empty
let _ = run_test_tt_main test_set
let _ = run_test_tt_main test_reset_scoreboard
let _ = run_test_tt_main test_moves
let _ = run_test_tt_main test_score_to_string
let _ = run_test_tt_main test_time_to_string
let _ = run_test_tt_main test_gametime_to_string
let _ = run_test_tt_main test_incr_current
let _ = run_test_tt_main test_set_time
let _ = run_test_tt_main test_level_empty
let _ = run_test_tt_main test_initialize_scorecard
let _ = run_test_tt_main test_end_level_scores
