open Constants
open Level

module Score = struct
  type score = {
    mutable time : float;
    mutable moves : int;
    mutable cumulative : int;
    mutable current : int;
    mutable gametime : float;
  }

  let initialize_scorecard () =
    { time = 0.; moves = 0; cumulative = 0; current = 0; gametime = 0. }

  let empty =
    { time = 0.; moves = 0; cumulative = 0; current = 0; gametime = 0. }

  let incr_moves sb = sb.moves <- sb.moves + 1
  let get_time sc = sc.time
  let get_moves sc = sc.moves
  let get_current sc = sc.current
  let get_total sc = sc.cumulative

  let reset_scoreboard sb =
    let () = sb.time <- 0. in
    let () = sb.moves <- 0 in
    sb.current <- 0

  let set_time sb frames =
    let time = float_of_int frames /. float_of_int Constants.game_fps in
    sb.time <- time

  let update_per_move sb = sb.moves <- sb.moves + 1
  let incr_current sb = sb.current <- sb.current + 200

  let end_level_scores sb lvl =
    let opt_step = Level.get_optsteps lvl in
    let opt_time = Level.get_opttime lvl in
    let () =
      sb.current <-
        int_of_float
          (((float_of_int opt_time /. sb.time)
           +. (float_of_int opt_step /. float_of_int sb.moves))
          *. (2.5 *. float_of_int sb.current))
    in
    sb.cumulative <- sb.cumulative + sb.current;
    sb.gametime <- sb.gametime +. sb.time;
    sb.current <- 0

  let get_gametime sb = int_of_float sb.gametime
  let add_gametime sb = sb.gametime <- sb.gametime +. sb.time

  let gametime_to_string sb =
    let x = get_gametime sb in
    let mins =
      let inter = string_of_int (x / 60) in
      if String.length inter = 1 then "0" ^ inter else inter
    in
    let sec =
      let inter = string_of_int (x mod 60) in
      if String.length inter = 1 then "0" ^ inter else inter
    in
    mins ^ ":" ^ sec

  let moves sb = string_of_int sb.moves

  let score_to_string sb =
    let x = string_of_int (sb.cumulative + sb.current) in
    if String.length x < 5 then String.make (5 - String.length x) '0' ^ x else x

  let time_to_string sb =
    let x = int_of_float (floor sb.time) in
    let mins =
      let inter = string_of_int (x / 60) in
      if String.length inter = 1 then "0" ^ inter else inter
    in
    let sec =
      let inter = string_of_int (x mod 60) in
      if String.length inter = 1 then "0" ^ inter else inter
    in
    mins ^ ":" ^ sec
end
