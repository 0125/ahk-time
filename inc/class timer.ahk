class class_timer {
    __New() {
        this.SetTarget()
    }

    SetTarget() { ; in seconds
        this.target := 3
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
    }

    Reset() {
        SetTimer, RefreshTimer, On
        TrackTime.Reset()
    }

    Refresh() {
        CoordMode, Tooltip, Screen

        If (TrackTime.passedTime = this.target)
            msgbox %A_ThisFunc% - finished timer!

        remaining := this.target - TrackTime.passedTime

        tooltip % TrackTime.passedTime "`n" A_Now "`n`nremaining:" remaining,0,0
    }
}

RefreshTimer:
    timer.Refresh()
return