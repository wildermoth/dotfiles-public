; F23 top row: close/focus/cycle tabs.

F23 & SC010:: ; TAB + Q (Numpad Escape)
    Send {Blind}{CtrlDown}{w}{CtrlUp}
    MarkTabUsed()
return
F23 & SC011:: ; TAB + W
    MarkTabUsed()
    Send {Blind}{CtrlDown}{l}{CtrlUp}
return
F23 & SC012:: ; TAB + F
    MarkTabUsed()
    Send {Blind}{CtrlDown}{ShiftDown}{Tab}{ShiftUp}{CtrlUp}
    return
F23 & SC013:: ; TAB + P
    MarkTabUsed()
    Send {Blind}{CtrlDown}{Tab}{CtrlUp}
return
F23 & SC014:: ; TAB + B
    MarkTabUsed()
    Send {Blind}{CtrlDown}{t}{CtrlUp}
return
F23 & SC015:: ; TAB + [
    MarkTabUsed()
return

; Tab layer numpad (top row: JLUY)
F23 & SC016::
    MarkTabUsed()
    Send {Blind}{-} ; J = minus
return
F23 & SC017::
    MarkTabUsed()
    Send {Blind}{7} ; L = 7
return
F23 & SC018::
    MarkTabUsed()
    Send {Blind}{8} ; U = 8
return
F23 & SC019::
    MarkTabUsed()
    Send {Blind}{9} ; Y = 9
return
