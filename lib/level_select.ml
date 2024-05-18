open Raylib
open Constants

module Level_select = struct
  let count_files =
    let files = Sys.readdir "./data" in
    let csv_files =
      Array.to_list files
      |> List.filter (fun file -> Filename.check_suffix file ".csv")
    in
    let csv_file_count = List.length csv_files in
    csv_file_count

  let draw_level_select selected_level =
    begin_drawing ();
    let () = clear_background Color.white in
    let () =
      draw_rectangle 0 0 Constants.screen_width Constants.screen_height
        Raylib.Color.beige
    in
    draw_text "LEVEL SELECT"
      (3 * Constants.screen_width / 10)
      (2 * Constants.screen_height / 10)
      Constants.header_size Color.red;
    for i = 0 to count_files - 1 do
      let color = if i = selected_level then Color.red else Color.black in
      draw_text
        ("Level " ^ string_of_int (i + 1))
        300
        (200 + (i * 50))
        Constants.sub_header_size color
    done;
    draw_text "Back" 300
      (200 + (count_files * 50))
      Constants.sub_header_size
      (if selected_level = count_files then Color.red else Color.black);
    end_drawing ()
end
