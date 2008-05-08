Attribute VB_Name = "modXPControls"
Option Explicit

Private Const ICC_USEREX_CLASSES = &H200

Private Type INITCOMMONCONTROLSTYPE
   dwSize As Long
   dwICC As Long
End Type

Private Declare Function InitCommonControlsEx Lib "comctl32.dll" ( _
                iccex As INITCOMMONCONTROLSTYPE) _
                As Boolean
Private Declare Function SetParent Lib "user32.dll" ( _
                ByVal hWndChild As Long, _
                ByVal hWndNewParent As Long) _
                As Long
Private Declare Function LockWindowUpdate Lib "user32.dll" ( _
                ByVal hwndLock As Long) _
                As Long

Public Sub Main()
   On Error Resume Next
   Dim uICC As INITCOMMONCONTROLSTYPE
   
   With uICC
       .dwSize = LenB(uICC)
       .dwICC = ICC_USEREX_CLASSES
   End With
   InitCommonControlsEx uICC

   On Error GoTo 0
   frmMain.Show

End Sub

