open System
open Audio

let play_sound () =
  let buffer = new sound_buffer in
  let sound = new sound in
    buffer#load_from_file "Resources/canary.wav" ;
    Printf.printf 
      "canary.wav : \n %f seconds\n %i samples / sec \n %i channels\n"
      ((float_of_int (buffer#get_duration ()))/.1000.) 
      (buffer#get_sample_rate ())
      (buffer#get_channels_count ());
    flush stdout;
    sound#set_buffer buffer;
    sound#play () ;
    while sound#get_status () = Playing do
      sleep 100 ;
      Printf.printf "\nPlaying... %f sec" ((float_of_int (sound#get_playing_offset ()))/.1000.);
      flush stdout;
    done ;
    print_newline () ;
    print_newline ()

let play_music () =
  let music = new music in
    music#open_from_file "resources/orchestral.ogg" ;
    Printf.printf "orchestral.ogg :\n %f seconds\n %i samples / sec \n %i channels\n"
      ((float_of_int (music#get_duration ()))/.1000.) 
      (music#get_sample_rate ())
      (music#get_channels_count ());
    flush stdout;
    music#play () ;
  
    while music#get_status () = Playing do
      sleep 100 ;
      Printf.printf "\nPlaying... %f sec" ((float_of_int (music#get_playing_offset ()))/.1000.);
      flush stdout;
    done ;
    print_newline ()

let _ =
  begin
    play_sound () ;
    play_music () ;
    print_string "Press enter to exit...\n" ;
    read_line ()
  end
