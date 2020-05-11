; misc
    #SingleInstance Off
    OnMessage(0x201, "WM_LBUTTONDOWN") ; WM_LBUTTONDOWN := 0x201 
    OnMessage(0x204, "WM_RBUTTONDOWN") ; WM_RBUTTONDOWN := 0x204 
    OnMessage(0x111, "WM_COMMAND") ; WM_COMMAND := 0x111 detect edit field losing focus

; global vars
    global g_nullTime := A_YYYY A_MM A_DD 00 00 00  ; used by timestamp related command eg. EnvAdd, FormatTime
    global g_mode := "stopwatch"                ; timer or stopwatch
    global mainGui := new class_mainGuiClass
    global inputGui := new class_inputGui
    global stopwatch := new class_stopwatch
    global timer := new class_timer
    global TrackTime := new class_trackTime
    global g_debug := false

; autoexec
    inputGui.Setup() ; create target gui, hidden
    If (g_debug) {
        Gosub debug
        return
    }
    mainGui.Setup() ; show main gui
return

; global hotkeys
    #If !(A_IsCompiled)
    ~^s::reload
    #If

; includes
    #Include, <class gui>
    #Include, %A_ScriptDir%\inc
    #Include, class gui main.ahk
    #Include, class gui input.ahk
    #Include, class stopwatch.ahk
    #Include, class timer.ahk
    #Include, class trackTime.ahk
    #Include, functions.ahk
    #Include, subroutines.ahk