guiDisplay(input = "") {
	static _guiDisplay_digits
	
	If (_guiDisplay_digits) and (input)	{
		GuiControl display: , % _guiDisplay_digits, % input
		return
	}
	If (_guiDisplay_digits)
		return
	
	; properties
	gui Display: new
	gui Display: margin, 5, 5
	gui Display: +LabelguiDisplay_ +Hwnd_guiDisplay
	
	; controls
	gui Display: font, s25 verdana
	gui Display: add, text, x5 w135 Center gguiDisplay_setTimer hwnd_guiDisplay_digits, 00:00:00
	gui Display: font
	
	gui Display: add, button, x5 w65 gguiDisplay_button, Start
	gui Display: add, button, x+5 w65 gguiDisplay_reset, Reset
	
	Gosub guiDisplay_refresh
	
	; show
	gui Display: show, NoActivate
	WinWaitClose, % "ahk_id " _guiDisplay
	exitapp

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
		Gosub hk_reset
	return
	
	guiDisplay_setTimer:
		If !(g_mode = "timer")
			return
		target := guiTarget()
		If !(target)
			return
		g_target := target
		Gosub hk_reset
		Gosub guiDisplay_refresh
	return
	
	guiDisplay_refresh:
		If !(g_target) and (g_mode = "timer") {
			GuiControl display: Disable, Start
		}
		else {
			GuiControl display: Enable, Start
		}
	return
	
	guiDisplay_Contextmenu:
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
		Gosub guiDisplay_refresh
		Gosub hk_reset
	return

	guiDisplay_ContextMenu_timer:
		g_mode := "timer"
		Gosub guiDisplay_refresh
		Gosub hk_reset
	return
}