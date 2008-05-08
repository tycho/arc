Attribute VB_Name = "modDPError"
'Option Explicit
Public Function errors(ErrNum As Long) As String
Select Case ErrNum
Case DD_OK
errors = "The request completed successfully."
Case DDERR_ALREADYINITIALIZED
errors = "The object has already been initialised."
Case DDERR_BLTFASTCANTCLIP
errors = "A DirectDrawClipper object is attached to a source surface that has passed into a call to the DirectDrawSurface7.BltFast method."
Case DDERR_CANNOTATTACHSURFACE
errors = "A surface cannot be attached to another requested surface."
Case DDERR_CANNOTDETACHSURFACE
errors = "A surface cannot be detached from another requested surface."
Case DDERR_CANTCREATEDC
errors = "Windows cannot create any more device contexts (DCs), or a DC was requested for a palette-indexed surface when the surface had no palette and the display mode was not palette-indexed (in this case DirectDraw cannot select a proper palette into the DC)."
Case DDERR_CANTDUPLICATE
errors = "Primary and 3-D surfaces, or surfaces that are implicitly created, cannot be duplicated."
Case DDERR_CANTLOCKSURFACE
errors = "Access to this surface is refused because an attempt was made to lock the primary surface without DCI support."
Case DDERR_CANTPAGELOCK
errors = "An attempt to page-lock a surface failed. Page lock does not work on a display-memory surface or an emulated primary surface."
Case DDERR_CANTPAGEUNLOCK
errors = "An attempt to page-unlock a surface failed. Page unlock does not work on a display-memory surface or an emulated primary surface."
Case DDERR_CLIPPERISUSINGHWND
errors = "An attempt was made to set a clip list for a DirectDrawClipper object that is already monitoring a window handle."
Case DDERR_COLORKEYNOTSET
errors = "No source Color key is specified for this operation."
Case DDERR_CURRENTLYNOTAVAIL
errors = "No support is currently available."
Case DDERR_DCALREADYCREATED
errors = "A device context (DC) has already been returned for this surface. Only one DC can be retrieved for each surface."
Case DDERR_DEVICEDOESNTOWNSURFACE
errors = "Surfaces created by one DirectDraw device cannot be used directly by another DirectDraw device."
Case DDERR_DIRECTDRAWALREADYCREATED
errors = "A DirectDraw object representing this driver has already been created for this process."
Case DDERR_EXCEPTION
errors = "An exception was encountered while performing the requested operation."
Case DDERR_EXCLUSIVEMODEALREADYSET
errors = "An attempt was made to set the cooperative level when it was already set to exclusive."
Case DDERR_EXPIRED
errors = "The data has expired and is therefore no longer valid."
Case DDERR_GENERIC
errors = "There is an undefined error condition."
Case DDERR_HEIGHTALIGN
errors = "The height of the provided rectangle is not a multiple of the required alignment."
Case DDERR_HWNDALREADYSET
errors = "The DirectDraw cooperative level window handle has already been set. It cannot be reset while the process has surfaces or palettes created."
Case DDERR_HWNDSUBCLASSED
errors = "DirectDraw is prevented from restoring state because the DirectDraw cooperative level window handle has been subclassed."
Case DDERR_IMPLICITLYCREATED
errors = "The surface cannot be restored because it is an implicitly created surface."
Case DDERR_INCOMPATIBLEPRIMARY
errors = "The primary surface creation request does not match with the existing primary surface."
Case DDERR_INVALIDCAPS
errors = "One or more of the capability bits passed to the callback function are incorrect."
Case DDERR_INVALIDCLIPLIST
errors = "DirectDraw does not support the provided clip list."
Case DDERR_INVALIDDIRECTDRAWGUID
errors = "The globally unique identifier (GUID) passed to the DirectX7.DirectDrawCreate function is not a valid DirectDraw driver identifier."
Case DDERR_INVALIDMODE
errors = "DirectDraw does not support the requested mode."
Case DDERR_INVALIDOBJECT
errors = "DirectDraw received an invalid DirectDraw object."
Case DDERR_INVALIDPARAMS
errors = "One or more of the parameters passed to the method are incorrect."
Case DDERR_INVALIDPIXELFORMAT
errors = "The pixel format was invalid as specified."
Case DDERR_INVALIDPOSITION
errors = "The position of the overlay on the destination is no longer legal."
Case DDERR_INVALIDRECT
errors = "The provided rectangle was invalid."
Case DDERR_INVALIDSTREAM
errors = "The specified stream contains invalid data."
Case DDERR_INVALIDSURFACETYPE
errors = "The requested operation could not be performed because the surface was of the wrong type."
Case DDERR_LOCKEDSURFACES
errors = "One or more surfaces are locked."
Case DDERR_MOREDATA
errors = "There is more data available than the specified buffer size can hold."
Case DDERR_NO3D
errors = "No 3-D hardware or emulation is present."
Case DDERR_NOALPHAHW
errors = "No alpha acceleration hardware is present or available."
Case DDERR_NOBLTHW
errors = "No blitter hardware is present."
Case DDERR_NOCLIPLIST
errors = "No clip list is available."
Case DDERR_NOCLIPPERATTACHED
errors = "No DirectDrawClipper object is attached to the surface object."
Case DDERR_NOCOLORCONVHW
errors = "No Color-conversion hardware is present or available."
Case DDERR_NOCOLORKEY
errors = "The surface does not currently have a Color key."
Case DDERR_NOCOLORKEYHW
errors = "There is no hardware support for the destination Color key."
Case DDERR_NOCOOPERATIVELEVELSET
errors = "A create function was called when the DirectDraw7.SetCooperativeLevel method had not been called."
Case DDERR_NODC
errors = "No DC has ever been created for this surface."
Case DDERR_NODDROPSHW
errors = "No DirectDraw raster operation (ROP) hardware is available."
Case DDERR_NODIRECTDRAWHW
errors = "Hardware-only DirectDraw object creation is not possible; the driver does not support any hardware."
Case DDERR_NODIRECTDRAWSUPPORT
errors = "DirectDraw support is not possible with the current display driver."
Case DDERR_NOEMULATION
errors = "Software emulation is not available."
Case DDERR_NOEXCLUSIVEMODE
errors = "The operation requires the application to have exclusive mode, but the application does not have exclusive mode."
Case DDERR_NOFLIPHW
errors = "Flipping visible surfaces is not supported."
Case DDERR_NOFOCUSWINDOW
errors = "An attempt was made to create or set a device window without first setting the focus window."
Case DDERR_NOGDI
errors = "No GDI is present."
Case DDERR_NOHWND
errors = "Clipper notification requires a window handle, or no window handle was previously set as the cooperative level window handle."
Case DDERR_NOMIPMAPHW
errors = "No mipmap-capable texture mapping hardware is present or available."
Case DDERR_NOMIRRORHW
errors = "No mirroring hardware is present or available."
Case DDERR_NONONLOCALVIDMEM
errors = "An attempt was made to allocate nonlocal video memory from a device that does not support nonlocal video memory."
Case DDERR_NOOPTIMIZEHW
errors = "The device does not support optimized surfaces."
Case DDERR_NOOVERLAYHW
errors = "No overlay hardware is present or available."
Case DDERR_NOPALETTEATTACHED
errors = "No palette object is attached to this surface."
Case DDERR_NOPALETTEHW
errors = "There is no hardware support for 16- or 256-Color palettes."
Case DDERR_NORASTEROPHW
errors = "No appropriate raster operation hardware is present or available."
Case DDERR_NOROTATIONHW
errors = "No rotation hardware is present or available."
Case DDERR_NOSTEREOHARDWARE
errors = "No stereo hardware is present or available."
Case DDERR_NOSTRETCHHW
errors = "There is no hardware support for stretching."
Case DDERR_NOSURFACELEFT
errors = "No hardware is present that supports stereo surfaces."
Case DDERR_NOT4BITCOLOR
errors = "The DirectDrawSurface object is not using a 4-bit Color palette, and the requested operation requires a 4-bit Color palette."
Case DDERR_NOT4BITCOLORINDEX
errors = "The DirectDrawSurface object is not using a 4-bit Color index palette, and the requested operation requires a 4-bit Color index palette."
Case DDERR_NOT8BITCOLOR
errors = "The DirectDrawSurface object is not using an 8-bit Color palette, and the requested operation requires an 8-bit Color palette."
Case DDERR_NOTAOVERLAYSURFACE
errors = "An overlay component was called for a non-overlay surface."
Case DDERR_NOTEXTUREHW
errors = "No texture-mapping hardware is present or available."
Case DDERR_NOTFLIPPABLE
errors = "An attempt was made to flip a surface that cannot be flipped."
Case DDERR_NOTFOUND
errors = "The requested item was not found."
Case DDERR_NOTINITIALIZED
errors = "An attempt was made to call an interface method of a DirectDraw object created by CoCreateInstance before the object was initialised."
Case DDERR_NOTLOADED
errors = "The surface is an optimized surface, but it has not yet been allocated any memory."
Case DDERR_NOTLOCKED
errors = "An attempt was made to unlock a surface that was not locked."
Case DDERR_NOTPAGELOCKED
errors = "An attempt was made to page-unlock a surface with no outstanding page locks."
Case DDERR_NOTPALETTIZED
errors = "The surface being used is not a palette-based surface."
Case DDERR_NOVSYNCHW
errors = "There is no hardware support for vertical blank synchronized operations."
Case DDERR_NOZBUFFERHW
errors = "There is no hardware support for z-buffers."
Case DDERR_NOZOVERLAYHW
errors = "The hardware does not support z-ordering of overlays."
Case DDERR_OUTOFCAPS
errors = "The hardware needed for the requested operation has already been allocated."
Case DDERR_OUTOFMEMORY
errors = "DirectDraw does not have enough memory to perform the operation."
Case DDERR_OUTOFVIDEOMEMORY
errors = "DirectDraw does not have enough display memory to perform the operation."
Case DDERR_OVERLAPPINGRECTS
errors = "The source and destination rectangles are on the same surface and overlap each other."
Case DDERR_OVERLAYCANTCLIP
errors = "The hardware does not support clipped overlays."
Case DDERR_OVERLAYCOLORKEYONLYONEACTIVE
errors = "An attempt was made to have more than one Color key active on an overlay."
Case DDERR_OVERLAYNOTVISIBLE
errors = "The method was called on a hidden overlay."
Case DDERR_PALETTEBUSY
errors = "Access to this palette is refused because the palette is locked by another thread."
Case DDERR_PRIMARYSURFACEALREADYEXISTS
errors = "This process has already created a primary surface."
Case DDERR_REGIONTOOSMALL
errors = "The region passed to the DirectDrawClipper.GetClipList method is too small."
Case DDERR_SURFACEALREADYATTACHED
errors = "An attempt was made to attach a surface to another surface to which it is already attached."
Case DDERR_SURFACEALREADYDEPENDENT
errors = "An attempt was made to make a surface a dependency of another surface on which it is already dependent."
Case DDERR_SURFACEBUSY
errors = "Access to the surface is refused because the surface is locked by another thread."
Case DDERR_SURFACEISOBSCURED
errors = "Access to the surface is refused because the surface is obscured."
Case DDERR_SURFACELOST
errors = "Access to the surface is refused because the surface memory is gone. Call the DirectDrawSurface7.Restore method on this surface to restore the memory associated with it."
Case DDERR_SURFACENOTATTACHED
errors = "The requested surface is not attached."
Case DDERR_TOOBIGHEIGHT
errors = "The height requested by DirectDraw is too large."
Case DDERR_TOOBIGSIZE
errors = "The size requested by DirectDraw is too large. However, the individual height and width are valid sizes."
Case DDERR_TOOBIGWIDTH
errors = "The width requested by DirectDraw is too large."
Case DDERR_UNSUPPORTED
errors = "The operation is not supported."
Case DDERR_UNSUPPORTEDFORMAT
errors = "The FourCC format requested is not supported by DirectDraw."
Case DDERR_UNSUPPORTEDMASK
errors = "The bitmask in the pixel format requested is not supported by DirectDraw."
Case DDERR_UNSUPPORTEDMODE
errors = "The display is currently in an unsupported mode."
Case DDERR_VERTICALBLANKINPROGRESS
errors = "A vertical blank is in progress."
Case DDERR_VIDEONOTACTIVE
errors = "The video port is not active."
Case DDERR_WASSTILLDRAWING
errors = "The previous blit operation that is transferring information to or from this surface is incomplete."
Case DDERR_WRONGMODE
errors = "This surface cannot be restored because it was created in a different mode."
Case DDERR_XALIGN
errors = "The provided rectangle was not horizontally aligned on a required boundary."
Case E_INVALIDINTERFACE
errors = "The specified interface is invalid or does not exist."
Case E_OUTOFMEMORY
errors = "Not enough free memory to complete the method."

Case DI_BUFFEROVERFLOW
errors = "The input buffer overflowed and data was lost."
Case DIERR_ACQUIRED
errors = "The operation cannot be performed while the device is acquired."
Case DIERR_ALREADYINITIALIZED
errors = "This object is already initialised"
Case DIERR_BADDRIVERVER
errors = "The object could not be created due to an incompatible driver version or mismatched or incomplete driver components."
Case DIERR_BETADIRECTINPUTVERSION
errors = "The application was written for an unsupported prerelease version of DirectInput."
Case DIERR_DEVICEFULL
errors = "The device is full."
Case DIERR_DEVICENOTREG
errors = "The device or device instance is not registered with DirectInput. This value is equal to the REGDB_E_CLASSNOTREG standard COM return value."
Case DIERR_EFFECTPLAYING
errors = "The parameters were updated in memory but were not downloaded to the device because the device does not support updating an effect while it is still playing."
Case DIERR_HASEFFECTS
errors = "The device cannot be reinitialised because there are still effects attached to it."
Case DIERR_GENERIC
errors = "An undetermined error occurred inside the DirectInput subsystem. This value is equal to the E_FAIL standard COM return value."
Case DIERR_HANDLEEXISTS
errors = "The device already has an event notification associated with it. This value is equal to the E_ACCESSDENIED standard COM return value."
Case DIERR_INCOMPLETEEFFECT
errors = "The effect could not be downloaded because essential information is missing. For example, no axes have been associated with the effect, or no type-specific information has been supplied."
Case DIERR_INPUTLOST
errors = "Access to the input device has been lost. It must be reacquired."
Case DIERR_INVALIDHANDLE
errors = "An invalid window handle was passed to the method."
Case DIERR_INVALIDPARAM
errors = "An invalid parameter was passed to the returning function, or the object was not in a state that permitted the function to be called. This value is equal to the E_INVALIDARG standard COM return value."
Case DIERR_MOREDATA
errors = "Not all the requested information fitted into the buffer."
Case DIERR_NOAGGREGATION
errors = "This object does not support aggregation."
Case DIERR_NOINTERFACE
errors = "The specified interface is not supported by the object. This value is equal to the E_NOINTERFACE standard COM return value."
Case DIERR_NOTACQUIRED
errors = "The operation cannot be performed unless the device is acquired."
Case DIERR_NOTBUFFERED
errors = "The device is not buffered. Set the DIPROP_BUFFERSIZE property to enable buffering."
Case DIERR_NOTDOWNLOADED
errors = "The effect is not downloaded."
Case DIERR_NOTEXCLUSIVEACQUIRED
errors = "The operation cannot be performed unless the device is acquired in DISCL_EXCLUSIVE mode."
Case DIERR_NOTINITIALIZED
errors = "The object has not been initialised."
Case DIERR_NOTFOUND
errors = "The requested object does not exist."
Case DIERR_OBJECTNOTFOUND
errors = "The requested object does not exist."
Case DIERR_OLDDIRECTINPUTVERSION
errors = "The application requires a newer version of DirectInput."
Case DIERR_OTHERAPPHASPRIO
errors = "Another application has a higher priority level, preventing this call from succeeding. This value is equal to the E_ACCESSDENIED standard COM return value. This error can be returned when an application has only foreground access to a device but is attempting to acquire the device while in the background."
Case DIERR_OUTOFMEMORY
errors = "The DirectInput subsystem couldn't allocate sufficient memory to complete the call. This value is equal to the E_OUTOFMEMORY standard COM return value."
Case DIERR_READONLY
errors = "The specified property cannot be changed. This value is equal to the E_ACCESSDENIED standard COM return value."
Case DIERR_REPORTFULL
errors = "More information was requested to be sent than can be sent to the device."
Case DIERR_UNPLUGGED
errors = "The operation could not be completed because the device is not plugged in."
Case DIERR_UNSUPPORTED
errors = "The function called is not supported at this time. This value is equal to the E_NOTIMPL standard COM return value."
Case E_PENDING
errors = "Data is not yet available."

'
Case DPNERR_ABORTED
errors = "The operation was canceled before it could be completed."
Case DPNERR_ADDRESsinG
errors = "The address specified is invalid."
Case DPNERR_ALREADYCONNECTED
errors = "The object is already connected to the session."
Case DPNERR_ALREADYCLOsinG
errors = "An attempt to call Close on a session has been made more than once."
Case DPNERR_ALREADYDISCONNECTING
errors = "The client is already disconnecting from the session."
Case DPNERR_ALREADYINITIALIZED
errors = "The object has already been initialised."
Case DPNERR_ALREADYREGISTERED
errors = "A message handler has already been registered. You must unregister the current handler before registering a new one."
Case DPNERR_BUFFERTOOSMALL
errors = "The supplied buffer is not large enough to contain the requested data."
Case DPNERR_CANNOTCANCEL
errors = "The operation could not be canceled."
Case DPNERR_CANTCREATEGROUP
errors = "A new group cannot be created."
Case DPNERR_CANTCREATEPLAYER
errors = "A new player cannot be created."
Case DPNERR_CANTLAUNCHAPPLICATION
errors = "The lobby cannot launch the specified application."
Case DPNERR_CONNECTING
errors = "The method is in the process of connecting to the network."
Case DPNERR_CONNECTIONLOST
errors = "The service provider connection was reset while data was being sent."
Case DPNERR_DOESNOTEXIST
errors = "Requested element is not part of the address."
Case DPNERR_EXCEPTION
errors = "An exception occurred when processing the request."
Case DPNERR_GENERIC
errors = "An undefined error condition occurred."
Case DPNERR_GROUPNOTEMPTY
errors = "The specified group is not empty."
Case DPNERR_HOSTING
errors = "Hosting Error"
Case DPNERR_HOSTREJECTEDCONNECTION
errors = "The connection request was rejected. Check the ReplyData member of the DPNMSG_CONNECT_COMPLETE type for details."
Case DPNERR_HOSTTERMINATEDSESSION
errors = "The host terminated the session."
Case DPNERR_INCOMPLETEADDRESS
errors = "The address specified is not complete."
Case DPNERR_INVALIDADDRESSFORMAT
errors = "The address format is invalid."
Case DPNERR_INVALIDAPPLICATION
errors = "The GUID supplied for the application is invalid."
Case DPNERR_INVALIDCOMMAND
errors = "The command specified is invalid."
Case DPNERR_INVALIDFLAGS
errors = "The flags passed to this method are invalid."
Case DPNERR_INVALIDGROUP
errors = "The group ID is not recognized as a valid group ID for this game session."
Case DPNERR_INVALIDHANDLE
errors = "The handle specified is invalid."
Case DPNERR_INVALIDINSTANCE
errors = "The GUID for the application instance is invalid."
Case DPNERR_INVALIDINTERFACE
errors = "The interface parameter is invalid. This value will be returned in a connect request if the connecting player was not a client in a client/server game or a peer in a peer-to-peer game."
Case DPNERR_INVALIDLOCALADDRESS
errors = "The address for the local computer or adapter is invalid."
Case DPNERR_INVALIDOBJECT
errors = "The DirectPlay object pointer is invalid."
Case DPNERR_INVALIDPARAM
errors = "One or more of the parameters passed to the method are invalid."
Case DPNERR_INVALIDPASSWORD
errors = "An invalid password was supplied when attempting to join a session that requires a password."
Case DPNERR_INVALIDPLAYER
errors = "The player ID is not recognized as a valid player ID for this game session."
Case DPNERR_INVALIDPOINTER
errors = "Pointer specified as a parameter is invalid."
Case DPNERR_INVALIDPRIORITY
errors = "The specified priority is not within the range of allowed priorities, which is inclusively from 0 through 65535."
Case DPNERR_INVALIDSTRING
errors = "String specified as a parameter is invalid."
Case DPNERR_INVALIDREMOTEADDRESS
errors = "The specified remote address is invalid."
Case DPNERR_INVALIDURL
errors = "Specified string is not a valid DirectPlay URL."
Case DPNERR_INVALIDVERSION
errors = "There was an attempt to connect to an invalid version of DirectPlay."
Case DPNERR_NOCAPS
errors = "The communication link that DirectPlay is attempting to use is not capable of this function."
Case DPNERR_NOCONNECTION
errors = "No communication link was established."
Case DPNERR_NOHOSTPLAYER
errors = "There is currently no player acting as the host of the session."
Case DPNERR_NOINTERFACE
errors = "The interface is not supported."
Case DPNERR_NORESPONSE
errors = "There was no response from the specified target."
Case DPNERR_NOTALLOWED
errors = "The object is read-only; this function is not allowed on this object."
Case DPNERR_NOTHOST
errors = "The client attempted to connect to a nonhost computer. Additionally, this error value may be returned by a nonhost that tried to set the application description."
Case DPNERR_OUTOFMEMORY
errors = "There is insufficient memory to perform the requested operation."
Case DPNERR_PENDING
errors = "Not an error, this return indicates that an asynchronous operation has reached the point where it is successfully queued."
Case DPNERR_PLAYERLOST
errors = "A player has lost the connection to the session."
Case DPNERR_SENDTOOLARGE
errors = "The buffer was too large."
Case DPNERR_SESSIONFULL
errors = "The request to connect to the host or server failed because the maximum number of players allotted for the session has been reached."
Case DPNERR_TIMEDOUT
errors = "The operation could not complete because it has timed out."
Case DPNERR_UNINITIALIZED
errors = "The requested object has not been initialised."
Case DPNERR_UNSUPPORTED
errors = "The function or feature is not available in this implementation or on this service provider."
Case DPNERR_USERCANCEL
errors = "The user canceled the operation."
Case DV_OK
errors = "The request completed successfully."
Case DV_FULLDUPLEX
errors = "The sound card is capable of full-duplex operation."
Case DV_HALFDUPLEX
errors = "The sound card can be run only in half-duplex mode."
Case DVERR_BUFFERTOOSMALL
errors = "The supplied buffer is not large enough to contain the requested data."
Case DVERR_EXCEPTION
errors = "An exception occurred when processing the request."
Case DVERR_GENERIC
errors = "An undefined error condition occurred."
Case DVERR_INVALIDFLAGS
errors = "The flags passed to this method are invalid."
Case DVERR_INVALIDOBJECT
errors = "The DirectPlay object pointer is invalid."
Case DVERR_INVALIDPARAM
errors = "One or more of the parameters passed to the method are invalid."
Case DVERR_INVALIDPLAYER
errors = "The player ID is not recognized as a valid player ID for this game session."
Case DVERR_INVALIDGROUP
errors = "The group ID is not recognized as a valid group ID for this game session."
Case DVERR_INVALIDHANDLE
errors = "The handle specified is invalid."
Case DVERR_OUTOFMEMORY
errors = "There is insufficient memory to perform the requested operation."
Case DVERR_PENDING
errors = "Not an error, this return indicates that an asynchronous operation has reached the point where it is successfully queued."
Case DVERR_NOTSUPPORTED
errors = "The operation is not supported."
Case DVERR_NOINTERFACE
errors = "The specified interface is not supported. This error could indicate that you are using an earlier version of DirectX that does not expose the interface."
Case DVERR_SESSIONLOST
errors = "The transport has lost the connection to the session."
Case DVERR_NOVOICESESSION
errors = "The session specified is not a voice session."
Case DVERR_CONNECTIONLOST
errors = "The connection to the voice session has been lost."
Case DVERR_NOTINITIALIZED
errors = "The DirectPlayVoiceClient8.initialize or DirectPlayVoiceServer8.Initialize method must be called before calling this method."
Case DVERR_CONNECTED
errors = "The DirectPlay Voice object is connected."
Case DVERR_NOTCONNECTED
errors = "The DirectPlay Voice object is not connected."
Case DVERR_CONNECTABORTING
errors = "The connection is being disconnected."
Case DVERR_NOTALLOWED
errors = "The object does not have the permission to perform this operation."
Case DVERR_INVALIDTARGET
errors = "The specified target is not a valid player ID or group ID for this voice session."
Case DVERR_TRANSPORTNOTHOST
errors = "The object is not the host of the voice session."
Case DVERR_COMPRESSIONNOTSUPPORTED
errors = "The specified compression type is not supported on the local computer."
Case DVERR_ALREADYPENDING
errors = "An asynchronous call of this type is already pending."
Case DVERR_ALREADYINITIALIZED
errors = "The object has already been initialised."
Case DVERR_SOUNDINITFAILURE
errors = "A failure was encountered initialising the sound card."
Case DVERR_TIMEOUT
errors = "The operation could not be performed in the specified time."
Case DVERR_CONNECTABORTED
errors = "The connect operation was canceled before it could be completed."
Case DVERR_NO3DSOUND
errors = "The local computer does not support 3-D sound."
Case DVERR_ALREADYBUFFERED
errors = "There is already a user buffer for the specified ID."
Case DVERR_NOTBUFFERED
errors = "There is no user buffer for the specified ID."
Case DVERR_HOSTING
errors = "The object is the host of the session."
Case DVERR_NOTHOSTING
errors = "The object is not the host of the session."
Case DVERR_INVALIDDEVICE
errors = "The specified device is invalid."
Case DVERR_RECORDSYSTEMERROR
errors = "An error in the recording system occurred."
Case DVERR_PLAYBACKSYSTEMERROR
errors = "An error in the playback system occurred."
Case DVERR_SENDERROR
errors = "An error occurred while sending data."
Case DVERR_USERCANCEL
errors = "The user canceled the operation."
Case DVERR_UNKNOWN
errors = "An unknown error occurred."
Case DVERR_RUNSETUP
errors = "The specified audio configuration has not been tested. Call the DirectPlayVoiceTest8.CheckAudioSetup method."
Case DVERR_INCOMPATIBLEVERSION
errors = "The client connected to a voice session that is incompatible with the host."
Case DVERR_INITIALIZED
errors = "The initialise method failed because the object has already been initialised."
Case DVERR_INVALIDPOINTER
errors = "The pointer specified is invalid."
Case DVERR_NOTRANSPORT
errors = "The specified object is not a valid transport."
Case DVERR_NOCALLBACK
errors = "This operation cannot be performed because no callback function was specified."
Case DVERR_TRANSPORTNOTINIT
errors = "The specified transport is not yet initialised."
Case DVERR_TRANSPORTNOSESSION
errors = "The specified transport is valid but is not connected/hosting."
Case DVERR_TRANSPORTNOPLAYER
errors = "The specified transport is connected/hosting but no local player exists."
'''''''''''' directdraw
Case DD_OK
errors = "The request completed successfully."
Case DDERR_ALREADYINITIALIZED
errors = "The object has already been initialised."
Case DDERR_BLTFASTCANTCLIP
errors = "A DirectDrawClipper object is attached to a source surface that has passed into a call to the DirectDrawSurface7.BltFast method."
Case DDERR_CANNOTATTACHSURFACE
errors = "A surface cannot be attached to another requested surface."
Case DDERR_CANNOTDETACHSURFACE
errors = "A surface cannot be detached from another requested surface."
Case DDERR_CANTCREATEDC
errors = "Windows cannot create any more device contexts (DCs), or a DC was requested for a palette-indexed surface when the surface had no palette and the display mode was not palette-indexed (in this case DirectDraw cannot select a proper palette into the DC)."
Case DDERR_CANTDUPLICATE
errors = "Primary and 3-D surfaces, or surfaces that are implicitly created, cannot be duplicated."
Case DDERR_CANTLOCKSURFACE
errors = "Access to this surface is refused because an attempt was made to lock the primary surface without DCI support."
Case DDERR_CANTPAGELOCK
errors = "An attempt to page-lock a surface failed. Page lock does not work on a display-memory surface or an emulated primary surface."
Case DDERR_CANTPAGEUNLOCK
errors = "An attempt to page-unlock a surface failed. Page unlock does not work on a display-memory surface or an emulated primary surface."
Case DDERR_CLIPPERISUSINGHWND
errors = "An attempt was made to set a clip list for a DirectDrawClipper object that is already monitoring a window handle."
Case DDERR_COLORKEYNOTSET
errors = "No source Color key is specified for this operation."
Case DDERR_CURRENTLYNOTAVAIL
errors = "No support is currently available."
Case DDERR_DCALREADYCREATED
errors = "A device context (DC) has already been returned for this surface. Only one DC can be retrieved for each surface."
Case DDERR_DEVICEDOESNTOWNSURFACE
errors = "Surfaces created by one DirectDraw device cannot be used directly by another DirectDraw device."
Case DDERR_DIRECTDRAWALREADYCREATED
errors = "A DirectDraw object representing this driver has already been created for this process."
Case DDERR_EXCEPTION
errors = "An exception was encountered while performing the requested operation."
Case DDERR_EXCLUSIVEMODEALREADYSET
errors = "An attempt was made to set the cooperative level when it was already set to exclusive."
Case DDERR_EXPIRED
errors = "The data has expired and is therefore no longer valid."
Case DDERR_GENERIC
errors = "There is an undefined error condition."
Case DDERR_HEIGHTALIGN
errors = "The height of the provided rectangle is not a multiple of the required alignment."
Case DDERR_HWNDALREADYSET
errors = "The DirectDraw cooperative level window handle has already been set. It cannot be reset while the process has surfaces or palettes created."
Case DDERR_HWNDSUBCLASSED
errors = "DirectDraw is prevented from restoring state because the DirectDraw cooperative level window handle has been subclassed."
Case DDERR_IMPLICITLYCREATED
errors = "The surface cannot be restored because it is an implicitly created surface."
Case DDERR_INCOMPATIBLEPRIMARY
errors = "The primary surface creation request does not match with the existing primary surface."
Case DDERR_INVALIDCAPS
errors = "One or more of the capability bits passed to the callback function are incorrect."
Case DDERR_INVALIDCLIPLIST
errors = "DirectDraw does not support the provided clip list."
Case DDERR_INVALIDDIRECTDRAWGUID
errors = "The globally unique identifier (GUID) passed to the DirectX7.DirectDrawCreate function is not a valid DirectDraw driver identifier."
Case DDERR_INVALIDMODE
errors = "DirectDraw does not support the requested mode."
Case DDERR_INVALIDOBJECT
errors = "DirectDraw received an invalid DirectDraw object."
Case DDERR_INVALIDPARAMS
errors = "One or more of the parameters passed to the method are incorrect."
Case DDERR_INVALIDPIXELFORMAT
errors = "The pixel format was invalid as specified."
Case DDERR_INVALIDPOSITION
errors = "The position of the overlay on the destination is no longer legal."
Case DDERR_INVALIDRECT
errors = "The provided rectangle was invalid."
Case DDERR_INVALIDSTREAM
errors = "The specified stream contains invalid data."
Case DDERR_INVALIDSURFACETYPE
errors = "The requested operation could not be performed because the surface was of the wrong type."
Case DDERR_LOCKEDSURFACES
errors = "One or more surfaces are locked."
Case DDERR_MOREDATA
errors = "There is more data available than the specified buffer size can hold."
Case DDERR_NO3D
errors = "No 3-D hardware or emulation is present."
Case DDERR_NOALPHAHW
errors = "No alpha acceleration hardware is present or available."
Case DDERR_NOBLTHW
errors = "No blitter hardware is present."
Case DDERR_NOCLIPLIST
errors = "No clip list is available."
Case DDERR_NOCLIPPERATTACHED
errors = "No DirectDrawClipper object is attached to the surface object."
Case DDERR_NOCOLORCONVHW
errors = "No Color-conversion hardware is present or available."
Case DDERR_NOCOLORKEY
errors = "The surface does not currently have a Color key."
Case DDERR_NOCOLORKEYHW
errors = "There is no hardware support for the destination Color key."
Case DDERR_NOCOOPERATIVELEVELSET
errors = "A create function was called when the DirectDraw7.SetCooperativeLevel method had not been called."
Case DDERR_NODC
errors = "No DC has ever been created for this surface."
Case DDERR_NODDROPSHW
errors = "No DirectDraw raster operation (ROP) hardware is available."
Case DDERR_NODIRECTDRAWHW
errors = "Hardware-only DirectDraw object creation is not possible; the driver does not support any hardware."
Case DDERR_NODIRECTDRAWSUPPORT
errors = "DirectDraw support is not possible with the current display driver."
Case DDERR_NOEMULATION
errors = "Software emulation is not available."
Case DDERR_NOEXCLUSIVEMODE
errors = "The operation requires the application to have exclusive mode, but the application does not have exclusive mode."
Case DDERR_NOFLIPHW
errors = "Flipping visible surfaces is not supported."
Case DDERR_NOFOCUSWINDOW
errors = "An attempt was made to create or set a device window without first setting the focus window."
Case DDERR_NOGDI
errors = "No GDI is present."
Case DDERR_NOHWND
errors = "Clipper notification requires a window handle, or no window handle was previously set as the cooperative level window handle."
Case DDERR_NOMIPMAPHW
errors = "No mipmap-capable texture mapping hardware is present or available."
Case DDERR_NOMIRRORHW
errors = "No mirroring hardware is present or available."
Case DDERR_NONONLOCALVIDMEM
errors = "An attempt was made to allocate nonlocal video memory from a device that does not support nonlocal video memory."
Case DDERR_NOOPTIMIZEHW
errors = "The device does not support optimized surfaces."
Case DDERR_NOOVERLAYHW
errors = "No overlay hardware is present or available."
Case DDERR_NOPALETTEATTACHED
errors = "No palette object is attached to this surface."
Case DDERR_NOPALETTEHW
errors = "There is no hardware support for 16- or 256-Color palettes."
Case DDERR_NORASTEROPHW
errors = "No appropriate raster operation hardware is present or available."
Case DDERR_NOROTATIONHW
errors = "No rotation hardware is present or available."
Case DDERR_NOSTEREOHARDWARE
errors = "No stereo hardware is present or available."
Case DDERR_NOSTRETCHHW
errors = "There is no hardware support for stretching."
Case DDERR_NOSURFACELEFT
errors = "No hardware is present that supports stereo surfaces."
Case DDERR_NOT4BITCOLOR
errors = "The DirectDrawSurface object is not using a 4-bit Color palette, and the requested operation requires a 4-bit Color palette."
Case DDERR_NOT4BITCOLORINDEX
errors = "The DirectDrawSurface object is not using a 4-bit Color index palette, and the requested operation requires a 4-bit Color index palette."
Case DDERR_NOT8BITCOLOR
errors = "The DirectDrawSurface object is not using an 8-bit Color palette, and the requested operation requires an 8-bit Color palette."
Case DDERR_NOTAOVERLAYSURFACE
errors = "An overlay component was called for a non-overlay surface."
Case DDERR_NOTEXTUREHW
errors = "No texture-mapping hardware is present or available."
Case DDERR_NOTFLIPPABLE
errors = "An attempt was made to flip a surface that cannot be flipped."
Case DDERR_NOTFOUND
errors = "The requested item was not found."
Case DDERR_NOTINITIALIZED
errors = "An attempt was made to call an interface method of a DirectDraw object created by CoCreateInstance before the object was initialised."
Case DDERR_NOTLOADED
errors = "The surface is an optimized surface, but it has not yet been allocated any memory."
Case DDERR_NOTLOCKED
errors = "An attempt was made to unlock a surface that was not locked."
Case DDERR_NOTPAGELOCKED
errors = "An attempt was made to page-unlock a surface with no outstanding page locks."
Case DDERR_NOTPALETTIZED
errors = "The surface being used is not a palette-based surface."
Case DDERR_NOVSYNCHW
errors = "There is no hardware support for vertical blank synchronized operations."
Case DDERR_NOZBUFFERHW
errors = "There is no hardware support for z-buffers."
Case DDERR_NOZOVERLAYHW
errors = "The hardware does not support z-ordering of overlays."
Case DDERR_OUTOFCAPS
errors = "The hardware needed for the requested operation has already been allocated."
Case DDERR_OUTOFMEMORY
errors = "DirectDraw does not have enough memory to perform the operation."
Case DDERR_OUTOFVIDEOMEMORY
errors = "DirectDraw does not have enough display memory to perform the operation."
Case DDERR_OVERLAPPINGRECTS
errors = "The source and destination rectangles are on the same surface and overlap each other."
Case DDERR_OVERLAYCANTCLIP
errors = "The hardware does not support clipped overlays."
Case DDERR_OVERLAYCOLORKEYONLYONEACTIVE
errors = "An attempt was made to have more than one Color key active on an overlay."
Case DDERR_OVERLAYNOTVISIBLE
errors = "The method was called on a hicase DDen overlay."
Case DDERR_PALETTEBUSY
errors = "Access to this palette is refused because the palette is locked by another thread."
Case DDERR_PRIMARYSURFACEALREADYEXISTS
errors = "This process has already created aprimary surface."
Case DDERR_REGIONTOOSMALL
errors = "The region passed to the DirectDrawClipper.GetClipList method is too small."
Case DDERR_SURFACEALREADYATTACHED
errors = "An attempt was made to attach a surface to another surface to which it is already attached."
Case DDERR_SURFACEALREADYDEPENDENT
errors = "An attempt was made to make a surface a dependency of another surface on which it is already dependent."
Case DDERR_SURFACEBUSY
errors = "Access to the surface is refused because the surface is locked by another thread."
Case DDERR_SURFACEISOBSCURED
errors = "Access to the surface is refused because the surface is obscured."
Case DDERR_SURFACELOST
errors = "Access to the surface is refused because the surface memory is gone. Call the DirectDrawSurface7.Restore method on this surface to restore the memory associated with it."
Case DDERR_SURFACENOTATTACHED
errors = "The requested surface is not attached."
Case DDERR_TOOBIGHEIGHT
errors = "The height requested by DirectDraw is too large."
Case DDERR_TOOBIGSIZE
errors = "The size requested by DirectDraw is too large. However, the individual height and width are valid sizes."
Case DDERR_TOOBIGWIDTH
errors = "The width requested by DirectDraw is too large."
Case DDERR_UNSUPPORTED
errors = "The operation is not supported."
Case DDERR_UNSUPPORTEDFORMAT
errors = "The FourCC format requested is not supported by DirectDraw."
Case DDERR_UNSUPPORTEDMASK
errors = "The bitmask in the pixel format requested is not supported by DirectDraw."
Case DDERR_UNSUPPORTEDMODE
errors = "The display is currently in an unsupported mode."
Case DDERR_VERTICALBLANKINPROGRESS
errors = "A vertical blank is in progress."
Case DDERR_VIDEONOTACTIVE
errors = "The video port is not active."
Case DDERR_WASSTILLDRAWING
errors = "The previous blit operation that is transferring information to or from this surface is incomplete."
Case DDERR_WRONGMODE
errors = "This surface cannot be restored because it was created in a different mode."
Case DDERR_XALIGN
errors = "The provided rectangle was not horizontally aligned on a required boundary."
Case E_INVALIDINTERFACE
errors = "The specified interface is invalid or does not exist."
Case E_OUTOFMEMORY
errors = "Not enough free memory to complete the method."
End Select
End Function
