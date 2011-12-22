module IPAddress :
  sig
    type t
    external destroy : t -> unit = "sf_IpAddress_destroy__impl"
    external default : unit -> t = "sf_IpAddress_default_constructor__impl"
    external from_string : string -> t
      = "sf_IpAddress_string_constructor__impl"
    external from_bytes : int -> int -> int -> int -> t
      = "sf_IpAddress_bytes_constructor__impl"
    external from_int : int -> t = "sf_IpAddress_integer_constructor__impl"
    external to_string : t -> string = "sf_IpAddress_ToString__impl"
    external to_integer : t -> int = "sf_IpAddress_ToInteger__impl"
  end
class ip_address :
  IPAddress.t ->
  object
    val t_ip_address : IPAddress.t
    method destroy : unit -> unit
    method rep__sf_IpAddress : IPAddress.t
    method to_integer : unit -> int
    method to_string : unit -> string
  end
external get_local_address : unit -> ip_address
  = "sf_IpAddress_GetLocalAddress__impl"
external get_public_address : ?timeout:int -> unit -> ip_address
  = "sf_IpAddress_GetPublicAddress__impl"
module FTP :
  sig
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
    module Response :
      sig
        type t
        external destroy : t -> unit = "sf_Ftp_Response_destroy__impl"
        external default : ?code:status -> ?msg:string -> unit -> t
          = "sf_Ftp_Response_default_constructor__impl"
        external get_status : t -> status = "sf_Ftp_Response_GetStatus__impl"
        external get_message : t -> string
          = "sf_Ftp_Response_GetMessage__impl"
      end
    class response :
      Response.t ->
      object
        val t_response : Response.t
        method destroy : unit -> unit
        method get_message : unit -> string
        method get_status : unit -> status
        method rep__sf_Ftp_Response : Response.t
      end
    module DirectoryResponse :
      sig
        type t
        external destroy : t -> unit
          = "sf_Ftp_DirectoryResponse_destroy__impl"
        external to_response : t -> Response.t
          = "upcast__sf_Ftp_Response_of_sf_Ftp_DirectoryResponse__impl"
        external default : response -> t
          = "sf_Ftp_DirectoryResponse_default_constructor__impl"
        external get_directory : t -> string
          = "sf_Ftp_DirectoryResponse_GetDirectory__impl"
      end
    class directory_response :
      DirectoryResponse.t ->
      object
        val t_directory_response : DirectoryResponse.t
        val t_response : Response.t
        method destroy : unit -> unit
        method get_directory : unit -> string
        method get_message : unit -> string
        method get_status : unit -> status
        method rep__sf_Ftp_DirectoryResponse : DirectoryResponse.t
        method rep__sf_Ftp_Response : Response.t
      end
    module ListingResponse :
      sig
        type t
        external destroy : t -> unit = "sf_Ftp_ListingResponse_destroy__impl"
        external to_response : t -> Response.t
          = "upcast__sf_Ftp_Response_of_sf_Ftp_ListingResponse__impl"
        external default : response -> char list -> t
          = "sf_Ftp_ListingResponse_default_constructor__impl"
        external get_filenames : t -> string list
          = "sf_Ftp_ListingResponse_GetFilenames__impl"
      end
    class listing_response :
      ListingResponse.t ->
      object
        val t_listing_response : ListingResponse.t
        val t_response : Response.t
        method destroy : unit -> unit
        method get_filenames : unit -> string list
        method get_message : unit -> string
        method get_status : unit -> status
        method rep__sf_Ftp_ListingResponse : ListingResponse.t
        method rep__sf_Ftp_Response : Response.t
      end
    module Ftp :
      sig
        type t
        external destroy : t -> unit = "sf_Ftp_destroy__impl"
        external default : unit -> t = "sf_Ftp_default_constructor__impl"
        external connect :
          t -> ?port:int -> ?timeout:int -> ip_address -> response
          = "sf_Ftp_Connect__impl"
        external disconnect : t -> response = "sf_Ftp_Disconnect__impl"
        external login : t -> ?log:string * string -> unit -> response
          = "sf_Ftp_Login__impl"
        external keep_alive : t -> response = "sf_Ftp_KeepAlive__impl"
        external get_working_directory : t -> directory_response
          = "sf_Ftp_GetWorkingDirectory__impl"
        external get_directory_listing :
          t -> ?dir:string -> unit -> listing_response
          = "sf_Ftp_GetDirectoryListing__impl"
        external change_directory : t -> string -> response
          = "sf_Ftp_ChangeDirectory__impl"
        external parent_directory : t -> response
          = "sf_Ftp_ParentDirectory__impl"
        external create_directory : t -> string -> response
          = "sf_Ftp_CreateDirectory__impl"
        external delete_directory : t -> string -> response
          = "sf_Ftp_DeleteDirectory__impl"
        external rename_file : t -> string -> string -> response
          = "sf_Ftp_RenameFile__impl"
        external delete_file : t -> string -> response
          = "sf_Ftp_DeleteFile__impl"
        external download : t -> ?mode:transfer_mode -> string -> string
          = "sf_Ftp_Download__impl"
        external upload : t -> ?mode:transfer_mode -> string -> string
          = "sf_Ftp_Upload__impl"
      end
    class ftp :
      Ftp.t ->
      object
        val t_ftp : Ftp.t
        method change_directory : string -> response
        method connect : ?port:int -> ?timeout:int -> ip_address -> response
        method create_directory : string -> response
        method delete_directory : string -> response
        method delete_file : string -> response
        method destroy : unit -> unit
        method disconnect : unit -> response
        method download : ?mode:transfer_mode -> string -> string
        method get_directory_listing :
          ?dir:string -> unit -> listing_response
        method get_working_directory : unit -> directory_response
        method keep_alive : unit -> response
        method login : ?log:string * string -> unit -> response
        method parent_directory : unit -> response
        method rename_file : string -> string -> response
        method rep__sf_Ftp : Ftp.t
        method upload : ?mode:transfer_mode -> string -> string
      end
  end
module HTTP :
  sig
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
    module Request :
      sig
        type t
        external destroy : t -> unit = "sf_Http_Request_destroy__impl"
        external default :
          ?uri:string -> ?meth:request_method -> ?body:string -> unit -> t
          = "sf_Http_Request_default_constructor__impl"
        external set_field : t -> string -> string -> unit
          = "sf_Http_Request_SetField__impl"
        external set_method : t -> request_method -> unit
          = "sf_Http_Request_SetMethod__impl"
        external set_uri : t -> string -> unit
          = "sf_Http_Request_SetUri__impl"
        external set_http_version : t -> int -> int -> unit
          = "sf_Http_Request_SetHttpVersion__impl"
        external set_body : t -> string -> unit
          = "sf_Http_Request_SetBody__impl"
      end
    class request :
      Request.t ->
      object
        val t_request : Request.t
        method destroy : unit -> unit
        method rep__sf_Http_Request : Request.t
        method set_body : string -> unit
        method set_field : string -> string -> unit
        method set_http_version : int -> int -> unit
        method set_method : request_method -> unit
        method set_uri : string -> unit
      end
    module Response :
      sig
        type t
        external destroy : t -> unit = "sf_Http_Response_destroy__impl"
        external default : unit -> t
          = "sf_Http_Response_default_constructor__impl"
        external get_field : t -> string -> string
          = "sf_Http_Response_GetField__impl"
        external get_status : t -> status
          = "sf_Http_Response_GetStatus__impl"
        external get_major_http_version : t -> int
          = "sf_Http_Response_GetMajorHttpVersion__impl"
        external get_minor_http_version : t -> int
          = "sf_Http_Response_GetMinorHttpVersion__impl"
        external get_body : t -> string = "sf_Http_Response_GetBody__impl"
      end
    class response :
      Response.t ->
      object
        val t_response : Response.t
        method destroy : unit -> unit
        method get_body : unit -> string
        method get_field : string -> string
        method get_major_http_version : unit -> int
        method get_minor_http_version : unit -> int
        method get_status : unit -> status
        method rep__sf_Http_Response : Response.t
      end
    module Http :
      sig
        type t
        external destroy : t -> unit = "sf_Http_destroy__impl"
        external default : unit -> t = "sf_Http_default_constructor__impl"
        external from_host : string -> t = "sf_Http_host_constructor__impl"
        external from_host_and_port : string -> int -> t
          = "sf_Http_host_and_port_constructor__impl"
        external set_host : t -> ?port:int -> string -> unit
          = "sf_Http_SetHost__impl"
        external send_request : t -> ?timeout:int -> request -> response
          = "sf_Http_SendRequest__impl"
      end
    class http :
      Http.t ->
      object
        val t_http : Http.t
        method destroy : unit -> unit
        method rep__sf_Http : Http.t
        method send_request : ?timeout:int -> request -> response
        method set_host : ?port:int -> string -> unit
      end
  end
module Packet :
  sig
    type t
    external destroy : t -> unit = "sf_Packet_destroy__impl"
    external default : unit -> t = "sf_Packet_default_constructor__impl"
    external clear : t -> unit = "sf_Packet_Clear__impl"
    external get_data_size : t -> int = "sf_Packet_GetDataSize__impl"
    external end_of_packet : t -> bool = "sf_Packet_EndOfPacket__impl"
    external is_valid : t -> bool = "sf_Packet_IsValid__impl"
    external read_bool : t -> bool = "sf_Packet_ReadBool__impl"
    external read_int8 : t -> int = "sf_Packet_ReadInt8__impl"
    external read_uint8 : t -> int = "sf_Packet_ReadUInt8__impl"
    external read_int16 : t -> int = "sf_Packet_ReadInt16__impl"
    external read_uint16 : t -> int = "sf_Packet_ReadUInt16__impl"
    external read_int32 : t -> int = "sf_Packet_ReadInt32__impl"
    external read_uint32 : t -> int = "sf_Packet_ReadUInt32__impl"
    external read_float : t -> float = "sf_Packet_ReadFloat__impl"
    external read_string : t -> string = "sf_Packet_ReadString__impl"
    external write_bool : t -> bool -> unit = "sf_Packet_WriteBool__impl"
    external write_int8 : t -> int -> unit = "sf_Packet_WriteInt8__impl"
    external write_uint8 : t -> int -> unit = "sf_Packet_WriteInt8__impl"
    external write_int16 : t -> int -> unit = "sf_Packet_WriteInt16__impl"
    external write_uint16 : t -> int -> unit = "sf_Packet_WriteUInt16__impl"
    external write_int32 : t -> int -> unit = "sf_Packet_WriteInt32__impl"
    external write_uint32 : t -> int -> unit = "sf_Packet_WriteUInt32__impl"
    external write_float : t -> float -> unit = "sf_Packet_WriteFloat__impl"
    external write_string : t -> string -> unit
      = "sf_Packet_WriteString__impl"
  end
class packet :
  Packet.t ->
  object
    val t_packet : Packet.t
    method clear : unit -> unit
    method destroy : unit -> unit
    method end_of_packet : unit -> bool
    method get_data_size : unit -> int
    method is_valid : unit -> bool
    method read_bool : unit -> bool
    method read_float : unit -> float
    method read_int16 : unit -> int
    method read_int32 : unit -> int
    method read_int8 : unit -> int
    method read_string : unit -> string
    method read_uint16 : unit -> int
    method read_uint32 : unit -> int
    method read_uint8 : unit -> int
    method rep__sf_Packet : Packet.t
    method write_bool : bool -> unit
    method write_float : float -> unit
    method write_int16 : int -> unit
    method write_int32 : int -> unit
    method write_int8 : int -> unit
    method write_string : string -> unit
    method write_uint16 : int -> unit
    method write_uint32 : int -> unit
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
  (< read_bool : unit -> 'b; read_float : unit -> 'c;
     read_int16 : unit -> 'd; read_int32 : unit -> 'e;
     read_int8 : unit -> 'f; read_string : unit -> 'g;
     read_uint16 : unit -> 'h; read_uint32 : unit -> 'i;
     read_uint8 : unit -> 'j; .. >
   as 'a) ->
  [< `Bool of 'b ref
   | `Float of 'c ref
   | `Int16 of 'd ref
   | `Int32 of 'e ref
   | `Int8 of 'f ref
   | `String of 'g ref
   | `UInt16 of 'h ref
   | `UInt32 of 'i ref
   | `UInt8 of 'j ref ] ->
  'a
val ( << ) :
  (< write_bool : 'b -> 'c; write_float : 'd -> 'e; write_int16 : 'f -> 'g;
     write_int32 : 'h -> 'i; write_int8 : 'j -> 'k; write_string : 'l -> 'm;
     write_uint16 : 'n -> 'o; write_uint32 : 'p -> 'q;
     write_uint8 : 'r -> 's; .. >
   as 'a) ->
  [< `Bool of 'b
   | `Float of 'd
   | `Int16 of 'f
   | `Int32 of 'h
   | `Int8 of 'j
   | `String of 'l
   | `UInt16 of 'n
   | `UInt32 of 'p
   | `UInt8 of 'r ] ->
  'a
type socket_status = Done | NotReady | Disconnected | Error
module Socket :
  sig
    type t
    external destroy : t -> unit = "sf_Socket_destroy__impl"
    external set_blocking : t -> bool -> unit = "sf_Socket_SetBlocking__impl"
    external is_blocking : t -> bool = "sf_Socket_IsBlocking__impl"
  end
class socket :
  Socket.t ->
  object
    val t_socket : Socket.t
    method destroy : unit -> unit
    method is_blocking : unit -> bool
    method rep__sf_Socket : Socket.t
    method set_blocking : bool -> unit
  end
module SocketSelector :
  sig
    type t
    class type socket_selector_class_type =
      object ('a)
        val t_socket_selector : t
        method add : #socket -> unit
        method clear : unit -> unit
        method destroy : unit -> unit
        method is_ready : #socket -> bool
        method remove : #socket -> unit
        method rep__sf_SocketSelector : t
        method set : 'a -> 'a
        method wait : ?timeout:int -> unit -> unit
      end
    external destroy : t -> unit = "sf_SocketSelector_destroy__impl"
    external default : unit -> t
      = "sf_SocketSelector_default_constructor__impl"
    external add : t -> #socket -> unit = "sf_SocketSelector_Add__impl"
    external remove : t -> #socket -> unit = "sf_SocketSelector_Remove__impl"
    external clear : t -> unit = "sf_SocketSelector_Clear__impl"
    external wait : t -> ?timeout:int -> unit -> unit
      = "sf_SocketSelector_Wait__impl"
    external is_ready : t -> #socket -> bool
      = "sf_SocketSelector_IsReady__impl"
    external set : t -> 'a -> 'a = "sf_SocketSelector_Affect__impl"
  end
class socket_selector :
  SocketSelector.t ->
  object ('a)
    val t_socket_selector : SocketSelector.t
    method add : #socket -> unit
    method clear : unit -> unit
    method destroy : unit -> unit
    method is_ready : #socket -> bool
    method remove : #socket -> unit
    method rep__sf_SocketSelector : SocketSelector.t
    method set : 'a -> 'a
    method wait : ?timeout:int -> unit -> unit
  end
module TcpSocket :
  sig
    type t
    external destroy : t -> unit = "sf_TcpSocket_destroy__impl"
    external to_socket : t -> Socket.t
      = "upcast__sf_Socket_of_sf_TcpSocket__impl"
    external default : unit -> t = "sf_TcpSocket_default_constructor__impl"
    external get_local_port : t -> int = "sf_TcpSocket_GetLocalPort__impl"
    external get_remote_port : t -> ip_address
      = "sf_TcpSocket_GetRemotePort__impl"
    external connect :
      t -> ?timeout:int -> ip_address -> int -> socket_status
      = "sf_TcpSocket_Connect__impl"
    external disconnect : t -> unit = "sf_TcpSocket_Disconnect__impl"
    external send_packet : t -> packet -> socket_status
      = "sf_TcpSocket_SendPacket__impl"
    external receive_packet : t -> packet -> socket_status
      = "sf_TcpSocket_ReceivePacket__impl"
  end
class tcp_socket :
  TcpSocket.t ->
  object
    val t_socket : Socket.t
    val t_tcp_socket : TcpSocket.t
    method connect : ?timeout:int -> ip_address -> int -> socket_status
    method destroy : unit -> unit
    method disconnect : unit -> unit
    method get_local_port : unit -> int
    method get_remote_port : unit -> ip_address
    method is_blocking : unit -> bool
    method receive_packet : packet -> socket_status
    method rep__sf_Socket : Socket.t
    method rep__sf_TcpSocket : TcpSocket.t
    method send_packet : packet -> socket_status
    method set_blocking : bool -> unit
  end
module Tcp_listener :
  sig
    type t
    external destroy : t -> unit = "sf_TcpListener_destroy__impl"
    external to_socket : t -> Socket.t
      = "upcast__sf_Socket_of_sf_TcpListener__impl"
    external default : unit -> t = "sf_TcpListener_default_constructor__impl"
    external get_local_port : t -> int = "sf_TcpListener_GetLocalPort__impl"
    external listen : t -> int -> socket_status
      = "sf_TcpListener_Listen__impl"
    external close : t -> unit = "sf_TcpListener_Close__impl"
    external accept : t -> tcp_socket -> socket_status
      = "sf_TcpListener_Accept__impl"
  end
class tcp_listener :
  Tcp_listener.t ->
  object
    val t_socket : Socket.t
    val t_tcp_listener : Tcp_listener.t
    method accept : tcp_socket -> socket_status
    method close : unit -> unit
    method destroy : unit -> unit
    method get_local_port : unit -> int
    method is_blocking : unit -> bool
    method listen : int -> socket_status
    method rep__sf_Socket : Socket.t
    method rep__sf_TcpListener : Tcp_listener.t
    method set_blocking : bool -> unit
  end
val max_datagram_size : int
module UdpSocket :
  sig
    type t
    external destroy : t -> unit = "sf_UdpSocket_destroy__impl"
    external to_socket : t -> Socket.t
      = "upcast__sf_Socket_of_sf_UdpSocket__impl"
    external default : unit -> t = "sf_UdpSocket_default_constructor__impl"
    external bind : t -> int -> socket_status = "sf_UdpSocket_Bind__impl"
    external unbind : t -> unit = "sf_UdpSocket_Unbind__impl"
    external send_packet : t -> packet -> socket_status
      = "sf_UdpSocket_SendPacket__impl"
    external receive_packet : t -> packet -> socket_status
      = "sf_UdpSocket_ReceivePacket__impl"
  end
class udp_socket :
  UdpSocket.t ->
  object
    val t_socket : Socket.t
    val t_udp_socket : UdpSocket.t
    method bind : int -> socket_status
    method destroy : unit -> unit
    method is_blocking : unit -> bool
    method receive_packet : packet -> socket_status
    method rep__sf_Socket : Socket.t
    method rep__sf_UdpSocket : UdpSocket.t
    method send_packet : packet -> socket_status
    method set_blocking : bool -> unit
    method unbind : unit -> unit
  end
