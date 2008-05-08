Attribute VB_Name = "modDxError"
Public Function Errors(ErrNum As Long) As String
    Select Case ErrNum
    Case DD_OK
        Errors = "The request completed successfully."
    Case DDERR_ALREADYINITIALIZED
        Errors = "The object has already been initialized."
    Case DDERR_BLTFASTCANTCLIP
        Errors = "A DirectDrawClipper object is attached to a source surface that has passed into a call to the DirectDrawSurface7.BltFast method."
    Case DDERR_CANNOTATTACHSURFACE
        Errors = "A surface cannot be attached to another requested surface."
    Case DDERR_CANNOTDETACHSURFACE
        Errors = "A surface cannot be detached from another requested surface."
    Case DDERR_CANTCREATEDC
        Errors = "Windows cannot create any more device contexts (DCs), or a DC was requested for a palette-indexed surface when the surface had no palette and the display mode was not palette-indexed (in this case DirectDraw cannot select a proper palette into the DC)."
    Case DDERR_CANTDUPLICATE
        Errors = "Primary and 3-D surfaces, or surfaces that are implicitly created, cannot be duplicated."
    Case DDERR_CANTLOCKSURFACE
        Errors = "Access to this surface is refused because an attempt was made to lock the primary surface without DCI support."
    Case DDERR_CANTPAGELOCK
        Errors = "An attempt to page-lock a surface failed. Page lock does not work on a display-memory surface or an emulated primary surface."
    Case DDERR_CANTPAGEUNLOCK
        Errors = "An attempt to page-unlock a surface failed. Page unlock does not work on a display-memory surface or an emulated primary surface."
    Case DDERR_CLIPPERISUSINGHWND
        Errors = "An attempt was made to set a clip list for a DirectDrawClipper object that is already monitoring a window handle."
    Case DDERR_COLORKEYNOTSET
        Errors = "No source color key is specified for this operation."
    Case DDERR_CURRENTLYNOTAVAIL
        Errors = "No support is currently available."
    Case DDERR_DCALREADYCREATED
        Errors = "A device context (DC) has already been returned for this surface. Only one DC can be retrieved for each surface."
    Case DDERR_DEVICEDOESNTOWNSURFACE
        Errors = "Surfaces created by one DirectDraw device cannot be used directly by another DirectDraw device."
    Case DDERR_DIRECTDRAWALREADYCREATED
        Errors = "A DirectDraw object representing this driver has already been created for this process."
    Case DDERR_EXCEPTION
        Errors = "An exception was encountered while performing the requested operation."
    Case DDERR_EXCLUSIVEMODEALREADYSET
        Errors = "An attempt was made to set the cooperative level when it was already set to exclusive."
    Case DDERR_EXPIRED
        Errors = "The data has expired and is therefore no longer valid."
    Case DDERR_GENERIC
        Errors = "There is an undefined error condition."
    Case DDERR_HEIGHTALIGN
        Errors = "The height of the provided rectangle is not a multiple of the required alignment."
    Case DDERR_HWNDALREADYSET
        Errors = "The DirectDraw cooperative level window handle has already been set. It cannot be reset while the process has surfaces or palettes created."
    Case DDERR_HWNDSUBCLASSED
        Errors = "DirectDraw is prevented from restoring state because the DirectDraw cooperative level window handle has been subclassed."
    Case DDERR_IMPLICITLYCREATED
        Errors = "The surface cannot be restored because it is an implicitly created surface."
    Case DDERR_INCOMPATIBLEPRIMARY
        Errors = "The primary surface creation request does not match with the existing primary surface."
    Case DDERR_INVALIDCAPS
        Errors = "One or more of the capability bits passed to the callback function are incorrect."
    Case DDERR_INVALIDCLIPLIST
        Errors = "DirectDraw does not support the provided clip list."
    Case DDERR_INVALIDDIRECTDRAWGUID
        Errors = "The globally unique identifier (GUID) passed to the DirectX7.DirectDrawCreate function is not a valid DirectDraw driver identifier."
    Case DDERR_INVALIDMODE
        Errors = "DirectDraw does not support the requested mode."
    Case DDERR_INVALIDOBJECT
        Errors = "DirectDraw received an invalid DirectDraw object."
    Case DDERR_INVALIDPARAMS
        Errors = "One or more of the parameters passed to the method are incorrect."
    Case DDERR_INVALIDPIXELFORMAT
        Errors = "The pixel format was invalid as specified."
    Case DDERR_INVALIDPOSITION
        Errors = "The position of the overlay on the destination is no longer legal."
    Case DDERR_INVALIDRECT
        Errors = "The provided rectangle was invalid."
    Case DDERR_INVALIDSTREAM
        Errors = "The specified stream contains invalid data."
    Case DDERR_INVALIDSURFACETYPE
        Errors = "The requested operation could not be performed because the surface was of the wrong type."
    Case DDERR_LOCKEDSURFACES
        Errors = "One or more surfaces are locked."
    Case DDERR_MOREDATA
        Errors = "There is more data available than the specified buffer size can hold."
    Case DDERR_NO3D
        Errors = "No 3-D hardware or emulation is present."
    Case DDERR_NOALPHAHW
        Errors = "No alpha acceleration hardware is present or available."
    Case DDERR_NOBLTHW
        Errors = "No blitter hardware is present."
    Case DDERR_NOCLIPLIST
        Errors = "No clip list is available."
    Case DDERR_NOCLIPPERATTACHED
        Errors = "No DirectDrawClipper object is attached to the surface object."
    Case DDERR_NOCOLORCONVHW
        Errors = "No color-conversion hardware is present or available."
    Case DDERR_NOCOLORKEY
        Errors = "The surface does not currently have a color key."
    Case DDERR_NOCOLORKEYHW
        Errors = "There is no hardware support for the destination color key."
    Case DDERR_NOCOOPERATIVELEVELSET
        Errors = "A create function was called when the DirectDraw7.SetCooperativeLevel method had not been called."
    Case DDERR_NODC
        Errors = "No DC has ever been created for this surface."
    Case DDERR_NODDROPSHW
        Errors = "No DirectDraw raster operation (ROP) hardware is available."
    Case DDERR_NODIRECTDRAWHW
        Errors = "Hardware-only DirectDraw object creation is not possible; the driver does not support any hardware."
    Case DDERR_NODIRECTDRAWSUPPORT
        Errors = "DirectDraw support is not possible with the current display driver."
    Case DDERR_NOEMULATION
        Errors = "Software emulation is not available."
    Case DDERR_NOEXCLUSIVEMODE
        Errors = "The operation requires the application to have exclusive mode, but the application does not have exclusive mode."
    Case DDERR_NOFLIPHW
        Errors = "Flipping visible surfaces is not supported."
    Case DDERR_NOFOCUSWINDOW
        Errors = "An attempt was made to create or set a device window without first setting the focus window."
    Case DDERR_NOGDI
        Errors = "No GDI is present."
    Case DDERR_NOHWND
        Errors = "Clipper notification requires a window handle, or no window handle was previously set as the cooperative level window handle."
    Case DDERR_NOMIPMAPHW
        Errors = "No mipmap-capable texture mapping hardware is present or available."
    Case DDERR_NOMIRRORHW
        Errors = "No mirroring hardware is present or available."
    Case DDERR_NONONLOCALVIDMEM
        Errors = "An attempt was made to allocate nonlocal video memory from a device that does not support nonlocal video memory."
    Case DDERR_NOOPTIMIZEHW
        Errors = "The device does not support optimized surfaces."
    Case DDERR_NOOVERLAYHW
        Errors = "No overlay hardware is present or available."
    Case DDERR_NOPALETTEATTACHED
        Errors = "No palette object is attached to this surface."
    Case DDERR_NOPALETTEHW
        Errors = "There is no hardware support for 16- or 256-color palettes."
    Case DDERR_NORASTEROPHW
        Errors = "No appropriate raster operation hardware is present or available."
    Case DDERR_NOROTATIONHW
        Errors = "No rotation hardware is present or available."
    Case DDERR_NOSTEREOHARDWARE
        Errors = "No stereo hardware is present or available."
    Case DDERR_NOSTRETCHHW
        Errors = "There is no hardware support for stretching."
    Case DDERR_NOSURFACELEFT
        Errors = "No hardware is present that supports stereo surfaces."
    Case DDERR_NOT4BITCOLOR
        Errors = "The DirectDrawSurface object is not uSing a 4-bit color palette, and the requested operation requires a 4-bit color palette."
    Case DDERR_NOT4BITCOLORINDEX
        Errors = "The DirectDrawSurface object is not uSing a 4-bit color index palette, and the requested operation requires a 4-bit color index palette."
    Case DDERR_NOT8BITCOLOR
        Errors = "The DirectDrawSurface object is not uSing an 8-bit color palette, and the requested operation requires an 8-bit color palette."
    Case DDERR_NOTAOVERLAYSURFACE
        Errors = "An overlay component was called for a non-overlay surface."
    Case DDERR_NOTEXTUREHW
        Errors = "No texture-mapping hardware is present or available."
    Case DDERR_NOTFLIPPABLE
        Errors = "An attempt was made to flip a surface that cannot be flipped."
    Case DDERR_NOTFOUND
        Errors = "The requested item was not found."
    Case DDERR_NOTINITIALIZED
        Errors = "An attempt was made to call an interface method of a DirectDraw object created by CoCreateInstance before the object was initialized."
    Case DDERR_NOTLOADED
        Errors = "The surface is an optimized surface, but it has not yet been allocated any memory."
    Case DDERR_NOTLOCKED
        Errors = "An attempt was made to unlock a surface that was not locked."
    Case DDERR_NOTPAGELOCKED
        Errors = "An attempt was made to page-unlock a surface with no outstanding page locks."
    Case DDERR_NOTPALETTIZED
        Errors = "The surface being used is not a palette-based surface."
    Case DDERR_NOVSYNCHW
        Errors = "There is no hardware support for vertical blank synchronized operations."
    Case DDERR_NOZBUFFERHW
        Errors = "There is no hardware support for z-buffers."
    Case DDERR_NOZOVERLAYHW
        Errors = "The hardware does not support z-ordering of overlays."
    Case DDERR_OUTOFCAPS
        Errors = "The hardware needed for the requested operation has already been allocated."
    Case DDERR_OUTOFMEMORY
        Errors = "DirectDraw does not have enough memory to perform the operation."
    Case DDERR_OUTOFVIDEOMEMORY
        Errors = "DirectDraw does not have enough display memory to perform the operation."
    Case DDERR_OVERLAPPINGRECTS
        Errors = "The source and destination rectangles are on the same surface and overlap each other."
    Case DDERR_OVERLAYCANTCLIP
        Errors = "The hardware does not support clipped overlays."
    Case DDERR_OVERLAYCOLORKEYONLYONEACTIVE
        Errors = "An attempt was made to have more than one color key active on an overlay."
    Case DDERR_OVERLAYNOTVISIBLE
        Errors = "The method was called on a hidden overlay."
    Case DDERR_PALETTEBUSY
        Errors = "Access to this palette is refused because the palette is locked by another thread."
    Case DDERR_PRIMARYSURFACEALREADYEXISTS
        Errors = "This process has already created a primary surface."
    Case DDERR_REGIONTOOSMALL
        Errors = "The region passed to the DirectDrawClipper.GetClipList method is too small."
    Case DDERR_SURFACEALREADYATTACHED
        Errors = "An attempt was made to attach a surface to another surface to which it is already attached."
    Case DDERR_SURFACEALREADYDEPENDENT
        Errors = "An attempt was made to make a surface a dependency of another surface on which it is already dependent."
    Case DDERR_SURFACEBUSY
        Errors = "Access to the surface is refused because the surface is locked by another thread."
    Case DDERR_SURFACEISOBSCURED
        Errors = "Access to the surface is refused because the surface is obscured."
    Case DDERR_SURFACELOST
        Errors = "Access to the surface is refused because the surface memory is gone. Call the DirectDrawSurface7.Restore method on this surface to restore the memory associated with it."
    Case DDERR_SURFACENOTATTACHED
        Errors = "The requested surface is not attached."
    Case DDERR_TOOBIGHEIGHT
        Errors = "The height requested by DirectDraw is too large."
    Case DDERR_TOOBIGSIZE
        Errors = "The size requested by DirectDraw is too large. However, the individual height and width are valid sizes."
    Case DDERR_TOOBIGWIDTH
        Errors = "The width requested by DirectDraw is too large."
    Case DDERR_UNSUPPORTED
        Errors = "The operation is not supported."
    Case DDERR_UNSUPPORTEDFORMAT
        Errors = "The FourCC format requested is not supported by DirectDraw."
    Case DDERR_UNSUPPORTEDMASK
        Errors = "The bitmask in the pixel format requested is not supported by DirectDraw."
    Case DDERR_UNSUPPORTEDMODE
        Errors = "The display is currently in an unsupported mode."
    Case DDERR_VERTICALBLANKINPROGRESS
        Errors = "A vertical blank is in progress."
    Case DDERR_VIDEONOTACTIVE
        Errors = "The video port is not active."
    Case DDERR_WASSTILLDRAWING
        Errors = "The previous blit operation that is transferring information to or from this surface is incomplete."
    Case DDERR_WRONGMODE
        Errors = "This surface cannot be restored because it was created in a different mode."
    Case DDERR_XALIGN
        Errors = "The provided rectangle was not horizontally aligned on a required boundary."
    Case E_INVALIDINTERFACE
        Errors = "The specified interface is invalid or does not exist."
    Case E_OUTOFMEMORY
        Errors = "Not enough free memory to complete the method."
        
    Case DI_BUFFEROVERFLOW
        Errors = "The input buffer overflowed and data was lost."
    Case DIERR_ACQUIRED
        Errors = "The operation cannot be performed while the device is acquired."
    Case DIERR_ALREADYINITIALIZED
        Errors = "This object is already initialized"
    Case DIERR_BADDRIVERVER
        Errors = "The object could not be created due to an incompatible driver version or mismatched or incomplete driver components."
    Case DIERR_BETADIRECTINPUTVERSION
        Errors = "The application was written for an unsupported prerelease version of DirectInput."
    Case DIERR_DEVICEFULL
        Errors = "The device is full."
    Case DIERR_DEVICENOTREG
        Errors = "The device or device instance is not registered with DirectInput. This value is equal to the REGDB_E_CLASSNOTREG standard COM return value."
    Case DIERR_EFFECTPLAYING
        Errors = "The parameters were updated in memory but were not downloaded to the device because the device does not support updating an effect while it is still playing."
    Case DIERR_HASEFFECTS
        Errors = "The device cannot be reinitialized because there are still effects attached to it."
    Case DIERR_GENERIC
        Errors = "An undetermined error occurred inside the DirectInput subsystem. This value is equal to the E_FAIL standard COM return value."
    Case DIERR_HANDLEEXISTS
        Errors = "The device already has an event notification associated with it. This value is equal to the E_ACCESSDENIED standard COM return value."
    Case DIERR_INCOMPLETEEFFECT
        Errors = "The effect could not be downloaded because essential information is misSing. For example, no axes have been associated with the effect, or no type-specific information has been supplied."
    Case DIERR_INPUTLOST
        Errors = "Access to the input device has been lost. It must be reacquired."
    Case DIERR_INVALIDHANDLE
        Errors = "An invalid window handle was passed to the method."
    Case DIERR_INVALIDPARAM
        Errors = "An invalid parameter was passed to the returning function, or the object was not in a state that permitted the function to be called. This value is equal to the E_INVALIDARG standard COM return value."
    Case DIERR_MOREDATA
        Errors = "Not all the requested information fitted into the buffer."
    Case DIERR_NOAGGREGATION
        Errors = "This object does not support aggregation."
    Case DIERR_NOINTERFACE
        Errors = "The specified interface is not supported by the object. This value is equal to the E_NOINTERFACE standard COM return value."
    Case DIERR_NOTACQUIRED
        Errors = "The operation cannot be performed unless the device is acquired."
    Case DIERR_NOTBUFFERED
        Errors = "The device is not buffered. Set the DIPROP_BUFFERSIZE property to enable buffering."
    Case DIERR_NOTDOWNLOADED
        Errors = "The effect is not downloaded."
    Case DIERR_NOTEXCLUSIVEACQUIRED
        Errors = "The operation cannot be performed unless the device is acquired in DISCL_EXCLUSIVE mode."
    Case DIERR_NOTINITIALIZED
        Errors = "The object has not been initialized."
    Case DIERR_NOTFOUND
        Errors = "The requested object does not exist."
    Case DIERR_OBJECTNOTFOUND
        Errors = "The requested object does not exist."
    Case DIERR_OLDDIRECTINPUTVERSION
        Errors = "The application requires a newer version of DirectInput."
    Case DIERR_OTHERAPPHASPRIO
        Errors = "Another application has a higher priority level, preventing this call from succeeding. This value is equal to the E_ACCESSDENIED standard COM return value. This error can be returned when an application has only foreground access to a device but is attempting to acquire the device while in the background."
    Case DIERR_OUTOFMEMORY
        Errors = "The DirectInput subsystem couldn't allocate sufficient memory to complete the call. This value is equal to the E_OUTOFMEMORY standard COM return value."
    Case DIERR_READONLY
        Errors = "The specified property cannot be changed. This value is equal to the E_ACCESSDENIED standard COM return value."
    Case DIERR_REPORTFULL
        Errors = "More information was requested to be sent than can be sent to the device."
    Case DIERR_UNPLUGGED
        Errors = "The operation could not be completed because the device is not plugged in."
    Case DIERR_UNSUPPORTED
        Errors = "The function called is not supported at this time. This value is equal to the E_NOTIMPL standard COM return value."
    Case E_PENDING
        Errors = "Data is not yet available."
        
        '
    Case DPNERR_ABORTED
        Errors = "The operation was canceled before it could be completed."
    Case DPNERR_ADDRESSinG
        Errors = "The address specified is invalid."
    Case DPNERR_ALREADYCONNECTED
        Errors = "The object is already connected to the session."
    Case DPNERR_ALREADYCLOSinG
        Errors = "An attempt to call Close on a session has been made more than once."
    Case DPNERR_ALREADYDISCONNECTING
        Errors = "The client is already disconnecting from the session."
    Case DPNERR_ALREADYINITIALIZED
        Errors = "The object has already been initialized."
    Case DPNERR_ALREADYREGISTERED
        Errors = "A message handler has already been registered. You must unregister the current handler before registering a new one."
    Case DPNERR_BUFFERTOOSMALL
        Errors = "The supplied buffer is not large enough to contain the requested data."
    Case DPNERR_CANNOTCANCEL
        Errors = "The operation could not be canceled."
    Case DPNERR_CANTCREATEGROUP
        Errors = "A new group cannot be created."
    Case DPNERR_CANTCREATEPLAYER
        Errors = "A new player cannot be created."
    Case DPNERR_CANTLAUNCHAPPLICATION
        Errors = "The lobby cannot launch the specified application."
    Case DPNERR_CONNECTING
        Errors = "The method is in the process of connecting to the network."
    Case DPNERR_CONNECTIONLOST
        Errors = "The service provider connection was reset while data was being sent."
    Case DPNERR_DOESNOTEXIST
        Errors = "Requested element is not part of the address."
    Case DPNERR_EXCEPTION
        Errors = "An exception occurred when procesSing the request."
    Case DPNERR_GENERIC
        Errors = "An undefined error condition occurred."
    Case DPNERR_GROUPNOTEMPTY
        Errors = "The specified group is not empty."
    Case DPNERR_HOSTING
        Errors = "Hosting Error"
    Case DPNERR_HOSTREJECTEDCONNECTION
        Errors = "The connection request was rejected. Check the ReplyData member of the DPNMSG_CONNECT_COMPLETE type for details."
    Case DPNERR_HOSTTERMINATEDSESSION
        Errors = "The host terminated the session."
    Case DPNERR_INCOMPLETEADDRESS
        Errors = "The address specified is not complete."
    Case DPNERR_INVALIDADDRESSFORMAT
        Errors = "The address format is invalid."
    Case DPNERR_INVALIDAPPLICATION
        Errors = "The GUID supplied for the application is invalid."
    Case DPNERR_INVALIDCOMMAND
        Errors = "The command specified is invalid."
    Case DPNERR_INVALIDFLAGS
        Errors = "The flags passed to this method are invalid."
    Case DPNERR_INVALIDGROUP
        Errors = "The group ID is not recognized as a valid group ID for this game session."
    Case DPNERR_INVALIDHANDLE
        Errors = "The handle specified is invalid."
    Case DPNERR_INVALIDINSTANCE
        Errors = "The GUID for the application instance is invalid."
    Case DPNERR_INVALIDINTERFACE
        Errors = "The interface parameter is invalid. This value will be returned in a connect request if the connecting player was not a client in a client/server game or a peer in a peer-to-peer game."
    Case DPNERR_INVALIDLOCALADDRESS
        Errors = "The address for the local computer or adapter is invalid."
    Case DPNERR_INVALIDOBJECT
        Errors = "The DirectPlay object pointer is invalid."
    Case DPNERR_INVALIDPARAM
        Errors = "One or more of the parameters passed to the method are invalid."
    Case DPNERR_INVALIDPASSWORD
        Errors = "An invalid password was supplied when attempting to join a session that requires a password."
    Case DPNERR_INVALIDPLAYER
        Errors = "The player ID is not recognized as a valid player ID for this game session."
    Case DPNERR_INVALIDPOINTER
        Errors = "Pointer specified as a parameter is invalid."
    Case DPNERR_INVALIDPRIORITY
        Errors = "The specified priority is not within the range of allowed priorities, which is inclusively from 0 through 65535."
    Case DPNERR_INVALIDSTRING
        Errors = "String specified as a parameter is invalid."
    Case DPNERR_INVALIDREMOTEADDRESS
        Errors = "The specified remote address is invalid."
    Case DPNERR_INVALIDURL
        Errors = "Specified string is not a valid DirectPlay URL."
    Case DPNERR_INVALIDVERSION
        Errors = "There was an attempt to connect to an invalid version of DirectPlay."
    Case DPNERR_NOCAPS
        Errors = "The communication link that DirectPlay is attempting to use is not capable of this function."
    Case DPNERR_NOCONNECTION
        Errors = "No communication link was established."
    Case DPNERR_NOHOSTPLAYER
        Errors = "There is currently no player acting as the host of the session."
    Case DPNERR_NOINTERFACE
        Errors = "The interface is not supported."
    Case DPNERR_NORESPONSE
        Errors = "There was no response from the specified target."
    Case DPNERR_NOTALLOWED
        Errors = "The object is read-only; this function is not allowed on this object."
    Case DPNERR_NOTHOST
        Errors = "The client attempted to connect to a nonhost computer. Additionally, this error value may be returned by a nonhost that tried to set the application description."
    Case DPNERR_OUTOFMEMORY
        Errors = "There is insufficient memory to perform the requested operation."
    Case DPNERR_PENDING
        Errors = "Not an error, this return indicates that an asynchronous operation has reached the point where it is successfully queued."
    Case DPNERR_PLAYERLOST
        Errors = "A player has lost the connection to the session."
    Case DPNERR_SENDTOOLARGE
        Errors = "The buffer was too large."
    Case DPNERR_SESSIONFULL
        Errors = "The request to connect to the host or server failed because the maximum number of players allotted for the session has been reached."
    Case DPNERR_TIMEDOUT
        Errors = "The operation could not complete because it has timed out."
    Case DPNERR_UNINITIALIZED
        Errors = "The requested object has not been initialized."
    Case DPNERR_UNSUPPORTED
        Errors = "The function or feature is not available in this implementation or on this service provider."
    Case DPNERR_USERCANCEL
        Errors = "The user canceled the operation."
    Case DV_OK
        Errors = "The request completed successfully."
    Case DV_FULLDUPLEX
        Errors = "The sound card is capable of full-duplex operation."
    Case DV_HALFDUPLEX
        Errors = "The sound card can be run only in half-duplex mode."
    Case DVERR_BUFFERTOOSMALL
        Errors = "The supplied buffer is not large enough to contain the requested data."
    Case DVERR_EXCEPTION
        Errors = "An exception occurred when procesSing the request."
    Case DVERR_GENERIC
        Errors = "An undefined error condition occurred."
    Case DVERR_INVALIDFLAGS
        Errors = "The flags passed to this method are invalid."
    Case DVERR_INVALIDOBJECT
        Errors = "The DirectPlay object pointer is invalid."
    Case DVERR_INVALIDPARAM
        Errors = "One or more of the parameters passed to the method are invalid."
    Case DVERR_INVALIDPLAYER
        Errors = "The player ID is not recognized as a valid player ID for this game session."
    Case DVERR_INVALIDGROUP
        Errors = "The group ID is not recognized as a valid group ID for this game session."
    Case DVERR_INVALIDHANDLE
        Errors = "The handle specified is invalid."
    Case DVERR_OUTOFMEMORY
        Errors = "There is insufficient memory to perform the requested operation."
    Case DVERR_PENDING
        Errors = "Not an error, this return indicates that an asynchronous operation has reached the point where it is successfully queued."
    Case DVERR_NOTSUPPORTED
        Errors = "The operation is not supported."
    Case DVERR_NOINTERFACE
        Errors = "The specified interface is not supported. This error could indicate that you are uSing an earlier version of DirectX that does not expose the interface."
    Case DVERR_SESSIONLOST
        Errors = "The transport has lost the connection to the session."
    Case DVERR_NOVOICESESSION
        Errors = "The session specified is not a voice session."
    Case DVERR_CONNECTIONLOST
        Errors = "The connection to the voice session has been lost."
    Case DVERR_NOTINITIALIZED
        Errors = "The DirectPlayVoiceClient8.Initialize or DirectPlayVoiceServer8.Initialize method must be called before calling this method."
    Case DVERR_CONNECTED
        Errors = "The DirectPlay Voice object is connected."
    Case DVERR_NOTCONNECTED
        Errors = "The DirectPlay Voice object is not connected."
    Case DVERR_CONNECTABORTING
        Errors = "The connection is being disconnected."
    Case DVERR_NOTALLOWED
        Errors = "The object does not have the permission to perform this operation."
    Case DVERR_INVALIDTARGET
        Errors = "The specified target is not a valid player ID or group ID for this voice session."
    Case DVERR_TRANSPORTNOTHOST
        Errors = "The object is not the host of the voice session."
    Case DVERR_COMPRESSIONNOTSUPPORTED
        Errors = "The specified compression type is not supported on the local computer."
    Case DVERR_ALREADYPENDING
        Errors = "An asynchronous call of this type is already pending."
    Case DVERR_ALREADYINITIALIZED
        Errors = "The object has already been initialized."
    Case DVERR_SOUNDINITFAILURE
        Errors = "A failure was encountered initializing the sound card."
    Case DVERR_TIMEOUT
        Errors = "The operation could not be performed in the specified time."
    Case DVERR_CONNECTABORTED
        Errors = "The connect operation was canceled before it could be completed."
    Case DVERR_NO3DSOUND
        Errors = "The local computer does not support 3-D sound."
    Case DVERR_ALREADYBUFFERED
        Errors = "There is already a user buffer for the specified ID."
    Case DVERR_NOTBUFFERED
        Errors = "There is no user buffer for the specified ID."
    Case DVERR_HOSTING
        Errors = "The object is the host of the session."
    Case DVERR_NOTHOSTING
        Errors = "The object is not the host of the session."
    Case DVERR_INVALIDDEVICE
        Errors = "The specified device is invalid."
    Case DVERR_RECORDSYSTEMERROR
        Errors = "An error in the recording system occurred."
    Case DVERR_PLAYBACKSYSTEMERROR
        Errors = "An error in the playback system occurred."
    Case DVERR_SENDERROR
        Errors = "An error occurred while sending data."
    Case DVERR_USERCANCEL
        Errors = "The user canceled the operation."
    Case DVERR_UNKNOWN
        Errors = "An unknown error occurred."
    Case DVERR_RUNSETUP
        Errors = "The specified audio configuration has not been tested. Call the DirectPlayVoiceTest8.CheckAudioSetup method."
    Case DVERR_INCOMPATIBLEVERSION
        Errors = "The client connected to a voice session that is incompatible with the host."
    Case DVERR_INITIALIZED
        Errors = "The Initialize method failed because the object has already been initialized."
    Case DVERR_INVALIDPOINTER
        Errors = "The pointer specified is invalid."
    Case DVERR_NOTRANSPORT
        Errors = "The specified object is not a valid transport."
    Case DVERR_NOCALLBACK
        Errors = "This operation cannot be performed because no callback function was specified."
    Case DVERR_TRANSPORTNOTINIT
        Errors = "The specified transport is not yet initialized."
    Case DVERR_TRANSPORTNOSESSION
        Errors = "The specified transport is valid but is not connected/hosting."
    Case DVERR_TRANSPORTNOPLAYER
        Errors = "The specified transport is connected/hosting but no local player exists."
        '''''''''''' directdraw
    Case DD_OK
        Errors = "The request completed successfully."
    Case DDERR_ALREADYINITIALIZED
        Errors = "The object has already been initialized."
    Case DDERR_BLTFASTCANTCLIP
        Errors = "A DirectDrawClipper object is attached to a source surface that has passed into a call to the DirectDrawSurface7.BltFast method."
    Case DDERR_CANNOTATTACHSURFACE
        Errors = "A surface cannot be attached to another requested surface."
    Case DDERR_CANNOTDETACHSURFACE
        Errors = "A surface cannot be detached from another requested surface."
    Case DDERR_CANTCREATEDC
        Errors = "Windows cannot create any more device contexts (DCs), or a DC was requested for a palette-indexed surface when the surface had no palette and the display mode was not palette-indexed (in this case DirectDraw cannot select a proper palette into the DC)."
    Case DDERR_CANTDUPLICATE
        Errors = "Primary and 3-D surfaces, or surfaces that are implicitly created, cannot be duplicated."
    Case DDERR_CANTLOCKSURFACE
        Errors = "Access to this surface is refused because an attempt was made to lock the primary surface without DCI support."
    Case DDERR_CANTPAGELOCK
        Errors = "An attempt to page-lock a surface failed. Page lock does not work on a display-memory surface or an emulated primary surface."
    Case DDERR_CANTPAGEUNLOCK
        Errors = "An attempt to page-unlock a surface failed. Page unlock does not work on a display-memory surface or an emulated primary surface."
    Case DDERR_CLIPPERISUSINGHWND
        Errors = "An attempt was made to set a clip list for a DirectDrawClipper object that is already monitoring a window handle."
    Case DDERR_COLORKEYNOTSET
        Errors = "No source color key is specified for this operation."
    Case DDERR_CURRENTLYNOTAVAIL
        Errors = "No support is currently available."
    Case DDERR_DCALREADYCREATED
        Errors = "A device context (DC) has already been returned for this surface. Only one DC can be retrieved for each surface."
    Case DDERR_DEVICEDOESNTOWNSURFACE
        Errors = "Surfaces created by one DirectDraw device cannot be used directly by another DirectDraw device."
    Case DDERR_DIRECTDRAWALREADYCREATED
        Errors = "A DirectDraw object representing this driver has already been created for this process."
    Case DDERR_EXCEPTION
        Errors = "An exception was encountered while performing the requested operation."
    Case DDERR_EXCLUSIVEMODEALREADYSET
        Errors = "An attempt was made to set the cooperative level when it was already set to exclusive."
    Case DDERR_EXPIRED
        Errors = "The data has expired and is therefore no longer valid."
    Case DDERR_GENERIC
        Errors = "There is an undefined error condition."
    Case DDERR_HEIGHTALIGN
        Errors = "The height of the provided rectangle is not a multiple of the required alignment."
    Case DDERR_HWNDALREADYSET
        Errors = "The DirectDraw cooperative level window handle has already been set. It cannot be reset while the process has surfaces or palettes created."
    Case DDERR_HWNDSUBCLASSED
        Errors = "DirectDraw is prevented from restoring state because the DirectDraw cooperative level window handle has been subclassed."
    Case DDERR_IMPLICITLYCREATED
        Errors = "The surface cannot be restored because it is an implicitly created surface."
    Case DDERR_INCOMPATIBLEPRIMARY
        Errors = "The primary surface creation request does not match with the existing primary surface."
    Case DDERR_INVALIDCAPS
        Errors = "One or more of the capability bits passed to the callback function are incorrect."
    Case DDERR_INVALIDCLIPLIST
        Errors = "DirectDraw does not support the provided clip list."
    Case DDERR_INVALIDDIRECTDRAWGUID
        Errors = "The globally unique identifier (GUID) passed to the DirectX7.DirectDrawCreate function is not a valid DirectDraw driver identifier."
    Case DDERR_INVALIDMODE
        Errors = "DirectDraw does not support the requested mode."
    Case DDERR_INVALIDOBJECT
        Errors = "DirectDraw received an invalid DirectDraw object."
    Case DDERR_INVALIDPARAMS
        Errors = "One or more of the parameters passed to the method are incorrect."
    Case DDERR_INVALIDPIXELFORMAT
        Errors = "The pixel format was invalid as specified."
    Case DDERR_INVALIDPOSITION
        Errors = "The position of the overlay on the destination is no longer legal."
    Case DDERR_INVALIDRECT
        Errors = "The provided rectangle was invalid."
    Case DDERR_INVALIDSTREAM
        Errors = "The specified stream contains invalid data."
    Case DDERR_INVALIDSURFACETYPE
        Errors = "The requested operation could not be performed because the surface was of the wrong type."
    Case DDERR_LOCKEDSURFACES
        Errors = "One or more surfaces are locked."
    Case DDERR_MOREDATA
        Errors = "There is more data available than the specified buffer size can hold."
    Case DDERR_NO3D
        Errors = "No 3-D hardware or emulation is present."
    Case DDERR_NOALPHAHW
        Errors = "No alpha acceleration hardware is present or available."
    Case DDERR_NOBLTHW
        Errors = "No blitter hardware is present."
    Case DDERR_NOCLIPLIST
        Errors = "No clip list is available."
    Case DDERR_NOCLIPPERATTACHED
        Errors = "No DirectDrawClipper object is attached to the surface object."
    Case DDERR_NOCOLORCONVHW
        Errors = "No color-conversion hardware is present or available."
    Case DDERR_NOCOLORKEY
        Errors = "The surface does not currently have a color key."
    Case DDERR_NOCOLORKEYHW
        Errors = "There is no hardware support for the destination color key."
    Case DDERR_NOCOOPERATIVELEVELSET
        Errors = "A create function was called when the DirectDraw7.SetCooperativeLevel method had not been called."
    Case DDERR_NODC
        Errors = "No DC has ever been created for this surface."
    Case DDERR_NODDROPSHW
        Errors = "No DirectDraw raster operation (ROP) hardware is available."
    Case DDERR_NODIRECTDRAWHW
        Errors = "Hardware-only DirectDraw object creation is not possible; the driver does not support any hardware."
    Case DDERR_NODIRECTDRAWSUPPORT
        Errors = "DirectDraw support is not possible with the current display driver."
    Case DDERR_NOEMULATION
        Errors = "Software emulation is not available."
    Case DDERR_NOEXCLUSIVEMODE
        Errors = "The operation requires the application to have exclusive mode, but the application does not have exclusive mode."
    Case DDERR_NOFLIPHW
        Errors = "Flipping visible surfaces is not supported."
    Case DDERR_NOFOCUSWINDOW
        Errors = "An attempt was made to create or set a device window without first setting the focus window."
    Case DDERR_NOGDI
        Errors = "No GDI is present."
    Case DDERR_NOHWND
        Errors = "Clipper notification requires a window handle, or no window handle was previously set as the cooperative level window handle."
    Case DDERR_NOMIPMAPHW
        Errors = "No mipmap-capable texture mapping hardware is present or available."
    Case DDERR_NOMIRRORHW
        Errors = "No mirroring hardware is present or available."
    Case DDERR_NONONLOCALVIDMEM
        Errors = "An attempt was made to allocate nonlocal video memory from a device that does not support nonlocal video memory."
    Case DDERR_NOOPTIMIZEHW
        Errors = "The device does not support optimized surfaces."
    Case DDERR_NOOVERLAYHW
        Errors = "No overlay hardware is present or available."
    Case DDERR_NOPALETTEATTACHED
        Errors = "No palette object is attached to this surface."
    Case DDERR_NOPALETTEHW
        Errors = "There is no hardware support for 16- or 256-color palettes."
    Case DDERR_NORASTEROPHW
        Errors = "No appropriate raster operation hardware is present or available."
    Case DDERR_NOROTATIONHW
        Errors = "No rotation hardware is present or available."
    Case DDERR_NOSTEREOHARDWARE
        Errors = "No stereo hardware is present or available."
    Case DDERR_NOSTRETCHHW
        Errors = "There is no hardware support for stretching."
    Case DDERR_NOSURFACELEFT
        Errors = "No hardware is present that supports stereo surfaces."
    Case DDERR_NOT4BITCOLOR
        Errors = "The DirectDrawSurface object is not uSing a 4-bit color palette, and the requested operation requires a 4-bit color palette."
    Case DDERR_NOT4BITCOLORINDEX
        Errors = "The DirectDrawSurface object is not uSing a 4-bit color index palette, and the requested operation requires a 4-bit color index palette."
    Case DDERR_NOT8BITCOLOR
        Errors = "The DirectDrawSurface object is not uSing an 8-bit color palette, and the requested operation requires an 8-bit color palette."
    Case DDERR_NOTAOVERLAYSURFACE
        Errors = "An overlay component was called for a non-overlay surface."
    Case DDERR_NOTEXTUREHW
        Errors = "No texture-mapping hardware is present or available."
    Case DDERR_NOTFLIPPABLE
        Errors = "An attempt was made to flip a surface that cannot be flipped."
    Case DDERR_NOTFOUND
        Errors = "The requested item was not found."
    Case DDERR_NOTINITIALIZED
        Errors = "An attempt was made to call an interface method of a DirectDraw object created by CoCreateInstance before the object was initialized."
    Case DDERR_NOTLOADED
        Errors = "The surface is an optimized surface, but it has not yet been allocated any memory."
    Case DDERR_NOTLOCKED
        Errors = "An attempt was made to unlock a surface that was not locked."
    Case DDERR_NOTPAGELOCKED
        Errors = "An attempt was made to page-unlock a surface with no outstanding page locks."
    Case DDERR_NOTPALETTIZED
        Errors = "The surface being used is not a palette-based surface."
    Case DDERR_NOVSYNCHW
        Errors = "There is no hardware support for vertical blank synchronized operations."
    Case DDERR_NOZBUFFERHW
        Errors = "There is no hardware support for z-buffers."
    Case DDERR_NOZOVERLAYHW
        Errors = "The hardware does not support z-ordering of overlays."
    Case DDERR_OUTOFCAPS
        Errors = "The hardware needed for the requested operation has already been allocated."
    Case DDERR_OUTOFMEMORY
        Errors = "DirectDraw does not have enough memory to perform the operation."
    Case DDERR_OUTOFVIDEOMEMORY
        Errors = "DirectDraw does not have enough display memory to perform the operation."
    Case DDERR_OVERLAPPINGRECTS
        Errors = "The source and destination rectangles are on the same surface and overlap each other."
    Case DDERR_OVERLAYCANTCLIP
        Errors = "The hardware does not support clipped overlays."
    Case DDERR_OVERLAYCOLORKEYONLYONEACTIVE
        Errors = "An attempt was made to have more than one color key active on an overlay."
    Case DDERR_OVERLAYNOTVISIBLE
        Errors = "The method was called on a hicase DDen overlay."
    Case DDERR_PALETTEBUSY
        Errors = "Access to this palette is refused because the palette is locked by another thread."
    Case DDERR_PRIMARYSURFACEALREADYEXISTS
        Errors = "This process has already created aprimary surface."
    Case DDERR_REGIONTOOSMALL
        Errors = "The region passed to the DirectDrawClipper.GetClipList method is too small."
    Case DDERR_SURFACEALREADYATTACHED
        Errors = "An attempt was made to attach a surface to another surface to which it is already attached."
    Case DDERR_SURFACEALREADYDEPENDENT
        Errors = "An attempt was made to make a surface a dependency of another surface on which it is already dependent."
    Case DDERR_SURFACEBUSY
        Errors = "Access to the surface is refused because the surface is locked by another thread."
    Case DDERR_SURFACEISOBSCURED
        Errors = "Access to the surface is refused because the surface is obscured."
    Case DDERR_SURFACELOST
        Errors = "Access to the surface is refused because the surface memory is gone. Call the DirectDrawSurface7.Restore method on this surface to restore the memory associated with it."
    Case DDERR_SURFACENOTATTACHED
        Errors = "The requested surface is not attached."
    Case DDERR_TOOBIGHEIGHT
        Errors = "The height requested by DirectDraw is too large."
    Case DDERR_TOOBIGSIZE
        Errors = "The size requested by DirectDraw is too large. However, the individual height and width are valid sizes."
    Case DDERR_TOOBIGWIDTH
        Errors = "The width requested by DirectDraw is too large."
    Case DDERR_UNSUPPORTED
        Errors = "The operation is not supported."
    Case DDERR_UNSUPPORTEDFORMAT
        Errors = "The FourCC format requested is not supported by DirectDraw."
    Case DDERR_UNSUPPORTEDMASK
        Errors = "The bitmask in the pixel format requested is not supported by DirectDraw."
    Case DDERR_UNSUPPORTEDMODE
        Errors = "The display is currently in an unsupported mode."
    Case DDERR_VERTICALBLANKINPROGRESS
        Errors = "A vertical blank is in progress."
    Case DDERR_VIDEONOTACTIVE
        Errors = "The video port is not active."
    Case DDERR_WASSTILLDRAWING
        Errors = "The previous blit operation that is transferring information to or from this surface is incomplete."
    Case DDERR_WRONGMODE
        Errors = "This surface cannot be restored because it was created in a different mode."
    Case DDERR_XALIGN
        Errors = "The provided rectangle was not horizontally aligned on a required boundary."
    Case E_INVALIDINTERFACE
        Errors = "The specified interface is invalid or does not exist."
    Case E_OUTOFMEMORY
        Errors = "Not enough free memory to complete the method."
    End Select
End Function

