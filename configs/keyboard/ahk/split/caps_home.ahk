; F24 home row: Alt/Ctrl/Shift.
F24 & SC01E::
    MarkCapsUsed()
    Send {Blind}{AltDown} ; A down
return
F24 & SC01F::
    MarkCapsUsed()
    Send {Blind}{CtrlDown} ; R down
return
F24 & SC020::
    MarkCapsUsed()
    Send {Blind}{ShiftDown} ; S down
return
F24 & SC021::
    MarkCapsUsed()
    Send {Blind}{CtrlDown} ; T down
return
F24 & SC022::
    MarkCapsUsed()
    Send {Blind}{AltDown}{ShiftDown} ; G down
return

F24 & SC023::
    MarkCapsUsed() ; ]
return
F24 & SC024::
    MarkCapsUsed()
    Send {Blind}{PgDn} ; M
return
F24 & SC025::
    MarkCapsUsed()
    Send {Blind}{Left} ; N
return
F24 & SC026::
    MarkCapsUsed()
    Send {Blind}{Down} ; E
return
F24 & SC027::
    MarkCapsUsed()
    Send {Blind}{Right} ; I
return
F24 & SC028::
    MarkCapsUsed()
    Send {Blind}{Backspace} ; O
return

; Modifier release
F24 & SC01E up::
    MarkCapsUsed()
    Send {Blind}{AltUp} ; A up
return
F24 & SC01F up::
    MarkCapsUsed()
    Send {Blind}{CtrlUp} ; R up
return
F24 & SC020 up::
    MarkCapsUsed()
    Send {Blind}{ShiftUp} ; S up
return
F24 & SC021 up::
    MarkCapsUsed()
    Send {Blind}{CtrlUp} ; T up
return
F24 & SC022 up::
    MarkCapsUsed()
    Send {Blind}{AltUp}{ShiftUp} ; G up
return
