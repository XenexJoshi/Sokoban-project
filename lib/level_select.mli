module Level_select : sig
  val draw_level_select : int -> unit
  (** [draw_level_select selected_level] draws the level select screen with the
      specified [selected_level] index highlighted. *)

  val count_files : int
  (** [count_files] represents the total number of games loaded into the LINEAR
      game progression. It represents the number of levels indicated in
      data/leveldata.txt.*)
end
