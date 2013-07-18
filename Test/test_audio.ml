open OcsfmlSystem
open OcsfmlAudio

open Printf

let ( & ) f x = f x

let play_sound () =
  let buffer = new sound_buffer `None in
  let sound = new sound () in
    if buffer#load_from_file "resources/canary.wav" 
    then
      begin
	printf 
	  "canary.wav : \n %f seconds\n %i samples / sec \n %i channels\n"
	  (Time.as_seconds buffer#get_duration) 
	  buffer#get_sample_rate
	  buffer#get_channel_count ;
	flush stdout;
	sound#set_buffer buffer;
	sound#play ;
	while sound#get_status = Playing do
	  sleep & Time.milliseconds 100 ;
	  printf "\rPlaying... %f sec" & Time.as_seconds sound#get_playing_offset ;
	  flush stdout ;
	done ;
	printf "\n\n" 
      end
    else
      printf "Unable to load ./resources/orchestral.ogg...\n"

let play_music () =
  let music = new music () in
    if music#open_from_file "resources/orchestral.ogg" 
    then
      begin
	printf "orchestral.ogg :\n %f seconds\n %i samples / sec \n %i channels\n"
	  (Time.as_seconds music#get_duration)
	  music#get_sample_rate
	  music#get_channel_count ;
	flush stdout;
	music#play ;
	
	while music#get_status = Playing do
	  sleep & Time.milliseconds 100 ;
	  printf "\rPlaying... %f sec" & Time.as_seconds music#get_playing_offset ;
	  flush stdout;
	done ;
	printf "\n"
      end
    else 
      Printf.printf "Unable to load ./resources/orchestral.ogg...\n"

let _ =
    play_sound () ;
    play_music () ;
    printf "Press enter to exit...\n" ;
    read_line ()
