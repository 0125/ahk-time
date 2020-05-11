class class_stopwatch {
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
        mainGui.SetText("Static3", "00:00:00") ; reset main gui
    }

    Reset() {
        SetTimer, RefreshStopwatch, Off
        TrackTime.Reset()
        mainGui.SetText("Static3", "00:00:00") ; reset main gui
    }

    Refresh() {
        static previousPassedTime

        passedTime := TrackTime.passedTime

        If !(passedTime = previousPassedTime) ; only update if time changed to prevent visual glitches
            mainGui.SetText("Static3", FormatTimeSeconds(passedTime))

        previousPassedTime := passedTime

        ; CoordMode, Tooltip, Screen
        ; tooltip % FormatTimeSeconds(passedTime) "`n" A_Now "`n" passedTime,0,0 ; debug
    }
}

RefreshStopwatch:
    stopwatch.Refresh()
return