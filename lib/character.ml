open Map
open Box
open Score

module Character = struct
  open Map

  let x = ref 0
  let y = ref 0
  let on = ref Map.Floor

  let check_valid_move t x y motion score =
    if x < 0 || x >= Map.get_width t then false
    else if y < 0 || y >= Map.get_height t then false
    else
      match Map.get_cell t x y with
      | Wall -> false
      | Box _ -> Box.update_pos t x y motion score
      | _ -> true

  let update_grid t prev old_tile =
    let () = Map.set_cell t !x !y Map.Player in
    Map.set_cell t (fst prev) (snd prev) old_tile

  let update_coord t input score =
    match String.uppercase_ascii input with
    | "S" ->
        if check_valid_move t !x (!y + 1) "S" score then
          let () = y := !y + 1 in
          Score.incr_moves score
        else ()
    | "W" ->
        if check_valid_move t !x (!y - 1) "W" score then
          let () = y := !y - 1 in
          Score.incr_moves score
        else ()
    | "A" ->
        if check_valid_move t (!x - 1) !y "A" score then
          let () = x := !x - 1 in
          Score.incr_moves score
        else ()
    | "D" ->
        if check_valid_move t (!x + 1) !y "D" score then
          let () = x := !x + 1 in
          Score.incr_moves score
        else ()
    | _ -> print_endline "Enter a valid command from W, A, S, D"

  let update_pos t input score =
    let p = (!x, !y) in
    let () = update_coord t input score in
    if fst p = !x && snd p = !y then ()
    else
      let old_tile = !on in
      let () = on := Map.get_cell t !x !y in
      update_grid t p old_tile
end
