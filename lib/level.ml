module Level = struct
  type level = {
    mutable filename : string;
    mutable levelname : string;
    mutable opt_steps : int;
    mutable opt_time : int;
  }

  let empty = { filename = ""; levelname = ""; opt_steps = 0; opt_time = 0 }

  let initialize_level fl ln st tm =
    { filename = fl; levelname = ln; opt_steps = st; opt_time = tm }

  let set_level row =
    initialize_level (List.nth row 0) (List.nth row 1)
      (int_of_string (List.nth row 2))
      (int_of_string (List.nth row 3))

  let load_level x =
    let loaded = BatList.of_enum (BatFile.lines_of "data/leveldata.txt") in
    let x = x - 1 in
    if x >= 0 && x < List.length loaded then
      let x = String.split_on_char ',' (List.nth loaded x) in
      set_level x
    else failwith ("Invalid level index: " ^ string_of_int x)

  let get_name lvl = lvl.levelname
  let get_filepath lvl = "data/" ^ lvl.filename
  let get_optsteps lvl = lvl.opt_steps
  let get_opttime lvl = lvl.opt_time
end
