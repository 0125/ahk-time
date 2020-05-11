; get user integer input
class class_inputGui extends gui {
    Get(previousInput := "") {
        DetectHiddenWindows, On
        mainGui.Options("+Disabled") ; disable main gui

        this.SetText("Edit1", previousInput) ; set edit field to previous target if available
        this.SelectText("Edit1") ; focus edit field & select text

        ; prevent mainGui from being hidden behind other windows by making it alwaysontop if not already
        WinGet, ExStyle, ExStyle, % mainGui.ahkid
        if !(ExStyle & 0x8) { ; 0x8 is WS_EX_TOPMOST.
            mainGuiAlwaysOnTop := true
            mainGui.Options("+AlwaysOnTop")
        }
        this.Options("+Owner" mainGui.hwnd)
        
        ; show target gui on top of mainGui
        ControlGetPos, cX, cY, cW, cH, Static3, % "ahk_id " mainGui.hwnd
        WinGetPos, wX, wY, wW, wH, % "ahk_id " mainGui.hwnd
        this.Pos(wX + cX, wY + cY)

        ; wait for user to close gui
        DetectHiddenWindows, Off ; gui gets hidden instead of closed
        WinWaitClose, % "ahk_id " this.hwnd ; wait for gui to close
        DetectHiddenWindows, On

        ; re-enable mainGui
        this.Options("-Owner" mainGui.hwnd)
        If (mainGuiAlwaysOnTop) ; restore alwaysontop setting
            mainGui.Options("-AlwaysOnTop")
        mainGui.Options("-Disabled") ; re-enable main gui
        return this.GetText("Edit1")
    }

    Setup() {
        ; hotkeys
        HotKey, IfWinExist, % "ahk_id " this.hwnd
        Hotkey, Enter, inputGui_HotkeyEnter
        Hotkey, Escape, inputGui_HotkeyEscape
        HotKey, IfWinExist

        ; events
        this.Events["Close"] := this.Close.Bind(this)
        this.Events["_TargetUpdate"] := this.TargetUpdate.Bind(this)
        this.Events["_HotkeyEnter"] := this._HotkeyEnter.Bind(this)
        this.Events["_HotkeyEscape"] := this.Close.Bind(this)
        
        ; properties
        this.Margin(0, 0)
        this.Options("+LabelinputGui_")
        this.Options("+AlwaysOnTop")
        this.Options("+ToolWindow")
        this.Options("-Border")

        ; controls
        this.Font("s13")
        this.Add("Edit", "w130 Center Number Limit6")
        this.Font("")
    }

    _HotkeyEnter() {
        this.Hide()
    }

    Close() {
        this.Hide()
        this.SetText("Edit1", "") ; reset input
    }
}

inputGui_HotkeyEnter:
    ; call the class's method
    for a, b in class_inputGui.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_HotkeyEnter"].Call()
return

inputGui_HotkeyEscape:
    ; call the class's method
    for a, b in class_inputGui.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_HotkeyEscape"].Call()
return