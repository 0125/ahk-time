class guiSetTargetClass extends gui {
    GetTarget(previousTarget := "") {
        mainGui.Options("+Disabled") ; disable main gui

        this.SetText("Edit1", previousTarget) ; set edit field to previous target if available
        ControlSend, Edit1, ^a, % "ahk_id " this.hwnd ; select edit field text

        ; show target gui on top of guiMain
        ControlGetPos, cX, cY, cW, cH, Static3, % "ahk_id " mainGui.hwnd
        WinGetPos, wX, wY, wW, wH, % "ahk_id " mainGui.hwnd
        this.Pos(wX + cX, wY + cY)

        DetectHiddenWindows, Off ; gui gets hidden instead of closed
        WinWaitClose, % "ahk_id " this.hwnd ; wait for gui to close
        this.TargetUpdate() ; set this.outputSeconds incase not set already

        mainGui.Options("-Disabled") ; re-enable main gui
        return this.outputSeconds ; return input, if any
    }

    Setup() {
        DetectHiddenWindows, Off
        HotKey, IfWinExist, % "ahk_id " this.hwnd
        Hotkey, Enter, guiSetTargetClass_HotkeyEnter
        Hotkey, Escape, guiSetTargetClass_HotkeyEscape
        HotKey, IfWinExist

        ; events
        this.Events["Close"] := this.Close.Bind(this)
        this.Events["_TargetUpdate"] := this.TargetUpdate.Bind(this)
        this.Events["_HotkeyEnter"] := this._HotkeyEnter.Bind(this)
        this.Events["_HotkeyEscape"] := this.Close.Bind(this)
        
        ; properties
        this.Margin(0, 0)
        this.Options("+LabelguiSetTargetClass_")
        this.Options("+AlwaysOnTop")
        this.Options("+ToolWindow")
        this.Options("-Border")

        ; controls
        this.Font("s13")
        this.Add("Edit", "w130 Center Number Limit6 gguiSetTargetClass_TargetUpdate", "")
        ; this.Font("s20")
        ; this.Add("Edit", "w122 Center Number Limit6 gguiSetTargetClass_TargetUpdate", "45")
        ; this.Add("Edit", "w122 Center Number ReadOnly", "00:00:00")
        this.Font("")

        ; show
        ; If (g_debug)
        ;     this.Pos(1565, 5)
        ; this.Show()
    }

    TargetUpdate() {
        DetectHiddenWindows, On
        inputTarget := this.GetText("Edit1")

        ; modify target to be compatible with FormatTime
        loop, {
            loop, parse, inputTarget ; count total input digits
                count := A_Index
            If (count < 6) ; if less than 6 digits, add a 0 infront
                inputTarget := 0 inputTarget
            else
                break ; end loop when 6 digits are available
        }

        ; calculate target seconds
        loop, parse, inputTarget
        {
            currentDigits .= A_LoopField
            If (A_Index = 2) { ; hours
                outputSeconds += currentDigits * 3600
                currentDigits := ""
            }
            If (A_Index = 4) { ; minutes
                outputSeconds += currentDigits * 60
                currentDigits := ""
            }
            If (A_Index = 6) { ; seconds
                outputSeconds += currentDigits
                currentDigits := ""
            }
        }

        this.SetText("Edit2", FormatTimeSeconds(outputSeconds))
        this.outputSeconds := outputSeconds
    }

    _HotkeyEnter() {
        this.Hide()
    }

    Close() {
        this.Hide()
        this.SetText("Edit1", "") ; reset input
    }
}

guiSetTargetClass_TargetUpdate:
    ; call the class's method
    for a, b in guiMainClass.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_TargetUpdate"].Call()
return

guiSetTargetClass_HotkeyEnter:
    setTargetGui._HotkeyEnter()
    return

    ; call the class's method
    for a, b in guiMainClass.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_HotkeyEnter"].Call()
return

guiSetTargetClass_HotkeyEscape:
	setTargetGui.Close()
    return

    ; call the class's method
    for a, b in guiMainClass.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_HotkeyEscape"].Call()
return