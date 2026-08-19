; F23 home row: same modifiers as Caps.
F23 & SC01E::
    MarkTabUsed()
    Send {Blind}{AltDown} ; A down
return
F23 & SC01F::
    MarkTabUsed()
    Send {Blind}{CtrlDown} ; R down
return
F23 & SC020::
    MarkTabUsed()
    Send {Blind}{ShiftDown} ; S down
return
F23 & SC021::
    MarkTabUsed()
    Send {Blind}{CtrlDown} ; T down
return

; Tab layer modifier release
F23 & SC01E up::
    MarkTabUsed()
    Send {Blind}{AltUp} ; A up
return
F23 & SC01F up::
    MarkTabUsed()
    Send {Blind}{CtrlUp} ; R up
return
F23 & SC020 up::
    MarkTabUsed()
    Send {Blind}{ShiftUp} ; S up
return
F23 & SC021 up::
    MarkTabUsed()
    Send {Blind}{CtrlUp} ; T up
return

; Tab layer numpad (middle row: MNEI)
F23 & SC023::
    MarkTabUsed() ; ]
    Send {Blind}{[}{]}{Left} ; 9
return
F23 & SC024::
    MarkTabUsed()
    Send {Blind}{=} ; M = equals
return
F23 & SC025::
    MarkTabUsed()
    Send {Blind}{4} ; N = 4
return
F23 & SC026::
    MarkTabUsed()
    Send {Blind}{5} ; E = 5
return
F23 & SC027::
    MarkTabUsed()
    Send {Blind}{6} ; I = 6
return
F23 & SC028::
    MarkTabUsed()
    Send {Blind}{Backspace} ; O = backspace
return
