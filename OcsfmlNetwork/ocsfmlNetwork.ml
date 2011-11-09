

external class ip_address (IPAddress) : sf_IpAddress =
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
    
  external class directory_response (DirectoryResponse) : "sf_Ftp_DirectoryResponse"
  object
    external inherit response
    constructor default : response = "default_constructor"
    external method get_directory : unit -> string = "GetDirectory"
  end

  external class listing_response (ListingResponse) : "sf_Ftp_ListingResponse"
  object
    external inherit response
    constructor default : response -> char list (* ou char array ? *) = "default_constructor"
    external method get_filenames : unit -> string list (* ou string array ? *) = "GetFilenames"
  end

  external class ftp (Ftp) : "sf_Ftp"
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
