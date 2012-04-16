
external class ip_address (IPAddressCPP) : "sf_IpAddress" =
object
  constructor default : unit = "default_constructor"
  constructor from_string : string = "string_constructor"
  constructor from_bytes : int -> int -> int -> int = "bytes_constructor"
  constructor from_int : int = "integer_constructor"
  external method to_string : string = "toString"
  external method to_integer : int = "toInteger"
end

module IPAddress =
struct
  include IPAddressCPP
  external cpp get_local_address : unit -> ip_address = "sf_IpAddress_getLocalAddress"
  external cpp get_public_address : ?timeout:OcsfmlSystem.Time.t -> unit -> ip_address = "sf_IpAddress_getPublicAddress"
  let none = new ip_address (default ())
  let localhost = new ip_address (from_string "127.0.0.1")
  let equal x y = x#rep__sf_IpAddress = y#rep__sf_IpAddress
end

let mk_ip_address = function
  | `None -> new ip_address (IPAddress.default ())
  | `String s -> new ip_address (IPAddress.from_string s)
  | `Bytes (x,y,z,w) -> new ip_address (IPAddress.from_bytes x y z w)
  | `Int i -> new ip_address (IPAddress.from_int i)


module FTP =
struct

  type transfer_mode = Binary | Ascii | Ebcdic

  module Status =
  struct
    type t = int
	
    (* 1xx: the requested action is being initiated,*)
    (* expect another reply before proceeding with a new command*)
    let restartMarkerReply          = 110 (**< Restart marker reply*)
    let serviceReadySoon            = 120 (**< Service ready in N minutes*)
    let dataConnectionAlreadyOpened = 125 (**< Data connection already opened, transfer starting*)
    let openingDataConnection       = 150 (**< File status ok, about to open data connection*)
      
    (* 2xx: the requested action has been successfully completed*)
    let ok                    = 200 (**< Command ok*)
    let pointlessCommand      = 202 (**< Command not implemented*)
    let systemStatus          = 211 (**< System status, or system help reply*)
    let directoryStatus       = 212 (**< Directory status*)
    let fileStatus            = 213 (**< File status*)
    let helpMessage           = 214 (**< Help message*)
    let systemType            = 215 (**< NAME system type, where NAME is an official system name from the list in the Assigned Numbers document*)
    let serviceReady          = 220 (**< Service ready for new user*)
    let closingConnection     = 221 (**< Service closing control connection*)
    let dataConnectionOpened  = 225 (**< Data connection open, no transfer in progress*)
    let closingDataConnection = 226 (**< Closing data connection, requested file action successful*)
    let enteringPassiveMode   = 227 (**< Entering passive mode*)
    let loggedIn              = 230 (**< User logged in, proceed. Logged out if appropriate*)
    let fileActionOk          = 250 (**< Requested file action ok*)
    let directoryOk           = 257 (**< PATHNAME created*)
      
    (* 3xx: the command has been accepted, but the requested action*)
    (* is dormant, pending receipt of further information*)
    let needPassword       = 331 (**< User name ok, need password*)
    let needAccountToLogIn = 332 (**< Need account for login*)
    let needInformation    = 350 (**< Requested file action pending further information*)
      
    (* 4xx: the command was not accepted and the requested action did not take place,*)
    (* but the error condition is temporary and the action may be requested again*)
    let serviceUnavailable        = 421 (**< Service not available, closing control connection*)
    let dataConnectionUnavailable = 425 (**< Can't open data connection*)
    let transferAborted           = 426 (**< Connection closed, transfer aborted*)
    let fileActionAborted         = 450 (**< Requested file action not taken*)
    let localError                = 451 (**< Requested action aborted, local error in processing*)
    let insufficientStorageSpace  = 452 (**< Requested action not taken; insufficient storage space in system, file unavailable*)
      
    (* 5xx: the command was not accepted and*)
    (* the requested action did not take place*)
    let commandUnknown          = 500 (**< Syntax error, command unrecognized*)
    let parametersUnknown       = 501 (**< Syntax error in parameters or arguments*)
    let commandNotImplemented   = 502 (**< Command not implemented*)
    let badCommandSequence      = 503 (**< Bad sequence of commands*)
    let parameterNotImplemented = 504 (**< Command not implemented for that parameter*)
    let notLoggedIn             = 530 (**< Not logged in*)
    let needAccountToStore      = 532 (**< Need account for storing files*)
    let fileUnavailable         = 550 (**< Requested action not taken, file unavailable*)
    let pageTypeUnknown         = 551 (**< Requested action aborted, page type unknown*)
    let notEnoughMemory         = 552 (**< Requested file action aborted, exceeded storage allocation*)
    let filenameNotAllowed      = 553 (**< Requested action not taken, file name not allowed*)
      
    (* 10xx: SFML custom codes*)
    let invalidResponse  = 1000 (**< Response is not a valid FTP one*)
    let connectionFailed = 1001 (**< Connection with server failed*)
    let connectionClosed = 1002 (**< Connection with server closed*)
    let invalidFile      = 1003  (**< Invalid file to upload / download*)
      
  end
    
  external class response : "sf_Ftp_Response" = 
  object
    constructor default : ?code:Status.t -> ?msg:string -> unit = "default_constructor" 
    external method get_status : Status.t = "getStatus" 
    external method get_message : string = "getMessage" 
    external method is_ok : bool = "isOk"
  end
    
  external class directory_response (DirectoryResponse) : "sf_Ftp_DirectoryResponse" = 
  object
    external inherit response : "sf_Ftp_Response" 
    constructor default : response = "default_constructor"
    external method get_directory : string = "getDirectory" 
  end

  external class listing_response (ListingResponse) : "sf_Ftp_ListingResponse" = 
  object
    external inherit response : "sf_Ftp_Response" 
    constructor default : response -> char list (* ou char array ? *) = "default_constructor"
    external method get_filenames : string list (* ou string array ? *) = "getFilenames" 
  end 

  external class ftp (Ftp) : "sf_Ftp" =
  object 
    constructor default : unit = "default_constructor"
    external method connect : ?port:int -> ?timeout:OcsfmlSystem.Time.t -> ip_address -> response = "connect"
    external method disconnect : response = "disconnect"
    external method login : ?log:string*string -> unit -> response = "login"
    external method keep_alive : response = "keepAlive"
    external method get_working_directory : directory_response = "getWorkingDirectory"
    external method get_directory_listing : ?dir:string -> unit -> listing_response = "getDirectoryListing"
    external method change_directory : string -> response = "changeDirectory"
    external method parent_directory : response = "parentDirectory"
    external method create_directory : string -> response = "createDirectory"
    external method delete_directory : string -> response = "deleteDirectory"
    external method rename_file : string -> string -> response = "renameFile"
    external method delete_file : string -> response = "deleteFile"
    external method download : ?mode:transfer_mode -> string -> string -> response = "download"
    external method upload : ?mode:transfer_mode -> string -> string -> response = "upload"
  end
    
end

module HTTP =
struct

  type request_method = Get | Post | Head

  module Status =
    struct
      type t = int

      (* 2xx: success*)
      let ok             = 200 (**< Most common code returned when operation was successful*)
      let created        = 201 (**< The resource has successfully been created*)
      let accepted       = 202 (**< The request has been accepted, but will be processed later by the server*)
      let noContent      = 204 (**< The server didn't send any data in return*)
      let resetContent   = 205 (**< The server informs the client that it should clear the view (form) that caused the request to be sent*)
      let partialContent = 206 (**< The server has sent a part of the resource, as a response to a partial GET request*)
	
      (* 3xx: redirection*)
      let multipleChoices  = 300 (**< The requested page can be accessed from several locations*)
      let movedPermanently = 301 (**< The requested page has permanently moved to a new location*)
      let movedTemporarily = 302 (**< The requested page has temporarily moved to a new location*)
      let notModified      = 304 (**< For conditionnal requests, means the requested page hasn't changed and doesn't need to be refreshed*)

      (* 4xx: client error*)
      let badRequest          = 400 (**< The server couldn't understand the request (syntax error)*)
      let unauthorized        = 401 (**< The requested page needs an authentification to be accessed*)
      let forbidden           = 403 (**< The requested page cannot be accessed at all, even with authentification*)
      let notFound            = 404 (**< The requested page doesn't exist*)
      let rangeNotSatisfiable = 407 (**< The server can't satisfy the partial GET request (with a "Range" header field)*)

      (* 5xx: server error*)
      let internalServerError = 500 (**< The server encountered an unexpected error*)
      let notImplemented      = 501 (**< The server doesn't implement a requested feature*)
      let badGateway          = 502 (**< The gateway server has received an error from the source server*)
      let serviceNotAvailable = 503 (**< The server is temporarily unavailable (overloaded, in maintenance ...)*)
      let gatewayTimeout      = 504 (**< The gateway server couldn't receive a response from the source server*)
      let versionNotSupported = 505 (**< The server doesn't support the requested HTTP version*)

      (* 10xx: SFML custom codes*)
      let invalidResponse  = 1000 (**< Response is not a valid HTTP one*)
      let connectionFailed = 1001  (**< Connection with server failed*)

    end


  external class request : "sf_Http_Request" =
  object
    constructor default : ?uri:string -> ?meth:request_method -> ?body:string -> unit = "default_constructor"
    external method set_field : string -> string -> unit = "setField"
    external method set_method : request_method -> unit = "setMethod"
    external method set_uri : string -> unit = "setUri"
    external method set_http_version : int -> int -> unit = "setHttpVersion"
    external method set_body : string -> unit = "setBody"
  end

  external class response : "sf_Http_Response" =
  object
    constructor default : unit = "default_constructor"
    external method get_field : string -> string = "getField"
    external method get_status : Status.t = "getStatus"
    external method get_major_http_version : int = "getMajorHttpVersion"
    external method get_minor_http_version : int = "getMinorHttpVersion"
    external method get_body : string = "getBody"
  end

  external class http : "sf_Http" =
  object
    constructor default : unit = "default_constructor"
    constructor from_host : string = "host_constructor"
    constructor from_host_and_port : string -> int = "host_and_port_constructor"
    external method set_host : ?port:int -> string -> unit = "setHost"
    external method send_request : ?timeout:OcsfmlSystem.Time.t -> request -> response = "sendRequest"
  end

end


external class packetCpp (Packet) : "sf_Packet" =
object
  constructor default : unit = "default_constructor"
  external method append : OcsfmlSystem.raw_data_type -> unit = "append"
  external method clear : unit = "clear"
  external method get_data : OcsfmlSystem.raw_data_type = "getData"
  external method get_data_size : int = "getDataSize"
  external method end_of_packet : bool = "endOfPacket"
  external method is_valid : bool = "isValid"
  external method read_bool : bool = "readBool"
  external method read_int8 : int = "readInt8"
  external method read_uint8 : int = "readUint8"
  external method read_int16 : int = "readInt16"
  external method read_uint16 : int = "readUint16"
  external method read_int32 : int = "readInt32"
  external method read_uint32 : int = "readUint32"
  external method read_float : float = "readFloat"
  external method read_string : string = "readString"
  external method write_bool : bool -> unit = "writeBool"
  external method write_int8 : int -> unit = "writeInt8"
  external method write_uint8 : int -> unit = "writeUint8"
  external method write_int16 : int -> unit = "writeInt16"
  external method write_uint16 : int -> unit = "writeUint16"
  external method write_int32 : int -> unit = "writeInt32"
  external method write_uint32 : int -> unit = "writeUint32"
  external method write_float : float -> unit = "writeFloat"
  external method write_string : string -> unit = "writeString"
end

class packet_bis () =
  let t = Packet.default () in
  packetCpp t

class packet =
  packet_bis ()

(* pour avoir un feeling plus SFMLisant*)

type read_val = 
    [
      `Int8 of int ref 
    | `UInt8 of int ref
    | `Int16 of int ref
    | `UInt16 of int ref
    | `Int32 of int ref (* int32 ? *)
    | `UInt32 of int ref (* int32 ? *)
    | `Float of float ref
    | `Bool of bool ref 
    | `String of string ref
    ]

type write_val = 
    [
      `Int8 of int 
    | `UInt8 of int
    | `Int16 of int
    | `UInt16 of int
    | `Int32 of int (* int32 ? *)
    | `UInt32 of int (* int32 ? *)
    | `Float of float
    | `Bool of bool 
    | `String of string
    ]

let (>>) (p:#packet) = function
    `Int8 i -> i := p#read_int8 ; p
  | `UInt8 i -> i := p#read_uint8 ; p
  | `Int16 i -> i := p#read_int16 ; p
  | `UInt16 i -> i := p#read_uint16 ; p
  | `Int32 i -> i := p#read_int32 ; p
  | `UInt32 i -> i := p#read_uint32 ; p
  | `Float f -> f := p#read_float ; p
  | `Bool b -> b := p#read_bool ; p
  | `String s -> s := p#read_string ; p

let (<<) (p:#packet) = function
    `Int8 i -> p#write_int8 i ; p
  | `UInt8 i -> p#write_uint8 i ; p
  | `Int16 i -> p#write_int16 i ; p
  | `UInt16 i -> p#write_uint16 i ; p
  | `Int32 i -> p#write_int32 i ; p
  | `UInt32 i -> p#write_uint32 i ; p
  | `Float f -> p#write_float f ; p
  | `Bool b -> p#write_bool b ; p
  | `String s -> p#write_string s ; p


type socket_status =
    Done
  | NotReady
  | Disconnected
  | Error

external class virtual socket : "sf_Socket" =
object
  external method set_blocking : bool -> unit = "setBlocking"
  external method is_blocking : bool = "isBlocking"
end

external class socket_selector (SocketSelector) : "sf_SocketSelector" =
object auto (_:'self)
  constructor default : unit = "default_constructor"
  (* constructor copy : 'self = "copy_constructor" *)
  external method add : 'a. (#socket as 'a) -> unit = "add"
  external method remove : 'a. (#socket as 'a) -> unit = "remove"
  external method clear : unit = "clear"
  external method wait : ?timeout:OcsfmlSystem.Time.t -> unit -> bool = "wait"
  external method is_ready : 'a. (#socket as 'a) -> bool = "isReady"
  external method set : 'self -> 'self = "affect"
end

external class tcp_socketCpp (TcpSocket) : "sf_TcpSocket" =
object
  external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method get_local_port : int = "getLocalPort"
  external method get_remote_address : ip_address = "getRemoteAddress"
  external method get_remote_port : int = "getRemotePort"
  external method connect : ?timeout:OcsfmlSystem.Time.t -> ip_address -> int -> socket_status = "connect"
  external method disconnect : unit = "disconnect"
  external method send_packet : 'a. (#packet as 'a) -> socket_status = "sendPacket"
  external method receive_packet :'a. (#packet as 'a) -> socket_status = "receivePacket"
  external method send_data : OcsfmlSystem.raw_data_type -> socket_status = "sendData"
  external method receive_data : OcsfmlSystem.raw_data_type -> (socket_status * int)  = "receiveData"
end

class tcp_socket_bis () =
  let t = TcpSocket.default () in
  tcp_socketCpp t

class tcp_socket =
  tcp_socket_bis ()

external class tcp_listenerCpp (TcpListener) : "sf_TcpListener" =
object
  external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method get_local_port : int = "getLocalPort"
  external method listen : int -> socket_status = "listen"
  external method close : unit = "close"
  external method accept : tcp_socket -> socket_status = "accept"
end

class tcp_listener_bis () =
  let t = TcpListener.default () in
  tcp_listenerCpp t

class tcp_listener = 
  tcp_listener_bis () 

let max_datagram_size = 65507

module UdpRemotePort =
struct
  type t = int
end

external class udp_socketCpp (UdpSocket) : "sf_UdpSocket" =
object
external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method bind : int -> socket_status = "bind"
  external method unbind : unit = "unbind"	     
  external method send_packet : 'a. (#packet as 'a) -> ip_address -> UdpRemotePort.t -> socket_status = "sendPacket"
  external method receive_packet : 'a. (#packet as 'a) -> ip_address -> socket_status * UdpRemotePort.t = "receivePacket"
  external method send_data : OcsfmlSystem.raw_data_type -> ip_address -> UdpRemotePort.t -> socket_status = "sendData"
  external method receive_data : OcsfmlSystem.raw_data_type -> ip_address -> socket_status * int  * UdpRemotePort.t = "receiveData"
end

class udp_socket_bis () =
  let t = UdpSocket.default () in
    udp_socketCpp t

class udp_socket =
  udp_socket_bis ()

(*
let cleanup_ocsfml_network () =
  IPAddress.none#destroy () ;
  IPAddress.localhost#destroy ()

let _ = at_exit cleanup_ocsfml_network *)
