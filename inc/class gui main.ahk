class class_mainGuiClass extends gui {
    Setup() {
        ; events
        this.Events["Close"] := this.Close.Bind(this)
        this.Events["_Btn+"] := this.AlwaysOntop.Bind(this)
        this.Events["_Btn-"] := this.Minimize.Bind(this)
        this.Events["_BtnX"] := this.Close.Bind(this)
        this.Events["_BtnDigits"] := this.SetTarget.Bind(this)
        this.Events["_BtnStart"] := this.Start.Bind(this)
        this.Events["_BtnReset"] := this.Reset.Bind(this)
        
        ; properties
        this.Margin(5, 5)
        this.Options("-border")
        this.Options("+LabelmainGui_")

        ; controls
        this.Font("s1")
        this.Add("Text", "x0 y0 w65 h23 Border Center cSilver gmainGui_BtnHandler")
        this.Font("")
        
        this.Add("Text", "x4 y4 w60 BackGroundTrans", "Timer")
        this.Add("Button", "x68 y0 h23 w23 gmainGui_BtnHandler", "+")
        this.Add("Button", "x94 y0 h23 w23 gmainGui_BtnHandler", "-")
        this.Add("Button", "x120 y0 h23 w23 gmainGui_BtnHandler", "X")


        this.Font("s25")
        this.Add("Text", "x5 w135 Center gmainGui_BtnHandler", "00:00:00")
        this.Font("")
        
        this.Add("Button", "x5 w65 gmainGui_BtnHandler", "Start")
        this.Add("Button", "x+5 w65 gmainGui_BtnHandler", "Reset")

        ; show
        If (g_debug)
            this.Pos(1640, 5)
        this.Show()
        If (g_mode = "timer")
            this.SetTarget()
        return
    }

    MoveGui() { ; wm_mousemove event is used since this method was causing issues
        msgbox % A_ThisFunc
        PostMessage, 0xA1, 2,,, A
    }

    AlwaysOnTop() {
        WinSet, AlwaysOnTop, Toggle, % "ahk_id " this.hwnd
    }

    Minimize() {
        WinMinimize, % "ahk_id " this.hwnd
    }

    SetTarget() {
        If !(g_mode = "timer")
            return
        
        ; get user input target
        target := inputGui.Get(%g_mode%.target)
        If !(target)
            return

        ; modify target to be compatible with FormatTime
        loop, {
            loop, parse, target ; count total input digits
                count := A_Index
            If (count < 6) ; if less than 6 digits, add a 0 infront
                target := 0 target
            else
                break ; end loop when 6 digits are available
        }

        ; check if target exceeds maximum allowed by ahk timestamp commands
        If (target > 235959) {
            msgbox, 4160, , %A_ThisFunc%: Exceeded maximum input of 235959!
            target := 235959
        }

        ; calculate target seconds
        loop, parse, target
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

        %g_mode%.SetTarget(outputSeconds)
    }

    SetTargetUntill() {
        ; get user input target
        target := inputGui.Get()
        If !(target)
            return

        ; modify target to be compatible with FormatTime
        loop, {
            loop, parse, target ; count total input digits
                count := A_Index
            If (count < 6) ; if less than 6 digits, add a 0
                target := target 0
            else
                break ; end loop when 6 digits are available
        }

        futureStamp := A_YYYY A_MM A_DD target
        differenceSeconds := futureStamp
        EnvSub, differenceSeconds, A_Now, Seconds

        If (differenceSeconds <= 0)
            differenceSeconds := 1

        %g_mode%.SetTarget(differenceSeconds)

        mainGui.SetText("Static3", FormatTimeSeconds(differenceSeconds))
        mainGui.SetText("Static2", "Until " input) ; title bar

        %g_mode%.Start() ; start counting down to set time
    }

    Start() {
        %g_mode%.Start()
    }

    Reset() {
        %g_mode%.Reset()
    }

    Stop() {
        %g_mode%.Stop()
    }

    Close() {
        exitapp
    }    
}

mainGui_BtnHandler:
    OutputControlText := getMouseControl("retrieveControlText")

    If InStr(OutputControlText, ":") ; handle the ever changing digit text control
        OutputControlText := "Digits"
    
    ; msgbox % A_ThisLabel ": _Btn" OutputControlText ; debug - view called method

    ; call the class's method
    for a, b in class_mainGuiClass.Instances 
		if (a = A_Gui+0)
			b["Events"]["_Btn" OutputControlText].Call()
return

mainGui_HotkeyEnter:
	; call the class's method
    for a, b in class_mainGuiClass.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_HotkeyEnter"].Call()
return

mainGui_ContextMenu:
    If !(getMouseControl() = "Static3") ; only continue if right clicked on digits
        return
    
    ; reset menu
    Menu, menuChooseMode, Add, dummyHandler
    Menu, menuChooseMode, DeleteAll

    ; menu items
    Menu, menuChooseMode, Add, Timer, menuChooseMode_Timer
    Menu, menuChooseMode, Add, Timer until ..., menuChooseMode_TimerUntil
    Menu, menuChooseMode, Add, Stopwatch, menuChooseMode_Stopwatch

    Menu, menuChooseMode, Check, % g_mode ; check current mode

    ; show menu
    Menu, menuChooseMode, Show
return

menuChooseMode_Stopwatch:
    mainGui.Stop()
    g_mode := "stopwatch"
    mainGui.SetText("Static3", "00:00:00") ; reset main gui
return

menuChooseMode_Timer:
    mainGui.Stop()
    g_mode := "timer"
    mainGui.SetTarget()
return

menuChooseMode_TimerUntil:
    mainGui.Pause()
    g_mode := "timer"
    mainGui.SetTargetUntill()
return