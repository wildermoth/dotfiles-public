; F24 digit row: app switch + reload.
F24 & SC001::
    MarkCapsUsed() ; Esc
return
F24 & SC029::
    MarkCapsUsed()
    Reload ; `
return
F24 & SC002::
    MarkCapsUsed()
    SwitchToWindow("ahk_exe alacritty.exe", 3) ; 1 = Alacritty
return
F24 & SC003::
    MarkCapsUsed()
    SwitchToWindow("Google Chrome", 3) ; 2 = Chrome
return
F24 & SC004::
    MarkCapsUsed()
    SwitchToWindow("ahk_class CabinetWClass", 3) ; 3 = File Explorer
return
F24 & SC005::
    MarkCapsUsed()
    SwitchToWindow("Messenger", 2) ; 4
return
F24 & SC006::
    MarkCapsUsed()
    Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{5}{AltUp}{ShiftUp}{CtrlUp} ; 5
return
F24 & SC007::
    MarkCapsUsed()
    Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{6}{AltUp}{ShiftUp}{CtrlUp} ; 6
return
F24 & SC008::
    MarkCapsUsed()
    Send {Blind}{CtrlDown}{ShiftDown}{AltDown}{7}{AltUp}{ShiftUp}{CtrlUp} ; =
return
F24 & SC009::
    MarkCapsUsed()
    Send {Blind}{7} ; 7
return
F24 & SC00A::
    MarkCapsUsed()
    Send {Blind}{8} ; 8
return
F24 & SC00B::
    MarkCapsUsed()
    Send {Blind}{9} ; 9
return
F24 & SC00C::
    MarkCapsUsed()
    Send {Blind}{0} ; 0
return
F24 & SC00D::
    MarkCapsUsed()
    Send {Blind}{-} ; -
return
