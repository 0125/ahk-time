/*
    Todo
        enable #SingleInstance Off for compiled script and force for uncompiled
*/
#SingleInstance Off
#Include *i fileInstallList.ahk
If (A_IsCompiled)
    Menu, Tray, Icon , % A_ScriptDir "\res\icon.ico"
OnMessage(0x201, "WM_LBUTTONDOWN") ; WM_LBUTTONDOWN := 0x201 
OnMessage(0x204, "WM_RBUTTONDOWN") ; WM_RBUTTONDOWN := 0x204 

global g_nullTime := A_YYYY A_MM A_DD 00 00 00  ; used by timestamp related command eg. EnvAdd, FormatTime
global g_mode := "timer"                ; timer or stopwatch
global mainGui := new guiMainClass
global setTargetGui := new guiSetTargetClass
global stopwatch := new class_stopwatch
global timer := new class_timer
global TrackTime := new class_trackTime
global g_debug := false
setTargetGui.Setup() ; create target gui, hidden
If (g_debug) {
    Gosub debug
    return
}
mainGui.Setup() ; show main gui
return

WM_LBUTTONDOWN() {
    control := getMouseControl()
    if !InStr(control, "Static1") and !InStr(control, "Static2")
        return

    PostMessage, 0xA1, 2,,, A
}

WM_RBUTTONDOWN() {
    control := getMouseControl()
    if !InStr(control, "Static1") and !InStr(control, "Static2")
        return

    InputBox, input, Set title, Please enter a new title , , 240, 130
    if (ErrorLevel)
        return ; CANCEL was pressed.

    mainGui.SetText("Static2", input) ; title bar
}

#If !(A_IsCompiled)
~^s::reload
#If
#Include, <class gui>
#Include, %A_ScriptDir%\inc
#Include, class guiMain.ahk
#Include, class guiSetTarget.ahk
#Include, class stopwatch.ahk
#Include, class timer.ahk
#Include, class trackTime.ahk
#Include, functions.ahk
#Include, subroutines.ahk