(** Networking management *)


(**/**)
module IPAddressBase :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val copy : t -> t
  val affect : t -> t -> t
  val from_string : string -> t
  val from_bytes : int -> int -> int -> int -> t
  val from_int : int -> t
  val to_string : t -> string
  val to_integer : t -> int
end
(**/**)



(** Encapsulate an IPv4 network address.

    OcsfmlNetwork.ip_address is a utility class for manipulating network addresses.
    
    It provides a set a implicit constructors and conversion functions to easily build or transform an IP address from/to various representations.
    
    Usage example:
    {[
    let a0 = new ip_address `None in                      (* an invalid address *)
    let a1 = IPAddress.None in                           (* an invalid address (same as a0) *)
    let a2 = new ip_address (`String "127.0.0.1") in      (* the local host address *)
    let a4 = new ip_address (`Bytes (192, 168, 1, 56)) in (* a local address *)
    let a5 = new ip_address (`String "my_computer") in    (* a local address created from a network name *)
    let a6 = new ip_address (`String "89.54.1.169") in    (* a distant address *)
    let a7 = new ip_address (`String "www.google.com") in (* a distant address created from a network name *)
    let a8 = IPAddress.get_local_address () in           (* my address on the local network *)
    let a9 = IPAddress.get_public_address () in          (* my address on the internet *)
    ...
    ]}
*)
class ip_address :
  [ `Bytes of int * int * int * int
  | `Int of int
  | `None
  | `String of string 
  | `Copy of < rep__sf_IpAddress : IPAddressBase.t ; .. > ] ->
object ('self)
  (**/**)
  val t_ip_address : IPAddressBase.t
  (**/**)
    
  (**)
  method destroy : unit
    
  (**)
  method affect : 'self -> unit

  (**/**)
  method rep__sf_IpAddress : IPAddressBase.t
  (**/**)
    
    
  (** Get an integer representation of the address.
      
      The returned number is the internal representation of the address, and should be used for optimization purposes only (like sending the address through a socket). The integer produced by this function can then be converted back to a ip_address with the proper constructor.
      @param 32-bits unsigned integer representation of the address*)
  method to_integer : int
    
  (** Get a string representation of the address.

      The returned string is the decimal representation of the IP address (like "192.168.1.56"), even if it was constructed from a host name.
      @return String representation of the address*)
  method to_string : string
end

module IPAddress :
sig
  type t = IPAddressBase.t

  (** Get the computer's local address.
      
      The local address is the address of the computer from the LAN point of view, i.e. something like 192.168.1.56. It is meaningful only for communications over the local network. Unlike get_public_address, this function is fast and may be used safely anywhere.*)
  val get_local_address : unit -> ip_address

  (** Get the computer's public address.

      The public address is the address of the computer from the internet point of view, i.e. something like 89.54.1.169. It is necessary for communications over the world wide web. The only way to get a public address is to ask it to a distant website; as a consequence, this function depends on both your network connection and the server, and may be very slow. You should use it as few as possible. Because this function depends on the network connection and on a distant server, you may use a time limit if you don't want your program to be possibly stuck waiting in case there is a problem; this limit is deactivated by default.
      @param timeout Maximum time to wait *)
  val get_public_address :
    ?timeout:OcsfmlSystem.Time.t -> unit -> ip_address

  (** Value representing an empty/invalid address. *)
  val none : ip_address

  (** The "localhost" address (for connecting a computer to itself locally) *)
  val localhost : ip_address


  val equal : ip_address -> ip_address -> bool
end



module FTP :
sig
  (** Enumeration of transfer modes. *)
  type transfer_mode = 
      Binary (** Binary mode (file is transfered as a sequence of bytes) *)
    | Ascii (** Text mode using ASCII encoding. *)
    | Ebcdic (** Text mode using EBCDIC encoding. *)
	

  (** Status codes possibly returned by a FTP response. *)
  module Status :
  sig
    type t = private int
    val restartMarkerReply : t (** Restart marker reply. *)
    val serviceReadySoon : t (** Service ready in N minutes. *)
    val dataConnectionAlreadyOpened : t (** Data connection already opened, transfer starting. *)
    val openingDataConnection : t (** File status ok, about to open data connection. *)
    val ok : t (** Command ok. *)
    val pointlessCommand : t (** Command not implemented. *)
    val systemStatus : t (** System status, or system help reply. *)
    val directoryStatus : t (** Directory status. *)
    val fileStatus : t (** File status. *)
    val helpMessage : t (** Help message. *)
    val systemType : t (** NAME system type, where NAME is an official system name from the list in the Assigned Numbers document. *) 
    val serviceReady : t (** Service ready for new user. *)
    val closingConnection : t (** Service closing control connection. *)
    val dataConnectionOpened : t (** Data connection open, no transfer in progress. *)
    val closingDataConnection : t (** Closing data connection, requested file action successful. *)
    val enteringPassiveMode : t (** Entering passive mode. *)
    val loggedIn : t (** User logged in, proceed. Logged out if appropriate. *)
    val fileActionOk : t (** Requested file action ok. *)
    val directoryOk : t (** PATHNAME created. *)
    val needPassword : t (** User name ok, need password. *)
    val needAccountToLogIn : t (** Need account for login. *)
    val needInformation : t (** Requested file action pending further information. *)
    val serviceUnavailable : t (** Service not available, closing control connection. *)
    val dataConnectionUnavailable : t (** Can't open data connection. *)
    val transferAborted : t (** Connection closed, transfer aborted. *)
    val fileActionAborted : t (** Requested file action not taken. *)
    val localError : t (** Requested action aborted, local error in processing. *)
    val insufficientStorageSpace : t (** Requested action not taken; insufficient storage space in system, file unavailable. *)
    val commandUnknown : t (** Syntax error, command unrecognized. *)
    val parametersUnknown : t (** Syntax error in parameters or arguments. *)
    val commandNotImplemented : t (** Command not implemented. *)
    val badCommandSequence : t (** Bad sequence of commands. *)
    val parameterNotImplemented : t (** Command not implemented for that parameter. *)
    val notLoggedIn : t (** Not logged in. *)
    val needAccountToStore : t (** Need account for storing files. *)
    val fileUnavailable : t (** Requested action not taken, file unavailable. *)
    val pageTypeUnknown : t (** Requested action aborted, page type unknown. *)
    val notEnoughMemory : t (** Requested file action aborted, exceeded storage allocation. *)
    val filenameNotAllowed : t (** Requested action not taken, file name not allowed. *)
    val invalidResponse : t (** Response is not a valid FTP one. *)
    val connectionFailed : t (** Connection with server failed. *)
    val connectionClosed : t (** Connection with server closed. *)
    val invalidFile : t (** Invalid file to upload / download. *)
  end

  (**/**)
  module Response :
  sig
    type t
    val destroy : t -> unit
    val default : ?code:Status.t -> ?msg:string -> unit -> t
    val get_status : t -> Status.t
    val get_message : t -> string
  end
  (**/**)


  (** Define a FTP response. *)
  class response :
    Response.t ->
  object  
    (**/**)
    val t_response : Response.t
    (**/**)

    (**)
    method destroy : unit

    (** Get the full message contained in the response. *)
    method get_message : string

    (** Get the status code of the response. *)
    method get_status : Status.t

    (** Check if the status code means a success.

	This function is defined for convenience, it is equivalent to testing if the status code is < 400.*)
    method is_ok : bool

    (**/**)
    method rep__sf_Ftp_Response : Response.t
  (**/**)
  end

  (**/**)
  module DirectoryResponse :
  sig
    type t
    val destroy : t -> unit
    val to_response : t -> Response.t
    val default : Response.t -> t
    val get_directory : t -> string
  end
  (**/**)

  (** Specialization of FTP response returning a directory. *)
  class directory_response :
    DirectoryResponse.t ->
  object
    inherit response

    (**/**)
    val t_directory_response : DirectoryResponse.t
    (**/**)

    (**)
    method destroy : unit

    (** Get the directory returned in the response. *)    
    method get_directory : string
      
    (**/**)
    method rep__sf_Ftp_DirectoryResponse : DirectoryResponse.t
  (**/**)
  end

  (**/**)
  module ListingResponse :
  sig
    type t
    val destroy : t -> unit
    val to_response : t -> Response.t
    val default : response -> char list -> t
    val get_filenames : t -> string list
  end
  (**/**)

  (** Specialization of FTP response returning a filename lisiting. *)
  class listing_response :
    ListingResponse.t ->
  object
    inherit response
      
    (**/**)
    val t_listing_response : ListingResponse.t
    (**/**)

    (**)
    method destroy : unit

    (** Return the list of filenames. *)
    method get_filenames : string list

    (**/**)
    method rep__sf_Ftp_ListingResponse : ListingResponse.t
  (**/**)
  end


  (**/**)
  module Ftp :
  sig
    type t
    val destroy : t -> unit
    val default : unit -> t
    val connect : t -> ?port:int -> ?timeout:OcsfmlSystem.Time.t -> IPAddress.t -> Response.t
    val disconnect : t -> Response.t
    val login : t -> ?log:string * string -> unit -> Response.t
    val keep_alive : t -> Response.t
    val get_working_directory : t -> DirectoryResponse.t
    val get_directory_listing : t -> ?dir:string -> unit -> ListingResponse.t
    val change_directory : t -> string -> Response.t
    val parent_directory : t -> Response.t
    val create_directory : t -> string -> Response.t
    val delete_directory : t -> string -> Response.t
    val rename_file : t -> string -> string -> Response.t
    val delete_file : t -> string -> Response.t
    val download : t -> ?mode:transfer_mode -> string -> string -> Response.t
    val upload : t -> ?mode:transfer_mode -> string -> string -> Response.t
  end
  (**/**)

  (** 
      A FTP client.
      
      OcsfmlNetwork.ftp is a very simple FTP client that allows you to communicate with a FTP server.
      
      The FTP protocol allows you to manipulate a remote file system (list files, upload, download, create, remove, ...).

      Using the FTP client consists of 4 parts:
      
      - Connecting to the FTP server
      - Logging in (either as a registered user or anonymously)
      - Sending commands to the server
      - Disconnecting (this part can be done implicitely by the destructor)
      
      Every command returns a FTP response, which contains the status code as well as a message from the server. Some commands such as GetWorkingDirectory and GetDirectoryListing return additional data, and use a class derived from sf::Ftp::Response to provide this data.
      
      All commands, especially Upload and Download, may take some time to complete. This is important to know if you don't want to block your application while the server is completing the task.
      
      Usage example:
      {[
  (* Create a new FTP client *)
      let ftp = new FTP.ftp (FTP.Ftp.default ()) in
      
  (* Connect to the server *)
      let response = ftp#connect "ftp://ftp.myserver.com" in
      if response#is_ok
      then Pervasives.print_string "Connected\n" ;
      
  (* Log in *)
      let response = ftp#login ?log:("laurent","dF6Zm89D") () in
      if response#is_ok
      then Pervasives.print_string "Logged in\n";
      
  (* Print the working directory *)
      let directory = ftp#get_working_directory in
      if directory#is_ok
      then Pervasives.print_string ("Working directory: " ^ directory#get_directory ^ "\n") ;
      
  (* Create a new directory *)
      let response = ftp#create_directory "files" in
      if response#is_ok
      then Pervasives.print_string "Created new directory\n";
      
  (* Upload a file to this new directory *)
      let response = ftp#upload ?mode:FTP.Ascii "local-path/file.txt" "files" ;
      if response#is_ok
      then Pervasives.print_string "File uploaded\n" ;
      
  (* Disconnect from the server (optional) *)
      ftp#disconnect 
      ]}*)
  class ftp :
    Ftp.t ->
  object
    (**/**)
    val t_ftp : Ftp.t
    (**/**)

    (** Change the current working directory.

	The new directory must be relative to the current one.
	@return Server response to the request*)
    method change_directory : string -> response

    (** Connect to the specified FTP server.

	The port has a default value of 21, which is the standard port used by the FTP protocol. You shouldn't use a different value, unless you really know what you do. This function tries to connect to the server so it may take a while to complete, especially if the server is not reachable. To avoid blocking your application for too long, you can use a timeout. The default value, Time::Zero, means that the system timeout will be used (which is usually pretty long).
	@return Server response to the request*)
    method connect : ?port:int -> ?timeout:OcsfmlSystem.Time.t -> ip_address -> response

    (** Create a new directory.

	The new directory is created as a child of the current working directory.
	@return Server response to the request*)
    method create_directory : string -> response

    (** Remove an existing directory.

	The directory to remove must be relative to the current working directory. Use this function with caution, the directory will be removed permanently!
	@return Server response to the request*)
    method delete_directory : string -> response

    (** Remove an existing file.

	The file name must be relative to the current working directory. Use this function with caution, the file will be removed permanently!
	@return Server response to the request*)
    method delete_file : string -> response

    (**)
    method destroy : unit

    (** Close the connection with the server. 
	@return Server response to the request*)
    method disconnect : response

    (** Download a file from the server.

	The filename of the distant file is relative to the current working directory of the server, and the local destination path is relative to the current directory of your application.
	@return Server response to the request*)
    method download : ?mode:transfer_mode -> string -> string -> response

    (** Get the contents of the given directory.

	This function retrieves the sub-directories and files contained in the given directory. It is not recursive. The directory parameter is relative to the current working directory.
	@return Server response to the request*)
    method get_directory_listing : ?dir:string -> unit -> listing_response

    (** Get the current working directory.

	The working directory is the root path for subsequent operations involving directories and/or filenames.
	@return Server response to the request*)
    method get_working_directory : directory_response

    (** Send a null command to keep the connection alive.

	This command is useful because the server may close the connection automatically if no command is sent.
	@return Server response to the request*)
    method keep_alive : response

    (** Log in using an anonymous account.

	Logging in is mandatory after connecting to the server. Users that are not logged in cannot perform any operation.
	@return Server response to the request*)
    method login : ?log:string * string -> unit -> response

    (** Go to the parent directory of the current one. 
	@return Server response to the request*)
    method parent_directory : response

    (** Rename an existing file.

	The filenames must be relative to the current working directory.
	@return Server response to the request*)
    method rename_file : string -> string -> response

    (**/**)
    method rep__sf_Ftp : Ftp.t
    (**/**)

    (** Upload a file to the server.

	The name of the local file is relative to the current working directory of your application, and the remote path is relative to the current directory of the FTP server.
	@return Server response to the request*)
    method upload : ?mode:transfer_mode -> string -> string -> response
  end
end


module HTTP :
sig
  
  (** Enumerate the available HTTP methods for a request. *)
  type request_method = 
      Get (** Request in get mode, standard method to retrieve a page. *)
    | Post (** Request in post mode, usually to send data to a page. *)
    | Head (** Request a page's header only. *)
	
  (** Enumerate all the valid status codes for a response. *)
  module Status :
  sig
    type t = private int
    val ok : t (** Most common code returned when operation was successful. *)
    val created : t (** The resource has successfully been created. *)
    val accepted : t (** The request has been accepted, but will be processed later by the server. *)
    val noContent : t (** The server didn't send any data in return. *)
    val resetContent : t (** The server informs the client that it should clear the view (form) that caused the request to be sent. *)
    val partialContent : t (** The server has sent a part of the resource, as a response to a partial GET request. *)
    val multipleChoices : t (** The requested page can be accessed from several locations. *)
    val movedPermanently : t (** The requested page has permanently moved to a new location. *)
    val movedTemporarily : t (** The requested page has temporarily moved to a new location. *)
    val notModified : t (** For conditionnal requests, means the requested page hasn't changed and doesn't need to be refreshed. *)
    val badRequest : t (** The server couldn't understand the request (syntax error) *)
    val unauthorized : t (** The requested page needs an authentification to be accessed. *)
    val forbidden : t (** The requested page cannot be accessed at all, even with authentification. *)
    val notFound : t (** The requested page doesn't exist. *)
    val rangeNotSatisfiable : t (** The server can't satisfy the partial GET request (with a "Range" header field) *)
    val internalServerError : t (** The server encountered an unexpected error. *)
    val notImplemented : t (** The server doesn't implement a requested feature. *)
    val badGateway : t (** The gateway server has received an error from the source server. *)
    val serviceNotAvailable : t (** The server is temporarily unavailable (overloaded, in maintenance, ...) *)
    val gatewayTimeout : t (** The gateway server couldn't receive a response from the source server. *)
    val versionNotSupported : t (** The server doesn't support the requested HTTP version. *)
    val invalidResponse : t (** Response is not a valid HTTP one. *)
    val connectionFailed : t (** Connection with server failed. *)
  end
    
    
  (**/**)
  module Request :
  sig
    type t
    val destroy : t -> unit
    val default :
      ?uri:string -> ?meth:request_method -> ?body:string -> unit -> t
    val set_field : t -> string -> string -> unit
    val set_method : t -> request_method -> unit
    val set_uri : t -> string -> unit
    val set_http_version : t -> int -> int -> unit
    val set_body : t -> string -> unit
  end
  (**/**)  

  (** Define a HTTP request. *)
  class request : ?uri:string -> ?meth:request_method -> ?body:string -> unit ->
  object
    (**/**)
    val t_request : Request.t
    (**/**)
      
    (**)
    method destroy : unit

    (**/**)
    method rep__sf_Http_Request : Request.t
    (**/**)

    (** Set the body of the request.

	The body of a request is optional and only makes sense for POST requests. It is ignored for all other methods. The body is empty by default.*)
    method set_body : string -> unit
      
    (** Set the value of a field.

	The field is created if it doesn't exist. The name of the field is case insensitive. By default, a request doesn't contain any field (but the mandatory fields are added later by the HTTP client when sending the request).*)
    method set_field : string -> string -> unit
      
    (** Set the HTTP version for the request.

	The HTTP version is 1.0 by default.*)
    method set_http_version : int -> int -> unit
      
    (** Set the request method.

	See the request_method enumeration for a complete list of all the availale methods. The method is HTTP.Get by default.*)
    method set_method : request_method -> unit
      
    (** Set the requested URI.

	The URI is the resource (usually a web page or a file) that you want to get or post. The URI is "/" (the root page) by default.*)
    method set_uri : string -> unit
  end
    
    
  (**/**)
  module Response :
  sig
    type t
    val destroy : t -> unit
    val default : unit -> t
    val get_field : t -> string -> string
    val get_status : t -> Status.t
    val get_major_http_version : t -> int
    val get_minor_http_version : t -> int
    val get_body : t -> string
  end
  (**/**)
    
  (** Define a HTTP response. *)
  class response :
    Response.t ->
  object
    (**/**)
    val t_response : Response.t
    (**/**)
      
    (**)
    method destroy : unit
      
    (** Get the body of the response.

	The body of a response may contain:

    	- the requested page (for GET requests)
    	- a response from the server (for POST requests)
    	- nothing (for HEAD requests)
    	- an error message (in case of an error)
	@return The response body *)
    method get_body : string
      
    (** Get the value of a field.

	If the field field is not found in the response header, the empty string is returned. This function uses case-insensitive comparisons.
	@return Value of the field, or empty string if not found *)
    method get_field : string -> string
      
    (** Get the major HTTP version number of the response.
	@author Major HTTP version number*)
    method get_major_http_version : int
      
    (** Get the minor HTTP version number of the response. 
	@return Minor HTTP version number*)
    method get_minor_http_version : int
      
    (** Get the response status code.

	The status code should be the first thing to be checked after receiving a response, it defines whether it is a success, a failure or anything else (see the Status enumeration).
	@return Status code of the response *)
    method get_status : Status.t
      
    (**/**)
    method rep__sf_Http_Response : Response.t
  (**/**)
  end
    
  (**/**)
  module Http :
  sig
    type t
    val destroy : t -> unit
    val default : unit -> t
    val from_host : string -> t
    val from_host_and_port : string -> int -> t
    val set_host : t -> ?port:int -> string -> unit
    val send_request : t -> ?timeout:OcsfmlSystem.Time.t -> Request.t -> Response.t
  end
  (**/**)  
    
  (** A HTTP client.

      sf::Http is a very simple HTTP client that allows you to communicate with a web server.

      You can retrieve web pages, send data to an interactive resource, download a remote file, etc.

      The HTTP client is split into 3 classes:

      - sf::Http::Request
      - sf::Http::Response
      - sf::Http

      sf::Http::Request builds the request that will be sent to the server. A request is made of:

      - a method (what you want to do)
      - a target URI (usually the name of the web page or file)
      - one or more header fields (options that you can pass to the server)
      - an optional body (for POST requests)

      sf::Http::Response parse the response from the web server and provides getters to read them. The response contains:

      - a status code
      - header fields (that may be answers to the ones that you requested)
      - a body, which contains the contents of the requested resource

      sf::Http provides a simple function, send_request, to send a sf::Http::Request and return the corresponding sf::Http::Response from the server.

      Usage example:
      {[
  (* Create a new HTTP client *)
      let http = new HTTP.http (HTTP.Http.default ()) in

  (* We'll work on http://www.sfml-dev.org *)
      http#set_host "http://www.sfml-dev.org" ;

  (* Prepare a request to get the 'features.php' page *)
      let request = new HTTP.request (HTTP.Request.default ~uri:"features.php") in

  (* Send the request *)
      let response = http#send_request request in

  (* Check the status code and display the result *)
      let status = response#get_status in
      if status = HTTP.Status.Ok
      then Pervasives.print_string (response.getBody() ^ "\n")
      else Pervasives.print_string ("Error " ^ status ^ "\n") ; 
      ]}*)
  class http :
    Http.t ->
  object
    (**/**)
    val t_http : Http.t
    (**/**)
      
    (**)
    method destroy : unit

    (**/**)
    method rep__sf_Http : Http.t
    (**/**)
      
    (** Send a HTTP request and return the server's response.

	You must have a valid host before sending a request (see SetHost). Any missing mandatory header field in the request will be added with an appropriate value. Warning: this function waits for the server's response and may not return instantly; use a thread if you don't want to block your application, or use a timeout to limit the time to wait. A value of Time::Zero means that the client will use the system defaut timeout (which is usually pretty long).
	@return Server's response *)
    method send_request : ?timeout:OcsfmlSystem.Time.t -> request -> response
      
    (** Set the target host.

	This function just stores the host address and port, it doesn't actually connect to it until you send a request. The port has a default value of 0, which means that the HTTP client will use the right port according to the protocol used (80 for HTTP, 443 for HTTPS). You should leave it like this unless you really need a port other than the standard one, or use an unknown protocol.*)
    method set_host : ?port:int -> string -> unit
  end
end


(**/**)
module Packet :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val append : t -> OcsfmlSystem.raw_data_type -> unit
  val clear : t -> unit
  val get_data : t -> OcsfmlSystem.raw_data_type
  val get_data_size : t -> int
  val end_of_packet : t -> bool
  val is_valid : t -> bool
  val read_bool : t -> bool
  val read_int8 : t -> int
  val read_uint8 : t -> int
  val read_int16 : t -> int
  val read_uint16 : t -> int
  val read_int32 : t -> int
  val read_uint32 : t -> int
  val read_float : t -> float
  val read_string : t -> string
  val write_bool : t -> bool -> unit
  val write_int8 : t -> int -> unit
  val write_uint8 : t -> int -> unit
  val write_int16 : t -> int -> unit
  val write_uint16 : t -> int -> unit
  val write_int32 : t -> int -> unit
  val write_uint32 : t -> int -> unit
  val write_float : t -> float -> unit
  val write_string : t -> string -> unit
end
(**/**)

(** Utility class to build blocks of data to transfer over the network.
    
    Packets provide a safe and easy way to serialize data, in order to send it over the network using sockets (sf::TcpSocket, sf::UdpSocket).
    
    Packets solve 2 fundamental problems that arise when transfering data over the network:
    
    - data is interpreted correctly according to the endianness
    - the bounds of the packet are preserved (one send == one receive)
    
    The sf::Packet class provides both input and output modes. It is designed to follow the behaviour of standard C++ streams, using operators >> and << to extract and insert data.
    
    It is recommended to use only fixed-size types (like Int32, etc.), to avoid possible differences between the sender and the receiver. Indeed, the native C++ types may have different sizes on two platforms and your data may be corrupted if that happens.
    
    Usage example:
    {[
    let x = 24;
    let s = "hello";
    let d = 5.89;
    
(* Group the variables to send into a packet *)
    let packet = new packet in
    packet << (`Int32 x) << (`String s) << (`Float d) ;
    
(* Send it over the network (socket is a valid tcp_socket) *)
    socket#send packet
    
    -----------------------------------------------------------------

(* Receive the packet at the other end *)
    let packet = new packet in
    socket#receive packet ;
    
(* Extract the variables contained in the packet *)
    let x = ref 0 in
    let s = ref "" in
    ler d = ref 0. in
    if (packet >> (`Int32 x) >> (`String s) >> (`Float d))#is_valid
    then begin
(* Data extracted successfully... *)
    end
    ]} *)
class packet :
object
  (**/**)
  val t_packet_base : Packet.t
  (**/**)
    
  (** Append data to the end of the packet. *)
  method append : OcsfmlSystem.raw_data_type -> unit

  (** Clear the packet.

      After calling clear, the packet is empty.*)
  method clear : unit
    
  (**)
  method destroy : unit
    
  (** Tell if the reading position has reached the end of the packet.

      This function is useful to know if there is some data left to be read, without actually reading it.
      @return True if all data was read, false otherwise*)
  method end_of_packet : bool
    
  (** Get the size of the data contained in the packet.

      This function returns the number of bytes pointed to by what getData returns.
      @return Data size, in bytes*)
  method get_data_size : int

  (** Get a pointer to the data contained in the packet.

      Warning: the returned pointer may become invalid after you append data to the packet, therefore it should never be stored. The return pointer is NULL if the packet is empty.
      @return Bigarray of the data*)
  method get_data : OcsfmlSystem.raw_data_type
    
  (** Test the validity of the packet, for reading. 

      A packet will be in an invalid state if it has no more data to read.
      @return True if last data extraction from packet was successful*)    
  method is_valid : bool
    
  (** Read a boolean from the packet *)
  method read_bool : bool
    
  (** Read a floating point number from the packet *)
  method read_float : float
    
  (** Read a 16 bits signed integer from the packet *)
  method read_int16 : int
    
  (** Read a 32 bits signed integer from the packet *)
  method read_int32 : int
    
  (** Read a 8 bits signed integer from the packet *)
  method read_int8 : int
    
  (** Read a string from the packet *)
  method read_string : string
    
  (** Read a 16 bits unsigned integer from the packet *)
  method read_uint16 : int
    
  (** Read a 16 bits unsigned integer from the packet *)
  method read_uint32 : int
    
  (** Read a 8 bits unsigned integer from the packet *)
  method read_uint8 : int
    
  (**/**)
  method rep__sf_Packet : Packet.t
  (**/**)
    
  (** Write a boolean into the packet *)
  method write_bool : bool -> unit
    
  (** Write a floating point number into the packet *)
  method write_float : float -> unit
    
  (** Write a 16 bits signed integer into the packet *)
  method write_int16 : int -> unit
    
  (** Write a 32 bits signed integer into the packet *)
  method write_int32 : int -> unit
    
  (** Write a 8 bits signed integer into the packet *)
  method write_int8 : int -> unit
    
  (** Write a string into the packet *)
  method write_string : string -> unit
    
  (** Write a 16 bits unsigned integer into the packet *)
  method write_uint16 : int -> unit
    
  (** Write a 32 bits unsigned integer into the packet *)
  method write_uint32 : int -> unit
    
  (** Write a 8 bits unsigned integer into the packet *)
  method write_uint8 : int -> unit
end


type read_val =
  [ `Bool of bool ref
  | `Float of float ref
  | `Int16 of int ref
  | `Int32 of int ref
  | `Int8 of int ref
  | `String of string ref
  | `UInt16 of int ref
  | `UInt32 of int ref
  | `UInt8 of int ref ]

type write_val =
  [ `Bool of bool
  | `Float of float
  | `Int16 of int
  | `Int32 of int
  | `Int8 of int
  | `String of string
  | `UInt16 of int
  | `UInt32 of int
  | `UInt8 of int ]

val ( >> ) :
  (#packet as 'a) ->
  [< `Bool of bool ref
  | `Float of float ref
  | `Int16 of int ref
  | `Int32 of int ref
  | `Int8 of int ref
  | `String of string ref
  | `UInt16 of int ref
  | `UInt32 of int ref
  | `UInt8 of int ref ] ->
  'a

val ( << ) :
  (#packet as 'a) ->
  [< `Bool of bool
  | `Float of float
  | `Int16 of int
  | `Int32 of int
  | `Int8 of int
  | `String of string
  | `UInt16 of int
  | `UInt32 of int
  | `UInt8 of int ] ->
  'a

(** Status codes that may be returned by socket functions. *)
type socket_status = 
    Done (** The socket has sent / received the data. *)
  | NotReady  (** The socket is not ready to send / receive data yet. *)
  | Disconnected  (** The TCP socket has been disconnected. *)
  | Error (** An unexpected error happened. *)

(**/**)
module Socket :
sig
  type t
  val destroy : t -> unit
  val set_blocking : t -> bool -> unit
  val is_blocking : t -> bool
end
(**/**)

(** Base class for all the socket types.
    
    This class mainly defines internal stuff to be used by derived classes.
    
    The only public features that it defines, and which is therefore common to all the socket classes, is the blocking state. All sockets can be set as blocking or non-blocking.
    
    In blocking mode, socket functions will hang until the operation completes, which means that the entire program (well, in fact the current thread if you use multiple ones) will be stuck waiting for your socket operation to complete.
    
    In non-blocking mode, all the socket functions will return immediately. If the socket is not ready to complete the requested operation, the function simply returns the proper status code (NotReady).

    The default mode, which is blocking, is the one that is generally used, in combination with threads or selectors. The non-blocking mode is rather used in real-time applications that run an endless loop that can poll the socket often enough, and cannot afford blocking this loop. *)
class socket :
  Socket.t ->
object
  (**/**)
  val t_socket : Socket.t
  (**/**)

  (**)
  method destroy : unit

  (** Tell whether the socket is in blocking or non-blocking mode. 
      @return True if the socket is blocking, false otherwise*)
  method is_blocking : bool

  (**/**)
  method rep__sf_Socket : Socket.t
  (**/**)

  (** Set the blocking state of the socket.

      In blocking mode, calls will not return until they have completed their task. For example, a call to receive in blocking mode won't return until some data was actually received. In non-blocking mode, calls will always return immediately, using the return code to signal whether there was data available or not. By default, all sockets are blocking.*)
  method set_blocking : bool -> unit
end


(**/**)
module SocketSelector :
sig
  type t
  val destroy : t -> unit
  val default : unit -> t
  val add : t -> Socket.t -> unit
  val remove : t -> Socket.t -> unit
  val clear : t -> unit
  val wait : t -> ?timeout:OcsfmlSystem.Time.t -> unit -> bool
  val is_ready : t -> Socket.t -> bool
  val affect : t -> t -> t
end
(**/**)

(** Multiplexer that allows to read from multiple sockets.

    Socket selectors provide a way to wait until some data is available on a set of sockets, instead of just one.

    This is convenient when you have multiple sockets that may possibly receive data, but you don't know which one will be ready first. In particular, it avoids to use a thread for each socket; with selectors, a single thread can handle all the sockets.

    All types of sockets can be used in a selector:

    - tcp_listener
    - tcp_socket
    - udp_socket

    A selector doesn't store its own copies of the sockets (socket classes are not copyable anyway), it simply keeps a reference to the original sockets that you pass to the add function. Therefore, you can't use the selector as a socket container, you must store them oustide and make sure that they are alive as long as they are used in the selector.

    Using a selector is simple:

    - populate the selector with all the sockets that you want to observe
    - make it wait until there is data available on any of the sockets
    - test each socket to find out which ones are ready

    Usage example:
    {[
(* Create a socket to listen to new connections *)
    let listener = new tcp_listener in
    listener#listen 55001 ;

(* Create a list to store the future clients *)
    let clients = ref [] in

(* Create a selector *)
    let selector = new socket_selector (SocketSelector.default ()) in

(* Add the listener to the selector *)
    selector#add listener 

(* Endless loop that waits for new connections *)
    let rec connection_loop () =
(* Make the selector wait for data on any socket *)
    if selector#wait
    then begin
(* Test the listener *)
    if selector#is_ready listener
    then begin
(* The listener is ready: there is a pending connection *)
    let client = new tcp_socket in
    if (listener#accept client) = Done
    then begin
(* Add the new client to the clients list *)
    clients := client :: !clients ;

(* Add the new client to the selector so that we will
    be notified when he sends something *)
    selector#add client
    end
    end
    else begin
(* The listener socket is not ready, test all other sockets (the clients) *)
    List.iter ( function client ->
    if selector#is_ready client
    then begin
(* The client has sent some data, we can receive it *)
    let packet = new packet in
    if (client#receive packet) = Done
    then begin 
    ...
    end
    end ) clients
    end
    end ;
    connection_loop ()
    in connection_loop ()
    ]}*)
class socket_selector :
object ('self)
  (**/**)
  val t_socket_selector : SocketSelector.t
  (**/**)

  (** Add a new socket to the selector.

      This function keeps a weak reference to the socket, so you have to make sure that the socket is not destroyed while it is stored in the selector.*)
  method add : #socket -> unit

  (** Remove all the sockets stored in the selector.

      This function doesn't destroy any instance, it simply removes all the references that the selector has to external sockets.*)
  method clear : unit

  (**)
  method destroy : unit

  (** Test a socket to know if it is ready to receive data.

      This function must be used after a call to wait, to know which sockets are ready to receive data. If a socket is ready, a call to receive will never block because we know that there is data available to read. Note that if this function returns true for a TcpListener, this means that it is ready to accept a new connection.
      @return True if the socket is ready to read, false otherwise*)
  method is_ready : #socket -> bool

  (** Remove a socket from the selector.

      This function doesn't destroy the socket, it simply removes the reference that the selector has to it.*)
  method remove : #socket -> unit

  (**/**)
  method rep__sf_SocketSelector : SocketSelector.t

  (** *)
  method affect : 'self -> unit

  (** Wait until one or more sockets are ready to receive.

      This function returns as soon as at least one socket has some data available to be received. To know which sockets are ready, use the is_ready function. If you use a timeout and no socket is ready before the timeout is over, the function returns false.
      @return True if there are sockets ready, false otherwise*)
  method wait : ?timeout:OcsfmlSystem.Time.t -> unit -> bool
end

module Port :
sig
  type t = private int
  val from_int : int -> t
end

(**/**)
module TcpSocket :
sig
  type t
  val destroy : t -> unit
  val to_socket : t -> Socket.t
  val default : unit -> t
  val get_local_port : t -> Port.t
  val get_remote_address : t -> IPAddress.t
  val get_remote_port : t -> Port.t
  val connect :
    t -> ?timeout:OcsfmlSystem.Time.t -> IPAddress.t -> Port.t -> socket_status
  val disconnect : t -> unit
  val send_packet : t -> Packet.t -> socket_status
  val receive_packet : t -> Packet.t -> socket_status
  val send_data : t -> OcsfmlSystem.raw_data_type -> socket_status
  val receive_data : t -> OcsfmlSystem.raw_data_type -> (socket_status * int)
  val send_string : t -> string -> socket_status
  val receive_string : t -> string -> (socket_status * int)
end
(**/**)
  
(** Specialized socket using the TCP protocol.
    
    TCP is a connected protocol, which means that a TCP socket can only communicate with the host it is connected to.
    
    It can't send or receive anything if it is not connected.
    
    The TCP protocol is reliable but adds a slight overhead. It ensures that your data will always be received in order and without errors (no data corrupted, lost or duplicated).
    
    When a socket is connected to a remote host, you can retrieve informations about this host with the getRemoteAddress and GetRemotePort functions. You can also get the local port to which the socket is bound (which is automatically chosen when the socket is connected), with the getLocalPort function.
    
    Sending and receiving data can use either the low-level or the high-level functions. The low-level functions process a raw sequence of bytes, and cannot ensure that one call to Send will exactly match one call to Receive at the other end of the socket.
    
    The high-level interface uses packets (see sf::Packet), which are easier to use and provide more safety regarding the data that is exchanged. You can look at the sf::Packet class to get more details about how they work.
    
    The socket is automatically disconnected when it is destroyed, but if you want to explicitely close the connection while the socket instance is still alive, you can call disconnect.
    
    Usage example:
    {[
(* ----- The client ----- *)
    
(* Create a socket and connect it to 192.168.1.50 on port 55001 *)
    let socket = new tcp_socket in
    socket#connect (new ip_address (`String "192.168.1.50")) 55001 ;
    
(* Send a message to the connected host *)
    let message = "Hi, I am a client" in
    
    socket#send_string message;
    
(* Receive an answer from the server *)
    let buffer = String.create 1024 in
    let (status, received) = socket#receive_string buffer in
    print_string "The server said: " ; 
    output stdout buffer 0 received ;
    print_newline () ;
    
(* ----- The server ----- *)

(* Create a listener to wait for incoming connections on port 55001 *)
    let listener = new listener in
    listener#listen 55001 ;
    
(* Wait for a connection *)
    let socket = new tcp_socket in
    listener#accept socket;
    print_endline ("New client connected: " + socket#get_remote_address#to_string) ;
    
(* Receive a message from the client *)
    let buffer = String.create 1024 in
    let (status, received) = socket#receive_string buffer in
    print_string "The client said: " ; 
    output stdout buffer 0 received ; 
    print_newline () ;
    
(* Send an answer *)
    let message = "Welcome, client";
    socket#send_string message;
    ]}*)
class tcp_socket :
object
  inherit socket

  (**/**)
  val t_tcp_socket_base : TcpSocket.t
  (**/**)

  (** Connect the socket to a remote peer.

      In blocking mode, this function may take a while, especially if the remote peer is not reachable. The timeout parameter allows you to stop trying to connect after a given timeout. If the socket was previously connected, it is first disconnected. 
      @param timeout Optional maximum time to wait 
      @return Status code*)
  method connect : ?timeout:OcsfmlSystem.Time.t -> ip_address -> Port.t -> socket_status

  (**)
  method destroy : unit

  (** Disconnect the socket from its remote peer.

      This function gracefully closes the connection. If the socket is not connected, this function has no effect. *)
  method disconnect : unit

  (** Get the port to which the socket is bound locally.

      If the socket is not connected, this function returns 0. 
      @return Port to which the socket is bound. *)
  method get_local_port : Port.t

  (** Get the address of the connected peer.

      It the socket is not connected, this function returns IPAddress.none. 
      @return Address to the remote peer*)
  method get_remote_address : ip_address

  (** Get the port of the connected peer to which the socket is connected.

      If the socket is not connected, this function returns 0.
      @return Remote port to which the socket is connected*)
  method get_remote_port : Port.t


  (** Receive raw data from the remote peer.

      In blocking mode, this function will wait until some bytes are actually received. This function will fail if the socket is not connected.
      @return Status code and the actual number of byte received. *)
  method receive_data : OcsfmlSystem.raw_data_type -> (socket_status * int)

  (** Receive a formatted packet of data from the remote peer.

      In blocking mode, this function will wait until the whole packet has been received. This function will fail if the socket is not connected.
      @return Status code *)
  method receive_packet : #packet -> socket_status

  (** Receive raw data from the remote peer.

      In blocking mode, this function will wait until some bytes are actually received. This function will fail if the socket is not connected.
      @return Status code and the actual number of byte received*)
  method receive_string : string -> (socket_status * int)

  (**/**)
  method rep__sf_TcpSocket : TcpSocket.t
  (**/**)


  (** Send raw data to the remote peer.

      This function will fail if the socket is not connected.
      @return Status code*)
  method send_data : OcsfmlSystem.raw_data_type -> socket_status

  (** Send a formatted packet of data to the remote peer.

      This function will fail if the socket is not connected.
      @return Status code*)
  method send_packet : #packet -> socket_status

  (** Send raw data to the remote peer.

      This function will fail if the socket is not connected.
      @return Status code*)
  method send_string : string -> socket_status
end


(**/**)
module TcpListener :
sig
  type t
  val destroy : t -> unit
  val to_socket : t -> Socket.t
  val default : unit -> t
  val get_local_port : t -> Port.t
  val listen : t -> Port.t -> socket_status
  val close : t -> unit
  val accept : t -> TcpSocket.t -> socket_status
end
(**/**)

(** Socket that listens to new TCP connections.
    
    A listener socket is a special type of socket that listens to a given port and waits for connections on that port.
    
    This is all it can do.
    
    When a new connection is received, you must call accept and the listener returns a new instance of sf::TcpSocket that is properly initialized and can be used to communicate with the new client.
    
    Listener sockets are specific to the TCP protocol, UDP sockets are connectionless and can therefore communicate directly. As a consequence, a listener socket will always return the new connections as tcp_socket instances.
    
    A listener is automatically closed on destruction, like all other types of socket. However if you want to stop listening before the socket is destroyed, you can call its close function.
    
    Usage example:
    {[  
(* Create a listener socket and make it wait for new 
    connections on port 55001 *)
    let listener = new tcp_listener in
    listener#listen (Port.from_int 55001) 
    
(* Endless loop that waits for new connections *)
    let rec connection_loop running =
    if running
    then begin
    let client = new tcp_socket in
    if  listener#accept(client) = Done
    then begin
(* A new client just connected! *)
    print_endline ("New connection received from " ^ client#getçremote_address#to_string) ;
    do_something_with client
    end ;
    connection_loop ...
    end
    in connection_loop true
    ]}*)
class tcp_listener :
object
  inherit socket

  (**/**)
  val t_tcp_listener_base : TcpListener.t
  (**/**)

  (** Accept a new connection.

      If the socket is in blocking mode, this function will not return until a connection is actually received.
      @return Status code *)
  method accept : tcp_socket -> socket_status
    
  (** Stop listening and close the socket.

      This function gracefully stops the listener. If the socket is not listening, this function has no effect. *)
  method close : unit

  (**)
  method destroy : unit

  (** Get the port to which the socket is bound locally.

      If the socket is not listening to a port, this function returns 0.
      @return Port to which the socket is bound*)
  method get_local_port : Port.t

  (** Start listening for connections.

      This functions makes the socket listen to the specified port, waiting for new connections. If the socket was previously listening to another port, it will be stopped first and bound to the new port.
      @return Status code*)
  method listen : Port.t -> socket_status

  (**/**)
  method rep__sf_TcpListener : TcpListener.t
(**/**)
end



val max_datagram_size : int

(**/**)
module UdpSocket :
sig
  type t
  val destroy : t -> unit
  val to_socket : t -> Socket.t
  val default : unit -> t
  val bind : t -> Port.t -> socket_status
  val unbind : t -> unit
  val get_local_port : t -> Port.t
  val send_packet : t -> Packet.t -> IPAddress.t -> Port.t -> socket_status
  val receive_packet : t -> Packet.t -> IPAddress.t -> socket_status * Port.t 
  val send_data : t -> OcsfmlSystem.raw_data_type -> IPAddress.t -> Port.t -> socket_status
  val receive_data : t -> OcsfmlSystem.raw_data_type -> IPAddress.t  -> socket_status * int * Port.t
  val send_string : t -> string -> IPAddress.t -> Port.t -> socket_status
  val receive_string : t -> string -> IPAddress.t  -> socket_status * int * Port.t

end
(**/**)


(** Specialized socket using the UDP protocol.
    
    A UDP socket is a connectionless socket.
    
    Instead of connecting once to a remote host, like TCP sockets, it can send to and receive from any host at any time.
    
    It is a datagram protocol: bounded blocks of data (datagrams) are transfered over the network rather than a continuous stream of data (TCP). Therefore, one call to send will always match one call to receive (if the datagram is not lost), with the same data that was sent.
    
    The UDP protocol is lightweight but unreliable. Unreliable means that datagrams may be duplicated, be lost or arrive reordered. However, if a datagram arrives, its data is guaranteed to be valid.

    UDP is generally used for real-time communication (audio or video streaming, real-time games, etc.) where speed is crucial and lost data doesn't matter much.
    
    Sending and receiving data can use either the low-level or the high-level functions. The low-level functions process a raw sequence of bytes, whereas the high-level interface uses packets (see packet), which are easier to use and provide more safety regarding the data that is exchanged. You can look at the packet class to get more details about how they work.
    
    It is important to note that UdpSocket is unable to send datagrams bigger than MaxDatagramSize. In this case, it returns an error and doesn't send anything. This applies to both raw data and packets. Indeed, even packets are unable to split and recompose data, due to the unreliability of the protocol (dropped, mixed or duplicated datagrams may lead to a big mess when trying to recompose a packet).
    
    If the socket is bound to a port, it is automatically unbound from it when the socket is destroyed. However, you can unbind the socket explicitely with the Unbind function if necessary, to stop receiving messages or make the port available for other sockets.
    
    Usage example:
    {[
(* ----- The client ----- *)
    
(* Create a socket and bind it to the port 55001 *)
    let socket = new udp_socket in
    socket.bind (Port.from_int 55001)
    
(* Send a message to 192.168.1.50 on port 55002 *)
    let message = "Hi, I am " ^ (IPAddress.get_local_address ())#to_string;
    socket#send message "192.168.1.50" (Port.from_int 55002);
    
(* Receive an answer (most likely from 192.168.1.50, but could be anyone else) *)
    let buffer = String.create 1024 in
    let sender = new ip_address `None in
    let (_, received, _) = socket#receive buffer sender in
    print_string (sender#to_string ^ " said: ")  ;
    output stdout buffer 0 received ;
    print_newline ()
    
(* ----- The server ----- *)
    
(* Create a socket and bind it to the port 55002 *)
    let socket = new udp_socket in
    socket#bind (Port.from_int 55002) ;
    
(* Receive a message from anyone *)
    let buffer = String.create 1024 in
    let sender = new ip_address `None in
    let (_, received, port) = socket.receive(buffer, sizeof(buffer), received, sender) in
    print_string (sender#to_string ^ " said: ")  ;
    output stdout buffer 0 received ;
    print_newline ()
    
    
(* Send an answer *)
    let message = "Welcome " ^ sender#to_string in
    socket#send message sender port;
    ]}*)
class udp_socket :
object
  inherit socket

  (**/**)
  val t_udp_socket_base : UdpSocket.t
  (**/**)

  (** Bind the socket to a specific port.

      Binding the socket to a port is necessary for being able to receive data on that port. You can use the special value Socket::AnyPort to tell the system to automatically pick an available port, and then call getLocalPort to retrieve the chosen port.
      @return Status code. *)
  method bind : Port.t -> socket_status

  (**)
  method destroy : unit

  (** Get the port to which the socket is bound locally.

      If the socket is not bound to a port, this function returns 0.
      @return Port to which the socket is bound*)
  method get_local_port : Port.t

  (** Receive raw data from a remote peer.

      In blocking mode, this function will wait until some bytes are actually received. Be careful to use a buffer which is large enough for the data that you intend to receive, if it is too small then an error will be returned and *all* the data will be lost.
      @return Status code, actual number of byte received and port of the peer that has sent the data *)
  method receive_data : OcsfmlSystem.raw_data_type -> ip_address -> socket_status * int * Port.t

  (** Receive a formatted packet of data from a remote peer.

      In blocking mode, this function will wait until the whole packet has been received.
      @return Status and port of the peer tha has sent the data*)
  method receive_packet : #packet -> ip_address -> socket_status * Port.t
    
  (** Receive raw data from a remote peer.

      In blocking mode, this function will wait until some bytes are actually received. Be careful to use a buffer which is large enough for the data that you intend to receive, if it is too small then an error will be returned and *all* the data will be lost.
      @return Status code, actual number of byte received and port of the peer that has sent the data *)
  method receive_string : string -> ip_address -> socket_status * int * Port.t

  (**/**)
  method rep__sf_UdpSocket : UdpSocket.t
  (**/**)

  (** Send raw data to a remote peer.

      Make sure that size is not greater than UdpSocket::MaxDatagramSize, otherwise this function will fail and no data will be sent.
      @return Status code*)
  method send_data : OcsfmlSystem.raw_data_type -> ip_address -> Port.t -> socket_status

  (** Send a formatted packet of data to a remote peer.

      Make sure that the packet size is not greater than UdpSocket::MaxDatagramSize, otherwise this function will fail and no data will be sent.
      @return Status code*)
  method send_packet : #packet -> ip_address -> Port.t -> socket_status

  (** Send raw data to a remote peer.

      Make sure that size is not greater than UdpSocket::MaxDatagramSize, otherwise this function will fail and no data will be sent.
      @return Status code*)
  method send_string : string -> ip_address -> Port.t -> socket_status

  (** Unbind the socket from the local port to which it is bound.

      The port that the socket was previously using is immediately available after this function is called. If the socket is not bound to a port, this function has no effect. *)
  method unbind : unit
end


