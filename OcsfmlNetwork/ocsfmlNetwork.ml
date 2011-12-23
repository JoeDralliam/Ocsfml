

external class ip_address (IPAddressCPP) : "sf_IpAddress" =
object
  constructor default : unit = "default_constructor"
  constructor from_string : string = "string_constructor"
  constructor from_bytes : int -> int -> int -> int = "bytes_constructor"
  constructor from_int : int = "integer_constructor"
  external method to_string : unit -> string = "ToString"
  external method to_integer : unit -> int = "ToInteger"
end

module IPAddress =
struct
  include IPAddressCPP
  external cpp get_local_address : unit -> ip_address = "sf_IpAddress_GetLocalAddress"
  external cpp get_public_address : ?timeout:int -> unit -> ip_address = "sf_IpAddress_GetPublicAddress"
  let none = new ip_address (default ())
  let localhost = new ip_address (from_string "127.0.0.1")
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
    external method get_status : unit -> Status.t = "GetStatus" 
    external method get_message : unit -> string = "GetMessage" 
  end
    
  external class directory_response (DirectoryResponse) : "sf_Ftp_DirectoryResponse" = 
  object
    external inherit response : "sf_Ftp_Response" 
    constructor default : response = "default_constructor"
    external method get_directory : unit -> string = "GetDirectory" 
  end

  external class listing_response (ListingResponse) : "sf_Ftp_ListingResponse" = 
  object
    external inherit response : "sf_Ftp_Response" 
    constructor default : response -> char list (* ou char array ? *) = "default_constructor"
    external method get_filenames : unit -> string list (* ou string array ? *) = "GetFilenames" 
  end 

  external class ftp (Ftp) : "sf_Ftp" =
  object 
    constructor default : unit = "default_constructor"
    external method connect : ?port:int -> ?timeout:int -> ip_address -> response = "Connect"
    external method disconnect : unit -> response = "Disconnect"
    external method login : ?log:string*string -> unit -> response = "Login"
    external method keep_alive : unit -> response = "KeepAlive"
    external method get_working_directory : unit -> directory_response = "GetWorkingDirectory"
    external method get_directory_listing : ?dir:string -> unit -> listing_response = "GetDirectoryListing"
    external method change_directory : string -> response = "ChangeDirectory"
    external method parent_directory : unit -> response = "ParentDirectory"
    external method create_directory : string -> response = "CreateDirectory"
    external method delete_directory : string -> response = "DeleteDirectory"
    external method rename_file : string -> string -> response = "RenameFile"
    external method delete_file : string -> response = "DeleteFile"
    external method download : ?mode:transfer_mode -> string -> string = "Download"
    external method upload : ?mode:transfer_mode -> string -> string = "Upload"
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
    external method set_field : string -> string -> unit = "SetField"
    external method set_method : request_method -> unit = "SetMethod"
    external method set_uri : string -> unit = "SetUri"
    external method set_http_version : int -> int -> unit = "SetHttpVersion"
    external method set_body : string -> unit = "SetBody"
  end

  external class response : "sf_Http_Response" =
  object
    constructor default : unit = "default_constructor"
    external method get_field : string -> string = "GetField"
    external method get_status : unit -> Status.t = "GetStatus"
    external method get_major_http_version : unit -> int = "GetMajorHttpVersion"
    external method get_minor_http_version : unit -> int = "GetMinorHttpVersion"
    external method get_body : unit -> string = "GetBody"
  end

  external class http : "sf_Http" =
  object
    constructor default : unit = "default_constructor"
    constructor from_host : string = "host_constructor"
    constructor from_host_and_port : string -> int = "host_and_port_constructor"
    external method set_host : ?port:int -> string -> unit = "SetHost"
    external method send_request : ?timeout:int -> request -> response = "SendRequest"
  end

end


external class packetCpp (Packet) : "sf_Packet" =
object
  constructor default : unit = "default_constructor"
  external method clear : unit -> unit = "Clear"
  external method get_data_size : unit -> int = "GetDataSize"
  external method end_of_packet : unit -> bool = "EndOfPacket"
  external method is_valid : unit -> bool = "IsValid"
  external method read_bool : unit -> bool = "ReadBool"
  external method read_int8 : unit -> int = "ReadInt8"
  external method read_uint8 : unit -> int = "ReadUint8"
  external method read_int16 : unit -> int = "ReadInt16"
  external method read_uint16 : unit -> int = "ReadUint16"
  external method read_int32 : unit -> int = "ReadInt32"
  external method read_uint32 : unit -> int = "ReadUint32"
  external method read_float : unit -> float = "ReadFloat"
  external method read_string : unit -> string = "ReadString"
  external method write_bool : bool -> unit = "WriteBool"
  external method write_int8 : int -> unit = "WriteInt8"
  external method write_uint8 : int -> unit = "WriteUint8"
  external method write_int16 : int -> unit = "WriteInt16"
  external method write_uint16 : int -> unit = "WriteUint16"
  external method write_int32 : int -> unit = "WriteInt32"
  external method write_uint32 : int -> unit = "WriteUint32"
  external method write_float : float -> unit = "WriteFloat"
  external method write_string : string -> unit = "WriteString"
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
    `Int8 i -> i := p#read_int8 () ; p
  | `UInt8 i -> i := p#read_uint8 () ; p
  | `Int16 i -> i := p#read_int16 () ; p
  | `UInt16 i -> i := p#read_uint16 () ; p
  | `Int32 i -> i := p#read_int32 () ; p
  | `UInt32 i -> i := p#read_uint32 () ; p
  | `Float f -> f := p#read_float () ; p
  | `Bool b -> b := p#read_bool () ; p
  | `String s -> s := p#read_string () ; p

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
  external method set_blocking : bool -> unit = "SetBlocking"
  external method is_blocking : unit -> bool = "IsBlocking"
end

external class socket_selector (SocketSelector) : "sf_SocketSelector" =
object auto (_:'self)
  constructor default : unit = "default_constructor"
  (* constructor copy : 'self = "copy_constructor" *)
  external method add : 'a. (#socket as 'a) -> unit = "Add"
  external method remove : 'a. (#socket as 'a) -> unit = "Remove"
  external method clear : unit -> unit = "Clear"
  external method wait : ?timeout:int -> unit -> unit = "Wait"
  external method is_ready : 'a. (#socket as 'a) -> bool = "IsReady"
  external method set : 'self -> 'self = "Affect"
end

external class tcp_socketCpp (TcpSocket) : "sf_TcpSocket" =
object
  external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method get_local_port : unit -> int = "GetLocalPort"
  external method get_remote_address : unit -> ip_address = "GetRemoteAddress"
  external method get_remote_port : unit -> int = "GetRemotePort"
  external method connect : ?timeout:int -> ip_address -> int -> socket_status = "Connect"
  external method disconnect : unit -> unit = "Disconnect"
  external method send_packet : 'a. (#packet as 'a) -> socket_status = "SendPacket"
  external method receive_packet :'a. (#packet as 'a) -> socket_status = "ReceivePacket"
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
  external method get_local_port : unit -> int = "GetLocalPort"
  external method listen : int -> socket_status = "Listen"
  external method close : unit -> unit = "Close"
  external method accept : tcp_socket -> socket_status = "Accept"
end

class tcp_listener_bis () =
  let t = TcpListener.default () in
  tcp_listenerCpp t

class tcp_listener = 
  tcp_listener_bis () 

let max_datagram_size = 65507

external class udp_socketCpp (UdpSocket) : "sf_UdpSocket" =
object
external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method bind : int -> socket_status = "Bind"
  external method unbind : unit -> unit = "Unbind"	     
  external method send_packet : 'a. (#packet as 'a) -> ip_address -> int -> socket_status = "SendPacket"
  external method receive_packet : 'a. (#packet as 'a) -> ip_address -> socket_status * int = "ReceivePacket"
end

class udp_socket_bis () =
  let t = UdpSocket.default () in
    udp_socketCpp t

class udp_socket =
  udp_socket_bis ()
