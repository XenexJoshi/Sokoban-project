open Map
open Score

module Box = struct
  open Map

  let generate_box t x y = Map.set_cell t x y (Box (Floor, false, 0))

  let contains_box t x y =
    match Map.get_cell t x y with
    | Box _ -> true
    | _ -> false

  let check_box_on t x y =
    match Map.get_cell t x y with
    | Box (x, _, _) -> x
    | _ -> Floor

  let check_valid_move t x y =
    if x < 0 || x >= Map.get_width t then false
    else if y < 0 || y >= Map.get_height t then false
    else
      match Map.get_cell t x y with
      | Wall -> false
      | Box _ -> false
      | _ -> true

  let update_box_pos t old upd score =
    let old_grid =
      match Map.get_cell t (fst old) (snd old) with
      | Box (x, _, y) -> (x, y)
      | _ -> (Floor, 0)
    in
    let () =
      Map.set_cell t (fst upd) (snd upd)
        (Box (Map.get_cell t (fst upd) (snd upd), false, snd old_grid))
    in
    if check_box_on t (fst upd) (snd upd) = Goal then (
      let () = Map.set_cell t (fst upd) (snd upd) (Box (Goal, true, 1)) in
      if snd old_grid = 0 then Score.incr_current score)
    else ();
    Map.set_cell t (fst old) (snd old) (fst old_grid)

  let update_pos t x y motion score =
    match motion with
    | "W" ->
        if check_valid_move t x (y - 1) then
          let () = update_box_pos t (x, y) (x, y - 1) score in
          true
        else false
    | "A" ->
        if check_valid_move t (x - 1) y then
          let () = update_box_pos t (x, y) (x - 1, y) score in
          true
        else false
    | "S" ->
        if check_valid_move t x (y + 1) then
          let () = update_box_pos t (x, y) (x, y + 1) score in
          true
        else false
    | "D" ->
        if check_valid_move t (x + 1) y then
          let () = update_box_pos t (x, y) (x + 1, y) score in
          true
        else false
    | _ -> false
end
