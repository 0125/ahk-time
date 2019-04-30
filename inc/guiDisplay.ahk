guiDisplay(input = "") {
	static _guiDisplay_digits
	global guiDisplay_title
	
	If (_guiDisplay_digits) and (input)	{
		GuiControl display: , % _guiDisplay_digits, % input
		return
	}
	If (_guiDisplay_digits)
		return
	
	; properties
	gui Display: new
	gui Display: margin, 5, 5
	gui Display: +LabelguiDisplay_ +Hwnd_guiDisplay -Border
	
	; controls
	gui Display: font, s30 verdana
	; gui Display: add, Progress, x0 y0 w65 h23 cGray, 100
	; gui Display: add, Text, x0 y-20 w20 h20 cGray Border gguiDisplay_moveGui, ██████████████
	gui Display: add, Text, x0 y0 w65 h23 Border cGray gguiDisplay_moveGui
	gui Display: font
	
	gui Display: add, Text, x4 y4 w60 BackGroundTrans vguiDisplay_title, Timer
	gui Display: add, Button, x0 y0 w0 h0
	gui Display: add, Button, x68 y0 h23 w23 gguiDisplay_alwaysontop, +
	gui Display: add, Button, x94 y0 h23 w23 gguiDisplay_minimize, -
	gui Display: add, Button, x120 y0 h23 w23 gguiDisplay_close, X
	
	gui Display: font, s25 verdana
	gui Display: add, text, x5 w135 Center gguiDisplay_setTimer hwnd_guiDisplay_digits, 00:00:00
	gui Display: font
	
	gui Display: add, button, x5 w65 gguiDisplay_button, Start
	gui Display: add, button, x+5 w65 gguiDisplay_reset, Reset
	
	Gosub guiDisplay_reset
	
	; show
	gui Display: show, w145, Stopwatch
	WinWaitClose, % "ahk_id " _guiDisplay
	exitapp

	guiDisplay_moveGui:
		PostMessage, 0xA1, 2,,, A
	return
	
	guiDisplay_close:
		exitapp
	return
	
	guiDisplay_minimize:
		WinMinimize
	return
	
	guiDisplay_alwaysontop:
		WinSet, AlwaysOnTop, Toggle
	return
	
	guiDisplay_button:
		If (A_GuiControl = "Start") {
			GuiControl display: , Button1, Stop
			Gosub hk_start
		}
		else If (A_GuiControl = "Stop") {
			GuiControl display: , Button1, Continue
			Gosub hk_stop
		}
		else If (A_GuiControl = "Continue") {
			GuiControl display: , Button1, Stop
			Gosub hk_start
		}
	return
	
	guiDisplay_reset:
		GuiControl display: , Button1, Start
		
		If !(g_target) and (g_mode = "timer") {
			GuiControl display: Disable, Start
		}
		else {
			GuiControl display: Enable, Start
		}
		
		WinActivate, Stopwatch
		
		Gosub hk_reset
	return
	
	guiDisplay_setTimer:
		If !(g_mode = "timer")
			return
		gui Display: +Disabled
		target := guiTarget(_guiDisplay)
		If !(target)
		{
			gui Display: -Disabled
			return
		}
		g_target := target
		Gosub guiDisplay_reset
		gui Display: -Disabled
	return
	
	guiDisplay_Contextmenu:
		; prompt for new title if click-click on title bar
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl 
		If (OutputVarControl = "Static1") or (OutputVarControl = "Static2") { ; drag control or title text control
			InputBox, output , Timer, Choose a new title
			If (output)
				GuiControl Display: Text, guiDisplay_title, % output
			return
		}
		
		menu, Display, add
		menu, Display, DeleteAll
		
		menu, Display, add, Stopwatch, guiDisplay_ContextMenu_stopwatch
		menu, Display, add, Timer, guiDisplay_ContextMenu_timer
		
		If (g_mode = "stopwatch")
			menu, Display, check, Stopwatch
		If (g_mode = "timer")
			menu, Display, check, Timer
		
		menu, Display, show
	return

	guiDisplay_ContextMenu_stopwatch:
		g_mode := "stopwatch"
		Gosub guiDisplay_reset
	return

	guiDisplay_ContextMenu_timer:
		g_mode := "timer"
		Gosub guiDisplay_reset
	return
}