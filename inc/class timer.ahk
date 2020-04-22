class class_timer {
    __New() {
        this.SetTarget()
    }

    Setup() {
        this.SetTarget()
    }

    SetTarget() { ; in seconds
        If !(this.target)
            msgbox % A_ThisFunc " -- <insert guiSetTarget() here> 0, 0"
        
        ; this.target := 10 ; debugging purposes

        mainGui.SetText("Static3", FormatTimeSeconds(this.target))
    }

    Start() {
        TrackTime.Start()
        SetTimer, RefreshTimer, On
    }

    Pause() {
        SetTimer, RefreshTimer, Off
        TrackTime.Pause()
    }

    Stop() {
        SetTimer, RefreshTimer, Off
        TrackTime.Stop() ; reset and stop time tracking
        mainGui.SetText("Static3", FormatTimeSeconds(this.target)) ; reset main gui
    }

    Reset() {
        SetTimer, RefreshTimer, Off
        TrackTime.Reset()
        mainGui.SetText("Static3", FormatTimeSeconds(this.target)) ; reset main gui
    }

    Refresh() {
        static previousRemaining
        
        If (TrackTime.passedTime = this.target)
            msgbox %A_ThisFunc% - finished timer!

        remaining := this.target - TrackTime.passedTime

        If !(remaining = previousRemaining) ; only update if time changed to prevent visual glitches
            mainGui.SetText("Static3", FormatTimeSeconds(remaining))

        ; CoordMode, Tooltip, Screen
        ; tooltip % TrackTime.passedTime "`n" A_Now "`n`nremaining:" remaining,0,0 ; debug
    }
}

RefreshTimer:
    timer.Refresh()
return