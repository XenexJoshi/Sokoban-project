module Map = struct
  type cell =
    | Wall
    | Box of cell * bool * int
    | Goal
    | Player
    | Floor

  type t = {
    width : int;
    height : int;
    cells : cell array array;
  }

  let find_player_index map =
    let board = map.cells in
    let rows = Array.length board in
    let cols = Array.length board.(0) in
    let rec search_row i j =
      if i >= rows then None
      else if j >= cols then search_row (i + 1) 0
      else if board.(i).(j) = Player then Some (i, j)
      else search_row i (j + 1)
    in
    search_row 0 0

  let read_csv_file filename =
    let open Csv in
    let csv = load filename in
    let cell_of_char = function
      | 'W' -> Wall
      | 'B' -> Box (Floor, false, 0)
      | 'G' -> Goal
      | 'P' -> Player
      | 'F' -> Floor
      | _ -> Floor (* Default to Floor for unknown cells *)
    in
    List.map (fun row -> List.map (fun value -> cell_of_char value.[0]) row) csv

  let create width height =
    { width; height; cells = Array.make_matrix height width Floor }

  let create_from_list list_of_lists =
    let height = List.length list_of_lists in
    let width = List.length (List.hd list_of_lists) in
    let cells = Array.make_matrix height width Floor in
    List.iteri
      (fun y row -> List.iteri (fun x cell -> cells.(y).(x) <- cell) row)
      list_of_lists;
    { width; height; cells }

  let get_width t = t.width
  let get_height t = t.height

  let set_cell t x y cell =
    if x >= 0 && x < t.width && y >= 0 && y < t.height then
      t.cells.(y).(x) <- cell

  let get_cell t x y =
    if x >= 0 && x < t.width && y >= 0 && y < t.height then t.cells.(y).(x)
    else Floor

  let empty_map width height =
    let t = create width height in
    for y = 0 to height - 1 do
      for x = 0 to width - 1 do
        set_cell t x y Floor
      done
    done;
    set_cell t 0 0 Player;
    t

  let empty = empty_map 1 1

  let rec check_cols t cols row i =
    if i = cols then true
    else
      let state =
        match get_cell t row i with
        | Box (_, a, _) -> a
        | _ -> true
      in
      if state then check_cols t cols row (i + 1) else false

  let rec check_rows t rows i =
    let cols = get_height t in
    if i = rows then true
    else
      let state = check_cols t cols i 0 in
      if state then check_rows t rows (i + 1) else false

  let check_endgame t =
    let rows = get_width t in
    check_rows t rows 0

  let print_map t =
    for y = 0 to t.height - 1 do
      for x = 0 to t.width - 1 do
        match t.cells.(y).(x) with
        | Wall -> print_char '#'
        | Box _ -> print_char 'B'
        | Goal -> print_char 'G'
        | Player -> print_char 'P'
        | Floor -> print_char '_'
      done;
      print_newline ()
    done
end
