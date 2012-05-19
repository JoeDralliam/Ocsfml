module IPAddressBase =
struct
  type t

  external destroy : t -> unit = "sf_IpAddress_destroy__impl"
      
  external default : unit -> t = "sf_IpAddress_default_constructor__impl"
      
  external from_string : string -> t =
      "sf_IpAddress_string_constructor__impl"
	
  external from_bytes : int -> int -> int -> int -> t =
      "sf_IpAddress_bytes_constructor__impl"
	
  external from_int : int -> t = "sf_IpAddress_integer_constructor__impl"
      
  external to_string : t -> string = "sf_IpAddress_toString__impl"
      
  external to_integer : t -> int = "sf_IpAddress_toInteger__impl"


  external get_local_address : unit -> t =
      "sf_IpAddress_getLocalAddress__impl"
	
  external get_public_address : ?timeout: OcsfmlSystem.Time.t -> unit -> t =
      "sf_IpAddress_getPublicAddress__impl"
end



  
class ip_address_base t =
object ((self : 'self))
  val t_ip_address = (t : IPAddressBase.t)
  method rep__sf_IpAddress = t_ip_address
  method destroy = IPAddressBase.destroy t_ip_address
  method to_string : string = IPAddressBase.to_string t_ip_address
  method to_integer : int = IPAddressBase.to_integer t_ip_address
end

module IPAddress =
struct
  type t = IPAddressBase.t
      

      
  let get_local_address () = new ip_address_base (IPAddressBase.get_local_address ())

  let get_public_address ?timeout () = new ip_address_base (IPAddressBase.get_public_address ?timeout ())
    
  let none = new ip_address_base (IPAddressBase.default ())
    
  let localhost = new ip_address_base (IPAddressBase.from_string "127.0.0.1")
    
  let equal x y = x#rep__sf_IpAddress = y#rep__sf_IpAddress
end  


class ip_address tag =
  let t = match tag with
    | `None -> (IPAddressBase.default ())
    | `String s -> (IPAddressBase.from_string s)
    | `Bytes (x, y, z, w) -> (IPAddressBase.from_bytes x y z w)
    | `Int i -> (IPAddressBase.from_int i)
  in ip_address_base t



       
module FTP =
struct
  type transfer_mode = | Binary | Ascii | Ebcdic
      
  module Status =
  struct
    type t = int
        
    (* 1xx: the requested action is being initiated,*)
    (* expect another reply before proceeding with a new command*)
    let restartMarkerReply = 110
      
    (**< Restart marker reply*)
    let serviceReadySoon = 120
      
    (**< Service ready in N minutes*)
    let dataConnectionAlreadyOpened = 125
      
    (**< Data connection already opened, transfer starting*)
    let openingDataConnection = 150
      
    (**< File status ok, about to open data connection*)
    (* 2xx: the requested action has been successfully completed*)
    let ok = 200
      
    (**< Command ok*)
    let pointlessCommand = 202
      
    (**< Command not implemented*)
    let systemStatus = 211
      
    (**< System status, or system help reply*)
    let directoryStatus = 212
      
    (**< Directory status*)
    let fileStatus = 213
      
    (**< File status*)
    let helpMessage = 214
      
    (**< Help message*)
    let systemType = 215
      
    (**< NAME system type, where NAME is an official system name from the list in the Assigned Numbers document*)
    let serviceReady = 220
      
    (**< Service ready for new user*)
    let closingConnection = 221
      
    (**< Service closing control connection*)
    let dataConnectionOpened = 225
      
    (**< Data connection open, no transfer in progress*)
    let closingDataConnection = 226
      
    (**< Closing data connection, requested file action successful*)
    let enteringPassiveMode = 227
      
    (**< Entering passive mode*)
    let loggedIn = 230
      
    (**< User logged in, proceed. Logged out if appropriate*)
    let fileActionOk = 250
      
    (**< Requested file action ok*)
    let directoryOk = 257
      
    (**< PATHNAME created*)
    (* 3xx: the command has been accepted, but the requested action*)
    (* is dormant, pending receipt of further information*)
    let needPassword = 331
      
    (**< User name ok, need password*)
    let needAccountToLogIn = 332
      
    (**< Need account for login*)
    let needInformation = 350
      
    (**< Requested file action pending further information*)
    (* 4xx: the command was not accepted and the requested action did not take place,*)
    (* but the error condition is temporary and the action may be requested again*)
    let serviceUnavailable = 421
      
    (**< Service not available, closing control connection*)
    let dataConnectionUnavailable = 425
      
    (**< Can't open data connection*)
    let transferAborted = 426
      
    (**< Connection closed, transfer aborted*)
    let fileActionAborted = 450
      
    (**< Requested file action not taken*)
    let localError = 451
      
    (**< Requested action aborted, local error in processing*)
    let insufficientStorageSpace = 452
      
    (**< Requested action not taken; insufficient storage space in system, file unavailable*)
    (* 5xx: the command was not accepted and*)
    (* the requested action did not take place*)
    let commandUnknown = 500
      
    (**< Syntax error, command unrecognized*)
    let parametersUnknown = 501
      
    (**< Syntax error in parameters or arguments*)
    let commandNotImplemented = 502
      
    (**< Command not implemented*)
    let badCommandSequence = 503
      
    (**< Bad sequence of commands*)
    let parameterNotImplemented = 504
      
    (**< Command not implemented for that parameter*)
    let notLoggedIn = 530
      
    (**< Not logged in*)
    let needAccountToStore = 532
      
    (**< Need account for storing files*)
    let fileUnavailable = 550
      
    (**< Requested action not taken, file unavailable*)
    let pageTypeUnknown = 551
      
    (**< Requested action aborted, page type unknown*)
    let notEnoughMemory = 552
      
    (**< Requested file action aborted, exceeded storage allocation*)
    let filenameNotAllowed = 553
      (**< Requested action not taken, file name not allowed*)
      
    (* 10xx: SFML custom codes*)
    let invalidResponse = 1000
      (**< Response is not a valid FTP one*)
      
    let connectionFailed = 1001  
      (**< Connection with server failed*)
      
    let connectionClosed = 1002
      (**< Connection with server closed*)
      
    let invalidFile = 1003
      (**< Invalid file to upload / download*)
  end
    
  module Response =
  struct
    type t
      
    external destroy : t -> unit = "sf_Ftp_Response_destroy__impl"
        
    external default :
      ?code: Status.t ->
      ?msg: string -> unit -> t =
        "sf_Ftp_Response_default_constructor__impl"
          
    external get_status : t -> Status.t =
        "sf_Ftp_Response_getStatus__impl"
          
    external get_message : t -> string =
        "sf_Ftp_Response_getMessage__impl"
          
    external is_ok : t -> bool = "sf_Ftp_Response_isOk__impl"
        
  end
    
  class response t =
  object ((self : 'self))
    val t_response = (t : Response.t)
    method rep__sf_Ftp_Response = t_response
    method destroy = Response.destroy t_response
    method get_status : Status.t = Response.get_status t_response
    method get_message : string = Response.get_message t_response
    method is_ok : bool = Response.is_ok t_response
  end
    
      
  module DirectoryResponse =
  struct
    type t
      
    external destroy : t -> unit =
        "sf_Ftp_DirectoryResponse_destroy__impl"
          
    external to_response : t -> Response.t =
        "upcast__sf_Ftp_Response_of_sf_Ftp_DirectoryResponse__impl"
          
    external default : response -> t =
        "sf_Ftp_DirectoryResponse_default_constructor__impl"
          
    external get_directory : t -> string =
        "sf_Ftp_DirectoryResponse_getDirectory__impl"
          
  end
    
  class directory_response t =
  object ((self : 'self))
    val t_directory_response =
      (t : DirectoryResponse.t)
    method rep__sf_Ftp_DirectoryResponse = t_directory_response
    method destroy = DirectoryResponse.destroy t_directory_response

    inherit response (DirectoryResponse.to_response t)

    method get_directory : string =
      DirectoryResponse.get_directory t_directory_response
  end
          
  module ListingResponse =
  struct
    type t
      
    external destroy : t -> unit = "sf_Ftp_ListingResponse_destroy__impl"
        
    external to_response : t -> Response.t =
        "upcast__sf_Ftp_Response_of_sf_Ftp_ListingResponse__impl"
          
    external default : response -> char list -> t =
        "sf_Ftp_ListingResponse_default_constructor__impl"
          
    external get_filenames : t -> (* ou char array ? *) string list =
        "sf_Ftp_ListingResponse_getFilenames__impl"
          
  end
    
  class listing_response t =
  object ((self : 'self))
    val t_listing_response = (t : ListingResponse.t)
    method rep__sf_Ftp_ListingResponse = t_listing_response
    method destroy = ListingResponse.destroy t_listing_response
    inherit response (ListingResponse.to_response t)
    method get_filenames : string list =
      ListingResponse.get_filenames t_listing_response
  end
    
      
  module Ftp =
  struct
    type t
      
    external destroy : t -> unit = "sf_Ftp_destroy__impl"
        
    external default : (* ou string array ? *) unit -> t =
        "sf_Ftp_default_constructor__impl"
          
    external connect :
      t ->
      ?port: int ->
      ?timeout: OcsfmlSystem.Time.t -> ip_address -> response =
        "sf_Ftp_connect__impl"
          
    external disconnect : t -> response = "sf_Ftp_disconnect__impl"
        
    external login : t -> ?log: (string * string) -> unit -> response =
        "sf_Ftp_login__impl"
          
    external keep_alive : t -> response = "sf_Ftp_keepAlive__impl"
        
    external get_working_directory : t -> directory_response =
        "sf_Ftp_getWorkingDirectory__impl"
          
    external get_directory_listing :
      t -> ?dir: string -> unit -> listing_response =
        "sf_Ftp_getDirectoryListing__impl"
          
    external change_directory : t -> string -> response =
        "sf_Ftp_changeDirectory__impl"
          
    external parent_directory : t -> response =
        "sf_Ftp_parentDirectory__impl"
          
    external create_directory : t -> string -> response =
        "sf_Ftp_createDirectory__impl"
          
    external delete_directory : t -> string -> response =
        "sf_Ftp_deleteDirectory__impl"
          
    external rename_file : t -> string -> string -> response =
        "sf_Ftp_renameFile__impl"
          
    external delete_file : t -> string -> response =
        "sf_Ftp_deleteFile__impl"
          
    external download :
      t -> ?mode: transfer_mode -> string -> string -> response =
        "sf_Ftp_download__impl"
          
    external upload :
      t -> ?mode: transfer_mode -> string -> string -> response =
        "sf_Ftp_upload__impl"
          
  end
    
  class ftp t =
  object ((self : 'self))
    val t_ftp = (t : Ftp.t)
    method rep__sf_Ftp = t_ftp
    method destroy = Ftp.destroy t_ftp
    method connect :
      ?port: int ->
      ?timeout: OcsfmlSystem.Time.t -> ip_address -> response =
      fun ?port ?timeout p1 -> Ftp.connect t_ftp ?port ?timeout p1
    method disconnect : response = Ftp.disconnect t_ftp
    method login : ?log: (string * string) -> unit -> response =
      fun ?log p1 -> Ftp.login t_ftp ?log p1
    method keep_alive : response = Ftp.keep_alive t_ftp
    method get_working_directory : directory_response =
      Ftp.get_working_directory t_ftp
    method get_directory_listing :
      ?dir: string -> unit -> listing_response =
      fun ?dir p1 -> Ftp.get_directory_listing t_ftp ?dir p1
    method change_directory : string -> response =
      fun p1 -> Ftp.change_directory t_ftp p1
    method parent_directory : response = Ftp.parent_directory t_ftp
    method create_directory : string -> response =
      fun p1 -> Ftp.create_directory t_ftp p1
    method delete_directory : string -> response =
      fun p1 -> Ftp.delete_directory t_ftp p1
    method rename_file : string -> string -> response =
      fun p1 p2 -> Ftp.rename_file t_ftp p1 p2
    method delete_file : string -> response =
      fun p1 -> Ftp.delete_file t_ftp p1
    method download :
      ?mode: transfer_mode -> string -> string -> response =
      fun ?mode p1 p2 -> Ftp.download t_ftp ?mode p1 p2
    method upload :
      ?mode: transfer_mode -> string -> string -> response =
      fun ?mode p1 p2 -> Ftp.upload t_ftp ?mode p1 p2
  end
    
end
  
module HTTP =
struct
  type request_method = | Get | Post | Head
      
  module Status =
  struct
    type t = int
        
    (* 2xx: success*)
    let ok = 200
      
    (**< Most common code returned when operation was successful*)
    let created = 201
      
    (**< The resource has successfully been created*)
    let accepted = 202
      
    (**< The request has been accepted, but will be processed later by the server*)
    let noContent = 204
      
    (**< The server didn't send any data in return*)
    let resetContent = 205
      
    (**< The server informs the client that it should clear the view (form) that caused the request to be sent*)
    let partialContent = 206
      
    (**< The server has sent a part of the resource, as a response to a partial GET request*)
    (* 3xx: redirection*)
    let multipleChoices = 300
      
    (**< The requested page can be accessed from several locations*)
    let movedPermanently = 301
      
    (**< The requested page has permanently moved to a new location*)
    let movedTemporarily = 302
      
    (**< The requested page has temporarily moved to a new location*)
    let notModified = 304
      
    (**< For conditionnal requests, means the requested page hasn't changed and doesn't need to be refreshed*)
    (* 4xx: client error*)
    let badRequest = 400
      
    (**< The server couldn't understand the request (syntax error)*)
    let unauthorized = 401
      
    (**< The requested page needs an authentification to be accessed*)
    let forbidden = 403
      
    (**< The requested page cannot be accessed at all, even with authentification*)
    let notFound = 404
      
    (**< The requested page doesn't exist*)
    let rangeNotSatisfiable = 407
      
    (**< The server can't satisfy the partial GET request (with a "Range" header field)*)
    (* 5xx: server error*)
    let internalServerError = 500
      
    (**< The server encountered an unexpected error*)
    let notImplemented = 501
      
    (**< The server doesn't implement a requested feature*)
    let badGateway = 502
      
    (**< The gateway server has received an error from the source server*)
    let serviceNotAvailable = 503
      
    (**< The server is temporarily unavailable (overloaded, in maintenance ...)*)
    let gatewayTimeout = 504
      
    (**< The gateway server couldn't receive a response from the source server*)
    let versionNotSupported = 505
      
    (**< The server doesn't support the requested HTTP version*)
    (* 10xx: SFML custom codes*)
    let invalidResponse = 1000
      
    (**< Response is not a valid HTTP one*)
    let connectionFailed = 1001
      
  end
    
  module Request =
  struct
    type t
      
    external destroy : t -> unit = "sf_Http_Request_destroy__impl"
        
    external default :
      (**< Connection with server failed*) ?uri: string ->
      ?meth: request_method -> ?body: string -> unit -> t =
        "sf_Http_Request_default_constructor__impl"
          
    external set_field : t -> string -> string -> unit =
        "sf_Http_Request_setField__impl"
          
    external set_method : t -> request_method -> unit =
        "sf_Http_Request_setMethod__impl"
          
    external set_uri : t -> string -> unit =
        "sf_Http_Request_setUri__impl"
          
    external set_http_version : t -> int -> int -> unit =
        "sf_Http_Request_setHttpVersion__impl"
          
    external set_body : t -> string -> unit =
        "sf_Http_Request_setBody__impl"
          
  end
    
  class request t =
  object ((self : 'self))
    val t_request = (t : Request.t)
    method rep__sf_Http_Request = t_request
    method destroy = Request.destroy t_request
    method set_field : string -> string -> unit =
      fun p1 p2 -> Request.set_field t_request p1 p2
    method set_method : request_method -> unit =
      fun p1 -> Request.set_method t_request p1
    method set_uri : string -> unit =
      fun p1 -> Request.set_uri t_request p1
    method set_http_version : int -> int -> unit =
      fun p1 p2 -> Request.set_http_version t_request p1 p2
    method set_body : string -> unit =
      fun p1 -> Request.set_body t_request p1
  end
    
      
  module Response =
  struct
    type t
      
    external destroy : t -> unit = "sf_Http_Response_destroy__impl"
        
    external default : unit -> t =
        "sf_Http_Response_default_constructor__impl"
          
    external get_field : t -> string -> string =
        "sf_Http_Response_getField__impl"
          
    external get_status : t -> Status.t =
        "sf_Http_Response_getStatus__impl"
          
    external get_major_http_version : t -> int =
        "sf_Http_Response_getMajorHttpVersion__impl"
          
    external get_minor_http_version : t -> int =
        "sf_Http_Response_getMinorHttpVersion__impl"
          
    external get_body : t -> string = "sf_Http_Response_getBody__impl"
        
  end
    
  class response t =
  object ((self : 'self))
    val t_response = (t : Response.t)
    method rep__sf_Http_Response = t_response
    method destroy = Response.destroy t_response
    method get_field : string -> string =
      fun p1 -> Response.get_field t_response p1
    method get_status : Status.t = Response.get_status t_response
    method get_major_http_version : int =
      Response.get_major_http_version t_response
    method get_minor_http_version : int =
      Response.get_minor_http_version t_response
    method get_body : string = Response.get_body t_response
  end
    
      
  module Http =
  struct
    type t
      
    external destroy : t -> unit = "sf_Http_destroy__impl"
        
    external default : unit -> t = "sf_Http_default_constructor__impl"
        
    external from_host : string -> t = "sf_Http_host_constructor__impl"
        
    external from_host_and_port : string -> int -> t =
        "sf_Http_host_and_port_constructor__impl"
          
    external set_host : t -> ?port: int -> string -> unit =
        "sf_Http_setHost__impl"
          
    external send_request :
      t -> ?timeout: OcsfmlSystem.Time.t -> request -> response =
        "sf_Http_sendRequest__impl"
          
  end
    
  class http t =
  object ((self : 'self))
    val t_http = (t : Http.t)
    method rep__sf_Http = t_http
    method destroy = Http.destroy t_http
    method set_host : ?port: int -> string -> unit =
      fun ?port p1 -> Http.set_host t_http ?port p1
    method send_request :
      ?timeout: OcsfmlSystem.Time.t -> request -> response =
      fun ?timeout p1 -> Http.send_request t_http ?timeout p1
  end
    
end
  
module Packet =
struct
  type t
    
  external destroy : t -> unit = "sf_Packet_destroy__impl"
      
  external default : unit -> t = "sf_Packet_default_constructor__impl"
      
  external append : t -> OcsfmlSystem.raw_data_type -> unit =
      "sf_Packet_append__impl"
	
  external clear : t -> unit = "sf_Packet_clear__impl"
      
  external get_data : t -> OcsfmlSystem.raw_data_type =
      "sf_Packet_getData__impl"
	
  external get_data_size : t -> int = "sf_Packet_getDataSize__impl"
      
  external end_of_packet : t -> bool = "sf_Packet_endOfPacket__impl"
      
  external is_valid : t -> bool = "sf_Packet_isValid__impl"
      
  external read_bool : t -> bool = "sf_Packet_readBool__impl"
      
  external read_int8 : t -> int = "sf_Packet_readInt8__impl"
      
  external read_uint8 : t -> int = "sf_Packet_readUint8__impl"
      
  external read_int16 : t -> int = "sf_Packet_readInt16__impl"
      
  external read_uint16 : t -> int = "sf_Packet_readUint16__impl"
      
  external read_int32 : t -> int = "sf_Packet_readInt32__impl"
      
  external read_uint32 : t -> int = "sf_Packet_readUint32__impl"
      
  external read_float : t -> float = "sf_Packet_readFloat__impl"
      
  external read_string : t -> string = "sf_Packet_readString__impl"
      
  external write_bool : t -> bool -> unit = "sf_Packet_writeBool__impl"
      
  external write_int8 : t -> int -> unit = "sf_Packet_writeInt8__impl"
      
  external write_uint8 : t -> int -> unit = "sf_Packet_writeUint8__impl"
      
  external write_int16 : t -> int -> unit = "sf_Packet_writeInt16__impl"
      
  external write_uint16 : t -> int -> unit = "sf_Packet_writeUint16__impl"
      
  external write_int32 : t -> int -> unit = "sf_Packet_writeInt32__impl"
      
  external write_uint32 : t -> int -> unit = "sf_Packet_writeUint32__impl"
      
  external write_float : t -> float -> unit = "sf_Packet_writeFloat__impl"
      
  external write_string : t -> string -> unit =
      "sf_Packet_writeString__impl"
	
end
  
class packet_base t =
object ((self : 'self))
  val t_packet_base = (t : Packet.t)
  method rep__sf_Packet = t_packet_base
  method destroy = Packet.destroy t_packet_base
  method append : OcsfmlSystem.raw_data_type -> unit =
    fun p1 -> Packet.append t_packet_base p1
  method clear : unit = Packet.clear t_packet_base
  method get_data : OcsfmlSystem.raw_data_type =
    Packet.get_data t_packet_base
  method get_data_size : int = Packet.get_data_size t_packet_base
  method end_of_packet : bool = Packet.end_of_packet t_packet_base
  method is_valid : bool = Packet.is_valid t_packet_base
  method read_bool : bool = Packet.read_bool t_packet_base
  method read_int8 : int = Packet.read_int8 t_packet_base
  method read_uint8 : int = Packet.read_uint8 t_packet_base
  method read_int16 : int = Packet.read_int16 t_packet_base
  method read_uint16 : int = Packet.read_uint16 t_packet_base
  method read_int32 : int = Packet.read_int32 t_packet_base
  method read_uint32 : int = Packet.read_uint32 t_packet_base
  method read_float : float = Packet.read_float t_packet_base
  method read_string : string = Packet.read_string t_packet_base
  method write_bool : bool -> unit =
    fun p1 -> Packet.write_bool t_packet_base p1
  method write_int8 : int -> unit =
    fun p1 -> Packet.write_int8 t_packet_base p1
  method write_uint8 : int -> unit =
    fun p1 -> Packet.write_uint8 t_packet_base p1
  method write_int16 : int -> unit =
    fun p1 -> Packet.write_int16 t_packet_base p1
  method write_uint16 : int -> unit =
    fun p1 -> Packet.write_uint16 t_packet_base p1
  method write_int32 : int -> unit =
    fun p1 -> Packet.write_int32 t_packet_base p1
  method write_uint32 : int -> unit =
    fun p1 -> Packet.write_uint32 t_packet_base p1
  method write_float : float -> unit =
    fun p1 -> Packet.write_float t_packet_base p1
  method write_string : string -> unit =
    fun p1 -> Packet.write_string t_packet_base p1
end
  
    
class packet_bis () = 
  let t = Packet.default () 
  in packet_base t
       
class packet = packet_bis ()
  
(* pour avoir un feeling plus SFMLisant*)
type read_val =
    [
    | `Int8 of int ref
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
    | `Int8 of int
    | `UInt8 of int
    | `Int16 of int
    | `UInt16 of int
    | `Int32 of int (* int32 ? *)
    | `UInt32 of int (* int32 ? *)
    | `Float of float
    | `Bool of bool
    | `String of string
    ]

let ( >> ) (p : #packet) =
  function
    | `Int8 i -> (i := p#read_int8; p)
    | `UInt8 i -> (i := p#read_uint8; p)
    | `Int16 i -> (i := p#read_int16; p)
    | `UInt16 i -> (i := p#read_uint16; p)
    | `Int32 i -> (i := p#read_int32; p)
    | `UInt32 i -> (i := p#read_uint32; p)
    | `Float f -> (f := p#read_float; p)
    | `Bool b -> (b := p#read_bool; p)
    | `String s -> (s := p#read_string; p)
	
let ( << ) (p : #packet) =
  function
    | `Int8 i -> (p#write_int8 i; p)
    | `UInt8 i -> (p#write_uint8 i; p)
    | `Int16 i -> (p#write_int16 i; p)
    | `UInt16 i -> (p#write_uint16 i; p)
    | `Int32 i -> (p#write_int32 i; p)
    | `UInt32 i -> (p#write_uint32 i; p)
    | `Float f -> (p#write_float f; p)
    | `Bool b -> (p#write_bool b; p)
    | `String s -> (p#write_string s; p)
	
type socket_status = | Done | NotReady | Disconnected | Error

module Socket =
struct
  type t
    
  external destroy : t -> unit = "sf_Socket_destroy__impl"
      
  external set_blocking : t -> bool -> unit = "sf_Socket_setBlocking__impl"
      
  external is_blocking : t -> bool = "sf_Socket_isBlocking__impl"
      
end
  
class socket t =
object ((self : 'self))
  val t_socket = (t : Socket.t)
  method rep__sf_Socket = t_socket
  method destroy = Socket.destroy t_socket
  method set_blocking : bool -> unit =
    fun p1 -> Socket.set_blocking t_socket p1
  method is_blocking : bool = Socket.is_blocking t_socket
end
      
module SocketSelector =
struct
  type t
    
  class type socket_selector_class_type =
  object ('self)
    val t_socket_selector : t
    method rep__sf_SocketSelector : t
    method destroy : unit
    method add : (* constructor copy : 'self = "copy_constructor" *)
      'a. (#socket as 'a) -> unit
    method remove : 'a. (#socket as 'a) -> unit
    method clear : unit
    method wait : ?timeout: OcsfmlSystem.Time.t -> unit -> bool
    method is_ready : 'a. (#socket as 'a) -> bool
    method set : 'self -> 'self
  end
    
  external destroy : t -> unit = "sf_SocketSelector_destroy__impl"
	    
  external default : unit -> t =
	    "sf_SocketSelector_default_constructor__impl"
	      
  external add : t -> (#socket as 'a) -> unit =
	    "sf_SocketSelector_add__impl"
	      
  external remove : t -> (#socket as 'a) -> unit =
	    "sf_SocketSelector_remove__impl"
	      
  external clear : t -> unit = "sf_SocketSelector_clear__impl"
	    
  external wait : t -> ?timeout: OcsfmlSystem.Time.t -> unit -> bool =
	    "sf_SocketSelector_wait__impl"
	      
  external is_ready : t -> (#socket as 'a) -> bool =
	    "sf_SocketSelector_isReady__impl"
	      
  external affect : t -> t -> t = "sf_SocketSelector_affect__impl"
	    
end
  
class socket_selector_base t =
object ((_: 'self))
  val t_socket_selector = (t : SocketSelector.t)
  method rep__sf_SocketSelector = t_socket_selector
  method destroy = SocketSelector.destroy t_socket_selector
  method add : 'a. (#socket as 'a) -> unit =
    fun p1 -> SocketSelector.add t_socket_selector p1
  method remove : 'a. (#socket as 'a) -> unit =
    fun p1 -> SocketSelector.remove t_socket_selector p1
  method clear : unit = SocketSelector.clear t_socket_selector
  method wait : ?timeout: OcsfmlSystem.Time.t -> unit -> bool =
    fun ?timeout p1 -> SocketSelector.wait t_socket_selector ?timeout p1
  method is_ready : 'a. (#socket as 'a) -> bool =
    fun p1 -> SocketSelector.is_ready t_socket_selector p1
  method affect : 'self -> unit =
    fun p1 -> ignore (SocketSelector.affect t_socket_selector p1#rep__sf_SocketSelector)
end

class socket_selector_bis () =
  let t = SocketSelector.default () in
  socket_selector_base t

class socket_selector = socket_selector_bis ()

module Port = 
struct 
  type t = int
  let from_int port = port
end
    
module TcpSocket =
struct
  type t
    
  external destroy : t -> unit = "sf_TcpSocket_destroy__impl"
      
  external to_socket : t -> Socket.t =
      "upcast__sf_Socket_of_sf_TcpSocket__impl"
	
  external default : unit -> t = "sf_TcpSocket_default_constructor__impl"
      
  external get_local_port : t -> Port.t = "sf_TcpSocket_getLocalPort__impl"
      
  external get_remote_address : t -> ip_address =
      "sf_TcpSocket_getRemoteAddress__impl"
	
  external get_remote_port : t -> Port.t = "sf_TcpSocket_getRemotePort__impl"
      
  external connect :
    t -> ?timeout: OcsfmlSystem.Time.t -> ip_address -> Port.t -> socket_status =
      "sf_TcpSocket_connect__impl"
	
  external disconnect : t -> unit = "sf_TcpSocket_disconnect__impl"
      
  external send_packet : t -> (#packet as 'a) -> socket_status =
      "sf_TcpSocket_sendPacket__impl"
	
  external receive_packet : t -> (#packet as 'a) -> socket_status =
      "sf_TcpSocket_receivePacket__impl"
	
  external send_data : t -> OcsfmlSystem.raw_data_type -> socket_status =
      "sf_TcpSocket_sendData__impl"
	
  external receive_data :
    t -> OcsfmlSystem.raw_data_type -> (socket_status * int) =
      "sf_TcpSocket_receiveData__impl"

  external send_string : t -> string -> socket_status =
      "sf_TcpSocket_sendString__impl"
	
  external receive_string : t -> string -> (socket_status * int) =
      "sf_TcpSocket_receiveString__impl"
	
end
  
class tcp_socket_base t =
object ((self : 'self))
  val t_tcp_socket_base = (t : TcpSocket.t)

  method rep__sf_TcpSocket = t_tcp_socket_base

  method destroy = TcpSocket.destroy t_tcp_socket_base

  inherit socket (TcpSocket.to_socket t)

  method get_local_port : Port.t = 
    TcpSocket.get_local_port t_tcp_socket_base

  method get_remote_address : ip_address =
    TcpSocket.get_remote_address t_tcp_socket_base

  method get_remote_port : Port.t =
    TcpSocket.get_remote_port t_tcp_socket_base

  method connect :
    ?timeout: OcsfmlSystem.Time.t -> ip_address -> Port.t -> socket_status =
    fun ?timeout p1 p2 ->
      TcpSocket.connect t_tcp_socket_base ?timeout p1 p2

  method disconnect : unit = TcpSocket.disconnect t_tcp_socket_base

  method send_packet : 'a. (#packet as 'a) -> socket_status =
    fun p1 -> TcpSocket.send_packet t_tcp_socket_base p1

  method receive_packet : 'a. (#packet as 'a) -> socket_status =
    fun p1 -> TcpSocket.receive_packet t_tcp_socket_base p1

  method send_data : OcsfmlSystem.raw_data_type -> socket_status =
    fun p1 -> TcpSocket.send_data t_tcp_socket_base p1

  method receive_data : OcsfmlSystem.raw_data_type -> (socket_status * int) =
    fun p1 -> TcpSocket.receive_data t_tcp_socket_base p1

  method send_string : string -> socket_status =
    fun p1 -> TcpSocket.send_string t_tcp_socket_base p1

  method receive_string : string -> (socket_status * int) =
    fun p1 -> TcpSocket.receive_string t_tcp_socket_base p1

end
      
class tcp_socket_bis () = let t = TcpSocket.default () in tcp_socket_base t
							    
class tcp_socket = tcp_socket_bis ()
  
module TcpListener =
struct
  type t
    
  external destroy : t -> unit = "sf_TcpListener_destroy__impl"
      
  external to_socket : t -> Socket.t =
      "upcast__sf_Socket_of_sf_TcpListener__impl"
	
  external default : unit -> t = "sf_TcpListener_default_constructor__impl"
      
  external get_local_port : t -> Port.t = "sf_TcpListener_getLocalPort__impl"
      
  external listen : t -> Port.t -> socket_status =
      "sf_TcpListener_listen__impl"
	
  external close : t -> unit = "sf_TcpListener_close__impl"
      
  external accept : t -> tcp_socket -> socket_status =
      "sf_TcpListener_accept__impl"
	
end
  
class tcp_listener_base t =
object ((self : 'self))
  val t_tcp_listener_base = (t : TcpListener.t)
  method rep__sf_TcpListener = t_tcp_listener_base
  method destroy = TcpListener.destroy t_tcp_listener_base
  inherit socket (TcpListener.to_socket t)
  method get_local_port : Port.t =
    TcpListener.get_local_port t_tcp_listener_base
  method listen : Port.t -> socket_status =
    fun p1 -> TcpListener.listen t_tcp_listener_base p1
  method close : unit = TcpListener.close t_tcp_listener_base
  method accept : tcp_socket -> socket_status =
    fun p1 -> TcpListener.accept t_tcp_listener_base p1
end
  
    
class tcp_listener_bis () =
  let t = TcpListener.default ()
  in tcp_listener_base t
       
class tcp_listener = tcp_listener_bis ()
  
let max_datagram_size = 65507
    
module UdpSocket =
struct
  type t
    
  external destroy : t -> unit = "sf_UdpSocket_destroy__impl"
      
  external to_socket : t -> Socket.t =
      "upcast__sf_Socket_of_sf_UdpSocket__impl"
	
  external default : unit -> t = "sf_UdpSocket_default_constructor__impl"
      
  external bind : t -> Port.t -> socket_status = "sf_UdpSocket_bind__impl"
      
  external unbind : t -> unit = "sf_UdpSocket_unbind__impl"
      
  external get_local_port : t -> Port.t = "sf_UdpSocket_getLocalPort__impl"

  external send_packet :
    t -> (#packet as 'a) -> ip_address -> Port.t -> socket_status =
      "sf_UdpSocket_sendPacket__impl"
	
  external receive_packet :
    t -> (#packet as 'a) -> ip_address -> (socket_status * Port.t) =
      "sf_UdpSocket_receivePacket__impl"
	
  external send_data : t -> OcsfmlSystem.raw_data_type -> ip_address -> Port.t -> socket_status =
      "sf_UdpSocket_sendData__impl"
	
  external receive_data : t -> OcsfmlSystem.raw_data_type -> ip_address -> (socket_status * int * Port.t) =
      "sf_UdpSocket_receiveData__impl"

  external send_string : t -> string -> ip_address -> Port.t -> socket_status =
      "sf_UdpSocket_sendString__impl"
	
  external receive_string : t -> string -> ip_address -> (socket_status * int * Port.t) =
      "sf_UdpSocket_receiveString__impl"

	
end
  
class udp_socket_base t =
object ((self : 'self))
  val t_udp_socket_base = (t : UdpSocket.t)
  method rep__sf_UdpSocket = t_udp_socket_base
  method destroy = UdpSocket.destroy t_udp_socket_base
  inherit socket (UdpSocket.to_socket t)

  method bind : Port.t -> socket_status =
    fun p1 -> UdpSocket.bind t_udp_socket_base p1

  method unbind : unit = 
    UdpSocket.unbind t_udp_socket_base

  method get_local_port : Port.t = 
    UdpSocket.get_local_port t_udp_socket_base

  method send_packet : 'a. (#packet as 'a) -> ip_address -> Port.t -> socket_status =
    fun p1 p2 p3 -> UdpSocket.send_packet t_udp_socket_base p1 p2 p3


  method receive_packet : 'a. (#packet as 'a) -> ip_address -> (socket_status * Port.t) =
    fun p1 p2 -> UdpSocket.receive_packet t_udp_socket_base p1 p2

  method send_data : OcsfmlSystem.raw_data_type -> ip_address -> Port.t -> socket_status =
    fun p1 p2 p3 -> UdpSocket.send_data t_udp_socket_base p1 p2 p3

  method receive_data : OcsfmlSystem.raw_data_type -> ip_address -> (socket_status * int * Port.t) =
    fun p1 p2 -> UdpSocket.receive_data t_udp_socket_base p1 p2

  method send_string : string -> ip_address -> Port.t -> socket_status =
    fun p1 p2 p3 -> UdpSocket.send_string t_udp_socket_base p1 p2 p3

  method receive_string: string -> ip_address -> (socket_status * int * Port.t) =
    fun p1 p2 -> UdpSocket.receive_string t_udp_socket_base p1 p2

end
      
class udp_socket_bis () = let t = UdpSocket.default () in udp_socket_base t
							    
class udp_socket = udp_socket_bis ()

