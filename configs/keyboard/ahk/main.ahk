; Windows AutoHotkey: dual-role Caps/Tab extend layers.
; Source fragments: split/. Windows dest folder stays
; extend_layer_wide_std_split/ so these #Include paths match the copy.
#SingleInstance, Force

#InstallKeybdHook
#KeyHistory
SetTitleMatchMode, 2

; Track whether dual-role keys were used as modifiers
tabSolo := false
capsSolo := false
capsExtendActive := false
tabSkipExtend := false  ; when true, Tab up should do nothing (used for Shift+Tab passthrough)
lastToggle := 0  ; debounce timestamp for Caps-hold+F1 CapsLock toggle
switchCycleTitle := ""
switchCycleIds := []
switchCyclePos := 0
switchLastId := 0
switchOrders := {}    ; title -> ordered window IDs array (per-title, persists across minimizes)
switchLastIds := {}   ; title -> last window ID activated for that title (per-title)
switchPrevWindows := {}  ; title -> window active before the cycle started (unslotted = restore on cycle end)

#InputLevel 1
; Dual-role CapsLock: tap = Ctrl+S, hold = extend (F24)
*CapsLock::
    if IsExtendExcluded() {
        capsSolo := false
        capsExtendActive := false
        return
    }
    capsSolo := true
    capsExtendActive := true
    Send {F24 down}
return

*CapsLock up::
    if (capsExtendActive) {
        Send {F24 up}
        capsExtendActive := false
    }
    if (capsSolo)
        Send ^s
return

; Dual-role Tab: tap = Tab, hold = extend (F23)
*Tab::
    ; If any modifier is already held, pass Tab through so combos like Alt+Tab/Win+Tab work
    if (GetKeyState("Shift", "P")
        || GetKeyState("Ctrl", "P")
        || GetKeyState("Alt", "P")
        || GetKeyState("LWin", "P")
        || GetKeyState("RWin", "P")) {
        Send {Blind}{Tab}
        tabSolo := false
        tabSkipExtend := true
        return
    }
    if IsExtendExcluded() {
        Send {Blind}{Tab down}
        Sleep, 80
        Send {Blind}{Tab up}
        tabSolo := false
        tabSkipExtend := true
        return
    }
    tabSolo := true
    Send {F23 down}
return

*Tab up::
    if (tabSkipExtend) {
        tabSkipExtend := false
        return
    }
    Send {F23 up}
    if (tabSolo)
        Send {Tab}
return
#InputLevel 0

#Persistent
SetCapsLockState, AlwaysOff

#Include %A_ScriptDir%/extend_layer_wide_std_split/tab_misc.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/caps_digit.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/tab_digit.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/caps_top.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/tab_top.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/caps_home.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/tab_home.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/caps_bottom.ahk
#Include %A_ScriptDir%/extend_layer_wide_std_split/tab_bottom.ahk

; --- Extend layer exclusions ---
IsExtendExcluded() {
    exes := ["MonsterHunterWorld.exe"]
    Loop % exes.Length()
        if WinActive("ahk_exe " . exes[A_Index])
            return true
    return false
}

; --- Dual-role helper flags ---
MarkTabUsed() {
    global tabSolo
    tabSolo := false
}

MarkCapsUsed() {
    global capsSolo
    capsSolo := false
}

; Window switching helpers
GetWindowCenter(hwnd, ByRef cx, ByRef cy)
{
    WinGet, tMinMax, MinMax, ahk_id %hwnd%
    if (tMinMax = -1) {
        VarSetCapacity(wp, 44, 0)
        NumPut(44, wp, 0, "UInt")
        if (DllCall("GetWindowPlacement", "ptr", hwnd, "ptr", &wp)) {
            left := NumGet(wp, 28, "Int")
            top := NumGet(wp, 32, "Int")
            right := NumGet(wp, 36, "Int")
            bottom := NumGet(wp, 40, "Int")
            cx := left + (right-left)/2
            cy := top + (bottom-top)/2
            return true
        }
    }
    WinGetPos, x, y, w, h, ahk_id %hwnd%
    if (x = "")
        return false
    cx := x + w/2
    cy := y + h/2
    return true
}

; Explorer restores last-focused control (address bar / nav tree / etc).
; Shell Document.Focus() targets the items pane; control names are a fallback.
FocusExplorerFileList(hwnd)
{
    for window in ComObjCreate("Shell.Application").Windows
    {
        try {
            if (window.HWND != hwnd + 0)
                continue
            window.Document.Focus()
            return
        } catch e {
        }
    }
    parseList := "DirectUIHWND3|DirectUIHWND2|SysListView321"
    Loop, Parse, parseList, |
    {
        ControlGet, hwndCtl, Hwnd,, %A_LoopField%, ahk_id %hwnd%
        if (!hwndCtl)
            continue
        ControlFocus, %A_LoopField%, ahk_id %hwnd%
        return
    }
}

SwitchToWindow(title, monitor)
{
    global switchCycleTitle, switchCycleIds, switchCyclePos, switchLastId, switchOrders, switchLastIds, switchPrevWindows
    SetWinDelay, -1

    ; Monitor bounds (target-only)
    SysGet, WorkArea, MonitorWorkArea, %monitor%

    ; Collect matching windows on target monitor
    targetIds := []
    WinGet, winList, List, %title%
    Loop, %winList%
    {
        thisID := winList%A_Index%
        WinGetTitle, tTitle, ahk_id %thisID%
        if (tTitle = "")
            continue

        WinGetClass, thisClass, ahk_id %thisID%
        if (thisClass = "Progman" || thisClass = "WorkerW" || thisClass = "Shell_TrayWnd")
            continue

        if (!GetWindowCenter(thisID, midX, midY))
            continue

        if (midX >= WorkAreaLeft && midX <= WorkAreaRight && midY >= WorkAreaTop && midY <= WorkAreaBottom)
            targetIds.Push(thisID)
    }

    if (targetIds.Length() = 0)
        return

    ; Build ordered list from per-title saved order, then any new windows from Z-order
    orderedIds := []
    titleOrder := switchOrders[title]
    if (IsObject(titleOrder))
    {
        Loop % titleOrder.Length()
        {
            candidate := titleOrder[A_Index]
            Loop % targetIds.Length()
            {
                if (targetIds[A_Index] = candidate)
                {
                    orderedIds.Push(candidate)
                    break
                }
            }
        }
    }
    Loop % targetIds.Length()
    {
        candidate := targetIds[A_Index]
        known := false
        Loop % orderedIds.Length()
        {
            if (orderedIds[A_Index] = candidate)
            {
                known := true
                break
            }
        }
        if (!known)
            orderedIds.Push(candidate)
    }

    WinGet, activeId, ID, A

    continuing := (activeId = switchLastId && title = switchCycleTitle)

    activeInList := false
    Loop % orderedIds.Length()
    {
        if (orderedIds[A_Index] = activeId) {
            activeInList := true
            break
        }
    }

    if (continuing) {
        nextPos := switchCyclePos + 1
        if (nextPos > switchCycleIds.Length()) {
            EndCycleRestore(activeId, title)
            return
        }
        targetWindow := switchCycleIds[nextPos]
        switchCyclePos := nextPos
    } else if (activeInList) {
        switchCycleIds := orderedIds
        switchCycleTitle := title
        foundPos := 1
        Loop % switchCycleIds.Length()
        {
            if (switchCycleIds[A_Index] = activeId)
            {
                foundPos := A_Index
                break
            }
        }
        nextPos := foundPos + 1
        if (nextPos > switchCycleIds.Length()) {
            EndCycleRestore(activeId, title)
            return
        }
        targetWindow := switchCycleIds[nextPos]
        switchCyclePos := nextPos
    } else {
        ; Rotate orderedIds to start from this title's last activated window.
        ; After minimize switchLastIds[title]=0 so no rotation — persists locked order.
        titleLastId := switchLastIds[title]
        startPos := 1
        if (titleLastId != 0)
        {
            Loop % orderedIds.Length()
            {
                if (orderedIds[A_Index] = titleLastId)
                {
                    startPos := A_Index
                    break
                }
            }
        }
        rotatedIds := []
        idx := startPos
        Loop % orderedIds.Length()
        {
            rotatedIds.Push(orderedIds[idx])
            idx++
            if (idx > orderedIds.Length())
                idx := 1
        }
        switchCycleIds := rotatedIds
        switchOrders[title] := rotatedIds
        switchCycleTitle := title
        switchCyclePos := 1
        targetWindow := switchCycleIds[1]
        switchPrevWindows[title] := activeId
    }

    ; 1. Force Restore if Minimized
    WinGet, tMinMax, MinMax, ahk_id %targetWindow%
    if (tMinMax = -1)
        WinRestore, ahk_id %targetWindow%

    ; 2. Activate
    WinActivate, ahk_id %targetWindow%

    ; 3. Minimize everything else on target monitor
    WinGet, allWinList, List
    Loop, %allWinList%
    {
        thisID := allWinList%A_Index%
        if (thisID = targetWindow)
            continue

        WinGetClass, thisClass, ahk_id %thisID%
        if (thisClass = "Progman" || thisClass = "WorkerW" || thisClass = "Shell_TrayWnd")
            continue

        ; Exclude launchers and accessibility tools from minimization
        WinGet, processName, ProcessName, ahk_id %thisID%
        if (processName = "Raycast.exe"
            || processName = "PowerToys.exe"
            || processName = "Flow.Launcher.exe"
            || processName = "Keypirinha.exe"
            || InStr(processName, "uiAccess"))
            continue

        if (!GetWindowCenter(thisID, midX, midY))
            continue

        ; Check if center is within monitor bounds
        if (midX >= WorkAreaLeft && midX <= WorkAreaRight && midY >= WorkAreaTop && midY <= WorkAreaBottom)
            WinMinimize, ahk_id %thisID%
    }

    ; 4. Position target window if needed
    WinGetPos, tX, tY, tW, tH, ahk_id %targetWindow%
    tcX := tX + (tW/2)
    tcY := tY + (tH/2)

    ; Update state after activation
    WinGet, tMinMax, MinMax, ahk_id %targetWindow%

    ; If off-monitor
    if (tcX < WorkAreaLeft || tcX > WorkAreaRight || tcY < WorkAreaTop || tcY > WorkAreaBottom) {
        ; Only restore if we absolutely have to (to move it)
        if (tMinMax = 1)
            WinRestore, ahk_id %targetWindow%

        ; Move to top-left of monitor (preserve size)
        WinMove, ahk_id %targetWindow%,, WorkAreaLeft, WorkAreaTop

        ; Maximize
        WinMaximize, ahk_id %targetWindow%
    }
    else if (tMinMax != 1) {
        ; If on-monitor but not maximized
        WinMaximize, ahk_id %targetWindow%
    }

    WinActivate, ahk_id %targetWindow%
    WinGetClass, targetClass, ahk_id %targetWindow%
    if (targetClass = "CabinetWClass")
        FocusExplorerFileList(targetWindow)
    switchLastId := targetWindow
    switchLastIds[title] := targetWindow
    return
}

EndCycleRestore(activeId, title)
{
    global switchCycleTitle, switchLastId, switchLastIds, switchOrders, switchPrevWindows
    prevWin := switchPrevWindows[title]
    switchCycleTitle := ""
    switchLastId := 0
    switchLastIds[title] := 0
    switchPrevWindows[title] := 0
    WinMinimize, ahk_id %activeId%
    if (prevWin = 0)
        return
    isSlotted := false
    For k, arr in switchOrders
    {
        if (!IsObject(arr))
            continue
        Loop % arr.Length()
        {
            if (arr[A_Index] = prevWin)
            {
                isSlotted := true
                break
            }
        }
        if (isSlotted)
            break
    }
    if (!isSlotted)
    {
        WinGet, pMinMax, MinMax, ahk_id %prevWin%
        if (pMinMax = -1)
            WinRestore, ahk_id %prevWin%
        WinActivate, ahk_id %prevWin%
    }
}
