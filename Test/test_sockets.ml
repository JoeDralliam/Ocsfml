open OcsfmlNetwork

let rec get_ip_address () =
  Printf.printf "Type the address or name of the server to connect to:\n" ;
  let ad = new ip_address (`String (read_line ())) in
  if IPAddress.(equal ad none)
  then get_ip_address ()
  else ad
  

let run_tcp_server port =
  
  let listener = new tcp_listener  in
    if listener#listen port <> Done
    then failwith "Could not listen to specified port";
    Printf.printf "Server is listening to port %d, waiting for connections...\n" (port :> int);

  let socket = new tcp_socket in
  if listener#accept socket <> Done
  then failwith "Could not connect";

  let sender = socket#get_remote_address  in
  Printf.printf "Client connected: %s\n" (sender#to_string );
      
      let packet = new packet in
  
      let out = "Hi, I'm the server" in
      ignore( packet << (`String out) );
      if not ((socket#send_packet packet) = Done)
      then failwith "Could not send packet";
      Printf.printf "Message sent to the client: \"%s\"\n" out;
	
      packet#clear  ;
	
      let in_s = ref "" in
      if not ((socket#receive_packet packet) = Done)
      then failwith "Coud not receive packet";
      ignore( packet >> (`String in_s) );
      Printf.printf "Answer received from the client: \"%s\"\n" !in_s
      

let run_tcp_client port =
  let server = get_ip_address () in
  
  let socket = new tcp_socket in
  if (socket#connect server port) <> Done
  then failwith "Could not connect to the server";
  Printf.printf "Connected to server %s\n" (server#to_string );

  let packet = new packet in
  
  let in_s = ref "" in
  if not ((socket#receive_packet packet) = Done)
  then failwith "Coud not receive packet";
  ignore( packet >> (`String in_s) );
  Printf.printf "Message received from the server: \"%s\"\n" !in_s;
      
  packet # clear  ;
  
  let out = "Hi, I'm the client" in
  ignore( packet << (`String out) );
  if socket#send_packet packet <> Done
  then failwith "Could not send packet";
  Printf.printf "Message sent to the server: \"%s\"\n" out
	  
let run_udp_server port = 
  let socket = new udp_socket in
  if socket#bind port <> Done
  then failwith "Could not setup the server on specified port" 
  else Printf.printf "Server is listening to port %d, waiting for a message \n" (port :> int) ;
    
  let packet = new packet in
  let sender = new ip_address `None in
  let status, sender_port =  socket#receive_packet packet sender in
    
  if status <> Done
  then failwith "Coud not receive packet";

  Printf.printf "Message received from client %s: \"%s\"\n" 
    (sender#to_string ) (packet#read_string ) ;
      
  packet#clear  ;

  let answer = "Hi, I'm the server" in
  packet#write_string answer ;
  
  if socket#send_packet packet sender sender_port <> Done
  then failwith "Unable to send the packet to the client"
  else Printf.printf "Message sent to the client: \"%s\"\n" answer	

let run_udp_client port = 
  let server = get_ip_address () in

  let socket = new udp_socket in
  let msg = "Hi, I'm a client" in
  let packet = new packet in
  packet#write_string msg ;
  if socket#send_packet packet server port <> Done
  then failwith "Unable to send the packetto the server" ;
  
  Printf.printf "Message sent to the server : \"%s\"\n" (packet#read_string ) ;  
  
  packet#clear  ;
    
  let sender = new ip_address `None in
  let status, sender_port = socket#receive_packet packet sender in
  
  if status <> Done
  then failwith "Could not receive the packet" 
  else Printf.printf "Message received from %s: \"%s\"\n" 
    (sender#to_string ) (packet#read_string ) 

let rec get_answer (q : ('a,'b,'c,'d,'e,'f) format6) a1 a2 = 
  Printf.printf q a1 a2 ; flush stdout ;
  let c = (read_line ()).[0] in
    if c <> a1 && c <> a2
    then get_answer q a1 a2
    else c

let _ =
  let port = Port.from_int 25004 in
  let protocol = get_answer "Do you want to use TCP (%c) or UDP (%c) ?\n" 't' 'u' in
  let who = get_answer "Do you want to be a server (%c) or a client (%c) ?\n" 's' 'c' in
  (match (protocol,who) with
    | ('t','s') -> run_tcp_server port
    | ('t', _ ) -> run_tcp_client port
    | ( _ ,'s') -> run_udp_server port
    | ( _ , _ ) -> run_udp_client port );
  Gc.full_major ()
