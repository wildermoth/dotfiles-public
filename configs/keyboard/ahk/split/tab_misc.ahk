; F23 F-keys: F1 toggles CapsLock.
F23 & F1::
    MarkTabUsed()
    ; Toggle CapsLock once per chord; KeyWait blocks repeat while held
    SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
    KeyWait, F1
return
