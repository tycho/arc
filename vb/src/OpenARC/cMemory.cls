VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "cMemory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'===============================================================================
' cMemory - class to employ SIMD based memory routines. If the processor doesn't
'           support MMX/SSE then we seemlessly fallback to the regular API
'
Option Explicit

Public Enum eSIMD_Support
  esNone = 0
  esMMX
  esSSE
  esSSE2
  esSSE3
End Enum

Private Declare Sub RtlMoveMemory Lib "kernel32" (Destination As Any, Source As Any, ByVal Length As Long)
Private Declare Sub RtlFillMemory Lib "kernel32" (Destination As Any, ByVal Length As Long, ByVal Fill As Byte)

Private Const CODE_SIMD_LVL As String = "9C580FBAF815509D9C5A31D0740431C0EB2753B8010000000FA231C00FBAE2177316400FBAE219730F400FBAE21A7308400FBAE1007301405B8B542408890231C0C20800"
Private Const CODE_COPY_MMX As String = "56578B7C24108B7424148B4C241889C829F929C183E10729C87E210F77F3A489C183E007C1E903741329F70F6F060F7F043783C6084975F301F70F7701C1F3A45F5EC21000"
Private Const CODE_COPY_SSE As String = "56578B7C24108B7424148B4C241889C829F929C183E10F29C87E230F77F3A489C183E00FC1E904741529F7660F6F06660F7F043783C6104975F10F7701F701C1F3A45F5EC21000"
Private Const CODE_FILL_MMX As String = "578B7C240C8B4424108B54241489D1C1E10809CA89D1C1E21009CA89F983E10729C8E30A881783C70183E90175F689C183E007C1E90374180F7752520F6F042483C4080F7F0783C70883E90175F50F7789C1E30A881783C70183E90175F65FC21000"
Private Const CODE_FILL_SSE As String = "578B7C240C8B4424108B54241489D1C1E10809CA89D1C1E21009CA89F983E10F29C8E30A881783C70183E90175F689C183E00FC1E904741B0F7752525252660F6F042483C4100F7F0783C71083E90175F50F7789C1E30A881783C70183E90175F65FC21000"

Private pMe     As Long     'Address of this class instance's vtable
Private nEntry  As Long     'vtable entry index
Private sCode() As String   'Machine code lives here

Private Sub Class_Initialize()
  Dim nSIMD As eSIMD_Support
  
  Call RtlMoveMemory(pMe, ByVal ObjPtr(Me), 4)  'Get the address of this class instance's vtable
  
  'Patch the SIMD_Support function
  Call Redirect(CODE_SIMD_LVL)
  
  nSIMD = SIMD_Support
  
  If nSIMD >= esSSE Then
  
    'If we have SSE or better support then use the SSE (128 bit) register supporting code
    Call Redirect(CODE_COPY_SSE)
    
    'There may be an issue with SSE FillMemory on early P4's so I'm commenting it out for the moment
    'Call Redirect(CODE_FILL_SSE)
    Call Redirect(CODE_FILL_MMX)
    
  ElseIf nSIMD = esMMX Then
  
    'If MMX is the best we have, then use the MMX (64 bit) register supporting code
    Call Redirect(CODE_COPY_MMX)
    Call Redirect(CODE_FILL_MMX)
    
  Else
  
    'No MMX/SSE support, don't patch the vtables, leave the api calls in-place.
  End If
End Sub

'Return the level of SIMD support
Public Function SIMD_Support() As eSIMD_Support
End Function

'If MMX/SSE is present then this sub is patched with either the MMX or SSE RtlMoveMemory replacement machine code.
'If MMX/SSE isn't present then the sub isn't patched and stays as below.... seemlessly falls back to the api call
Public Sub CopyMemory(ByVal Source As Long, ByVal Destination As Long, ByVal Length As Long)
  Call RtlMoveMemory(ByVal Source, ByVal Destination, Length)
End Sub

'If MMX/SSE is present then this sub is patched with either the MMX or SSE RtlFillMemory replacement machine code.
'If MMX/SSE isn't present then the sub isn't patched and stays as below.... seemlessly falls back to the api call
Public Sub FillMemory(ByVal Source As Long, ByVal Length As Long, ByVal Fill As Byte)
  Call RtlFillMemory(ByVal Source, Length, Fill)
End Sub

Private Sub Redirect(ByVal sHexCode As String)
  Dim i     As Long
  Dim nLen  As Long
  Dim s     As String
  
  nLen = Len(sHexCode)
  
  For i = 1 To nLen Step 2
    s = s & ChrB$(Val("&H" & Mid$(sHexCode, i, 2)))
  Next i
  
  ReDim Preserve sCode(0 To nEntry)
  sCode(nEntry) = s
  Call RtlMoveMemory(ByVal pMe + &H1C + (nEntry * 4), StrPtr(sCode(nEntry)), 4)
  nEntry = nEntry + 1
End Sub
