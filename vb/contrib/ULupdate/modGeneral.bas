Attribute VB_Name = "modGeneral"
Public DLFile() As String
'Public Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
Public Declare Function SystemParametersInfo Lib "user32" Alias "SystemParametersInfoA" (ByVal uAction As Long, ByVal uParam As Long, ByRef lpvParam As Any, ByVal fuWinIni As Long) As Long
Public Const SPI_GETWORKAREA = 48
Declare Function SetWindowPos Lib "user32" (ByVal hwnd As Long, ByVal hWndInsertAfter As Long, ByVal X As Long, ByVal Y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
Global Const conHwndTopmost = -1
Global Const conSwpNoActivate = &H10
Global Const conSwpShowWindow = &H40
Type RECT
    Left As Long
    Top As Long
    Right As Long
    Bottom As Long
End Type

Public Function DSplit(Expression As Variant, FirstDelimeter As String, SecondDelimeter As String)
    Dim A
    A = Split(Expression, FirstDelimeter)
    DSplit = Split(A(1), SecondDelimeter)
End Function

Public Function GetFileW(URL As Variant) As String
    Dim A
    'Debug.Print URL
    A = Split(StrReverse(URL), "/")
    Dim B
    B = A(0)
    GetFileW = StrReverse(B)
End Function

Public Function GetFile(Path As String) As String
    Dim A
    A = Split(StrReverse(Path), "\")
    Dim B
    B = A(0)
    GetFile = StrReverse(B)
End Function

