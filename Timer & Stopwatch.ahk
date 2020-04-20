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
        testing
        check feature parity against old script
            notably graying out gui buttons and such
        close github issues
        disable #SingleInstance for compiled script
*/
#SingleInstance, force
global g_nullTime := A_YYYY A_MM A_DD 00 00 00  ; used by timestamp related command eg. EnvAdd, FormatTime
global stopwatch := new class_stopwatch
global timer := new class_timer
global TrackTime := new class_trackTime
global g_debug := false
If (g_debug) {
    Gosub debug
    return
}

classInstance := new guiMainClass
classInstance.Setup()
return

~^s::reload
#Include, <class gui>
#Include, %A_ScriptDir%\inc
#Include, class guiMain.ahk
#Include, class stopwatch.ahk
#Include, class timer.ahk
#Include, class trackTime.ahk
#Include, functions.ahk
#Include, subroutines.ahk