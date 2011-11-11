

external class ip_address (IPAddress) : "sf_IpAddress" =
object
  constructor default : unit = "default_constructor"
  constructor from_string : string = "string_constructor"
  constructor from_bytes : int -> int -> int -> int = "bytes_constructor"
  constructor from_int : int = "integer_constructor"
  external method to_string : unit -> string = "ToString"
  external method to_integer : unit -> int = "ToInteger"
end

external cpp get_local_address : unit -> ip_address = "sf_IpAddress_GetLocalAddress"
external cpp get_public_address : ?timeout:int -> unit -> ip_address = "sf_IpAddress_GetPublicAddress"

module FTP =
struct

  type transfer_mode = Binary | Ascii | Ebcdic


  type status = 
      RestartMarkerReply 
    | ServiceReadySoon 
    | DataConnectionAlreadyOpened 
    | OpeningDataConnection
    | Ok
    | PointlessCommand
    | SystemStatus
    | DirectoryStatus
    | FileStatus
    | HelpMessage
    | SystemType
    | ServiceReady
    | ClosingConnection
    | DataConnectionOpened
    | ClosingDataConnection
    | EnteringPassiveMode
    | LoggedIn
    | FileActionOk
    | DirectoryOk
    | NeedPassword
    | NeedAccountToLogIn
    | NeedInformation
    | ServiceUnavailable
    | DataConnectionUnavailable
    | TransferAborted
    | FileActionAborted
    | LocalError
    | InsufficientStorageSpace
    | CommandUnknown
    | ParametersUnknown
    | CommandNotImplemented
    | BadCommandSequence
    | ParameterNotImplemented
    | NotLoggedIn
    | NeedAccountToStore
    | FileUnavailable
    | PageTypeUnknown
    | NotEnoughMemory
    | FilenameNotAllowed
    | InvalidResponse
    | ConnectionFailed
    | ConnectionClosed
    | InvalidFile
	
	
  external class response : "sf_Ftp_Response" =
  object
    constructor default : ?code:status -> ?msg:string -> unit = "default_constructor"
    external method get_status : unit -> status = "GetStatus" 
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

  type status =
      Ok
    | Created
    | Accepted
    | NoContent
    | ResetContent
    | PartialContent
    | MultipleChoices
    | MovedPermanently
    | MovedTemporarily
    | NotModified
    | BadRequest
    | Unauthorized
    | Forbidden
    | NotFound
    | RangeNotSatisfiable
    | InternalServerError
    | NotImplemented
    | BadGateway
    | ServiceNotAvailable
    | GatewayTimeout
    | VersionNotSupported
    | InvalidResponse
    | ConnectionFailed


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
    external method get_status : unit -> status = "GetStatus"
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


external class packet : "sf_Packet" =
object
  constructor default : unit = "default_constructor"
  external method clear : unit -> unit = "Clear"
  external method get_data_size : unit -> int = "GetDataSize"
  external method end_of_packet : unit -> bool = "EndOfPacket"
  external method is_valid : unit -> bool = "IsValid"
  external method read_bool : unit -> bool = "ReadBool"
  external method read_int8 : unit -> int = "ReadInt8"
  external method read_uint8 : unit -> int = "ReadUInt8"
  external method read_int16 : unit -> int = "ReadInt16"
  external method read_uint16 : unit -> int = "ReadUInt16"
  external method read_int32 : unit -> int = "ReadInt32"
  external method read_uint32 : unit -> int = "ReadUInt32"
  external method read_float : unit -> float = "ReadFloat"
  external method read_string : unit -> string = "ReadString"
  external method write_bool : bool -> unit = "WriteBool"
  external method write_int8 : int -> unit = "WriteInt8"
  external method write_uint8 : int -> unit = "WriteInt8"
  external method write_int16 : int -> unit = "WriteInt16"
  external method write_uint16 : int -> unit = "WriteUInt16"
  external method write_int32 : int -> unit = "WriteInt32"
  external method write_uint32 : int -> unit = "WriteUInt32"
  external method write_float : float -> unit = "WriteFloat"
  external method write_string : string -> unit = "WriteString"
end

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

let (>>) p = function
    `Int8 i -> i := p#read_int8 () ; p
  | `UInt8 i -> i := p#read_uint8 () ; p
  | `Int16 i -> i := p#read_int16 () ; p
  | `UInt16 i -> i := p#read_uint16 () ; p
  | `Int32 i -> i := p#read_int32 () ; p
  | `UInt32 i -> i := p#read_uint32 () ; p
  | `Float f -> f := p#read_float () ; p
  | `Bool b -> b := p#read_bool () ; p
  | `String s -> s := p#read_string () ; p

let (<<) p = function
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

external class tcp_socket (TcpSocket) : "sf_TcpSocket" =
object
  external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method get_local_port : unit -> int = "GetLocalPort"
  external method get_remote_port : unit -> ip_address = "GetRemotePort"
  external method connect : ?timeout:int -> ip_address -> int -> socket_status = "Connect"
  external method disconnect : unit -> unit = "Disconnect"
  external method send_packet : packet -> socket_status = "SendPacket"
  external method receive_packet : packet -> socket_status = "ReceivePacket"
end

external class tcp_listener : "sf_TcpListener" =
object
  external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method get_local_port : unit -> int = "GetLocalPort"
  external method listen : int -> socket_status = "Listen"
  external method close : unit -> unit = "Close"
  external method accept : tcp_socket -> socket_status = "Accept"
end

let max_datagram_size = 65507

external class udp_socket (UdpSocket) : "sf_UdpSocket" =
object
external inherit socket : "sf_Socket"
  constructor default : unit = "default_constructor"
  external method bind : int -> socket_status = "Bind"
  external method unbind : unit -> unit = "Unbind"	     
  external method send_packet : packet -> socket_status = "SendPacket"
  external method receive_packet : packet -> socket_status = "ReceivePacket"
end
