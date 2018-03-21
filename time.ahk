#Include, %A_ScriptDir%\inc
#Include, guiDisplay.ahk
#Include, guiTarget.ahk

global g_mode				; timer/stopwatch
global g_target				; timer target
global g_nullTime			; various uses

g_nullTime := A_YYYY A_MM A_DD 00 00 00

; g_target := A_YYYY A_MM A_DD 01 11 11
g_mode := "stopwatch"
guiDisplay("00:00:00")
; guiTarget()
return

TimeTimer:
	Time()
return

Time(reset = "") {
	static now, previous_now, secondsPassed
	
	If (reset) {
		secondsPassed := ""
		return
	}
	
	now := A_Now
	If (now = previous_now)
		return
	
	secondsPassed++
	
	If (g_mode = "stopwatch") { 
		stopwatch_passedTime := g_nullTime
		EnvAdd, stopwatch_passedTime, secondsPassed, Seconds
		FormatTime, output, % stopwatch_passedTime, HH:mm:ss
	}
	
	If (g_mode = "timer") {
		targetRemaining := g_target
		EnvAdd, targetRemaining, % - secondsPassed, Seconds
		FormatTime, output, % targetRemaining, HH:mm:ss
		
		If (targetRemaining = g_nullTime)
		{
			SetTimer, TimeTimer, Off
			guiDisplay(output)
			alarm("on")
			return
		}
	}
	
	guiDisplay(output)
	
	previous_now := now
}

hk_start:
	SetTimer, TimeTimer, On
return

hk_stop:
	SetTimer, TimeTimer, Off
return

hk_reset:
	SetTimer, TimeTimer, Off
	
	Time("reset")

	alarm()
	
	If (g_mode = "stopwatch")
		guiDisplay("00:00:00")
	
	If (g_mode = "timer") and (g_target) {
		FormatTime, output, % g_target, HH:mm:ss
		guiDisplay(output)
	}
return

alarm(on = "") {
	static alarmOff
	
	If !(on)
		alarmOff := 1
	
	If (on) {
		alarmOff := 0
		loop {
			SoundBeep, 2200, 125
			count++
			If (count = 4)
			{
				count = ""
				sleep 400
			}
		} until alarmOff
	}
}

moveGui:
	PostMessage, 0xA1, 2,,, A
return

#IfWinActive, ahk_exe Notepad++.exe
~^s::reload