class guiMainClass extends gui {
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

        ; controls
        this.Font("s1")
        this.Add("Text", "x0 y0 w65 h23 Border Center cSilver gguiMain_BtnHandler")
        this.Font("")
        
        this.Add("Text", "x4 y4 w60 BackGroundTrans", "Timer")
        this.Add("Button", "x68 y0 h23 w23 gguiMain_BtnHandler", "+")
        this.Add("Button", "x94 y0 h23 w23 gguiMain_BtnHandler", "-")
        this.Add("Button", "x120 y0 h23 w23 gguiMain_BtnHandler", "X")


        this.Font("s25")
        this.Add("Text", "x5 w135 Center gguiMain_BtnHandler", "00:00:00")
        this.Font("")
        
        this.Add("Button", "x5 w65 gguiMain_BtnHandler", "Start")
        this.Add("Button", "x+5 w65 gguiMain_BtnHandler", "Reset")

        ; show
        this.Show()

        
    }

    MoveGui() { ; use wm_mousemove event to drag gui over both text timer and text border controls
        msgbox % A_ThisFunc
        PostMessage, 0xA1, 2,,, A
    }

    AlwaysOnTop() {
        msgbox % A_ThisFunc
    }

    Minimize() {
        msgbox % A_ThisFunc
    }

    SetTarget() {
        msgbox % A_ThisFunc
    }

    Start() {
        msgbox % A_ThisFunc
    }

    Reset() {
        msgbox % A_ThisFunc
    }

    Close() {
        msgbox % A_ThisFunc
    }    
}

guiMain_BtnHandler:
    MouseGetPos, , , , OutputVarControlClassNN, 0 ; get control classNN
    ControlGetText, OutputControlText , % OutputVarControlClassNN, A
    OutputControlText := StrReplace(OutputControlText, A_Space)

    If InStr(OutputControlText, ":") ; handle the ever changing digit text control
        OutputControlText := "Digits"
    
    ; msgbox % A_ThisLabel ": _Btn" OutputControlText ; debug - view called method

    ; call the class's method
    for a, b in guiMainClass.Instances 
		if (a = A_Gui+0)
			b["Events"]["_Btn" OutputControlText].Call()
return

guiMain_HotkeyEnter:
	; call the class's method
    for a, b in guiMainClass.Instances 
		if (a = WinExist("A")+0) ; if instance gui hwnd is identical to currently active window hwnd
			b["Events"]["_HotkeyEnter"].Call()
return