class class_stopwatch {
    __New() {
    }

    Start() {
        TrackTime.Start()
        SetTimer, RefreshStopwatch, On
    }

    Pause() {
        SetTimer, RefreshStopwatch, Off
        TrackTime.Pause()
    }

    Stop() {
        SetTimer, RefreshStopwatch, Off
        TrackTime.Stop() ; reset and stop time tracking
    }

    Reset() {
        SetTimer, RefreshStopwatch, On
        TrackTime.Reset()
    }

    Refresh() {
        CoordMode, Tooltip, Screen
    
        passedTime := TrackTime.passedTime

        tooltip % FormatTimeSeconds(passedTime) "`n" A_Now "`n" passedTime,0,0
    }
}

RefreshStopwatch:
    stopwatch.Refresh()
return