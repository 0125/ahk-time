class class_timer {
    SetTarget(input) { ; in seconds
        ; this.target := 10 ; debugging purposes
        this.target := input
        mainGui.SetText("Static3", FormatTimeSeconds(this.target))
    }

    Start() {
        If !(this.target)
            return
        
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
        this.target := "0"
        mainGui.SetText("Static3", FormatTimeSeconds(this.target)) ; reset main gui
        alarm("disable")
    }

    Reset() {
        SetTimer, RefreshTimer, Off
        TrackTime.Reset()
        mainGui.SetText("Static3", FormatTimeSeconds(this.target)) ; reset main gui
        alarm("disable")
    }

    Refresh() {
        static previousRemaining

        If (TrackTime.passedTime >= this.target) {
            this.Pause()
            mainGui.SetText("Static3", FormatTimeSeconds(0)) ; set main gui to 0
            alarm("enable")
            return
        }

        remaining := this.target - TrackTime.passedTime

        If !(remaining = previousRemaining) ; only update if time changed to prevent visual glitches
            mainGui.SetText("Static3", FormatTimeSeconds(remaining))

        previousRemaining := remaining

        ; CoordMode, Tooltip, Screen
        ; tooltip % TrackTime.passedTime "`n" A_Now "`n`nremaining:" remaining,0,0 ; debug
    }
}

RefreshTimer:
    timer.Refresh()
return