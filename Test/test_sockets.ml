open OcsfmlNetwork

let run_udp_server port = print_string "Not yet implemented"
let run_udp_client port = print_string "Not yet implemented"


let run_tcp_server port =
  
  let listener = new tcp_listener  in
  if not ((listener#listen port) = Done)
  then failwith "Could not listen to specified port";
  Printf.printf "Server is listening to port %d, waiting for connections...\n" port ;
  let socket = new tcp_socket in
  if not ((listener#accept socket) = Done)
  then failwith "Could not connect";
  Printf.printf "Client connected: %s\n" ((socket#get_remote_address ())#to_string ());
  
  let packet = new packet in
  
  let out = "Hi, I'm the server" in
  ignore( packet << (`String out) );
  if not ((socket#send_packet packet) = Done)
  then failwith "Could not send packet";
  Printf.printf "Message sent to the client: \"%s\"\n" out;

  packet#clear () ;

  let in_s = ref "" in
  if not ((socket#receive_packet packet) = Done)
  then failwith "Coud not receive packet";
  ignore( packet >> (`String in_s) );
  Printf.printf "Answer received from the client: \"%s\"\n" !in_s;

  packet#destroy () ;
  socket#destroy () ;
  listener#destroy ()


let run_tcp_client port =
  print_string "Type the address or name of the server to connect to: ";
  let server = new ip_address (IPAddress.from_string (read_line ())) in
  
  let socket = new tcp_socket in
  if (socket#connect server port) <> Done
  then failwith "Could not connect to the server";
  Printf.printf "Connected to server %s\n" (server#to_string());

  let packet = new packet in

  let in_s = ref "" in
  if not ((socket#receive_packet packet) = Done)
  then failwith "Coud not receive packet";
  ignore( packet >> (`String in_s) );
  Printf.printf "Message received from the server: \"%s\"\n" !in_s;

  packet # clear () ;

  let out = "Hi, I'm the client" in
  ignore( packet << (`String out) );
  if not ((socket#send_packet packet) = Done)
  then failwith "Could not send packet";
  Printf.printf "Message sent to the server: \"%s\"\n" out;

  packet#destroy () ;
  socket#destroy ()
    
let _ =
  let port = 25001 in
  print_string "Do you want to use TCP (t) or UDP (u) ? " ;
  flush stdout ;
  let protocol = input_char stdin in
  ignore( read_line () ) ;
  print_string "Do you want to be a server (s) or a client (c) ? " ;
  flush stdout ;
  let who = input_char stdin in
  ignore( read_line () );
  match (protocol,who) with
    | ('t','s') -> run_tcp_server port
    | ('t', _ ) -> run_tcp_client port
    | ( _ ,'s') -> run_udp_server port
    | ( _ , _ ) -> run_udp_client port ;
