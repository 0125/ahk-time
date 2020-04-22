/*
    Todo
        gui
            write guis into classes - check sm-manageClips for code
                add display gui
                    create function with only the basic gui controls
                    then add functionality to each button one by one
                add set target gui
                    class class_timer SetTarget() - add target gui
        class class_timer add checks for starting timer without target set?
        gui main
            add timer renaming
            ability to move the gui
        testing
        check feature parity against old script
            notably graying out gui buttons and such
        close github issues
        disable #SingleInstance for compiled script
*/
#SingleInstance, force
; OnMessage(0x201, "WM_LBUTTONDOWN") ; WM_LBUTTONDOWN := 0x201 
; OnMessage(0x204, "WM_RBUTTONDOWN") ; WM_RBUTTONDOWN := 0x204 

global g_nullTime := A_YYYY A_MM A_DD 00 00 00  ; used by timestamp related command eg. EnvAdd, FormatTime
global g_mode := "stopwatch"                ; timer or stopwatch
global mainGui := new guiMainClass
global stopwatch := new class_stopwatch
global timer := new class_timer
global TrackTime := new class_trackTime
global g_debug := false
If (g_debug) {
    Gosub debug
    return
}
mainGui.Setup()
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

    mainGui.SetText("Static2", input)
}

~^s::reload
#Include, <class gui>
#Include, %A_ScriptDir%\inc
#Include, class guiMain.ahk
#Include, class stopwatch.ahk
#Include, class timer.ahk
#Include, class trackTime.ahk
#Include, functions.ahk
#Include, subroutines.ahk