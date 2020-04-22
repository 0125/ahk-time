class class_trackTime {
    __New() {
    }

    Start() {
        If (this.pausedTime) { ; if timer was paused, set new start time
            newStartTime := A_Now
            EnvAdd, newStartTime, -this.pausedTime, Seconds ; subtract passed time from current time
            this.startTime := newStartTime ; set new start time
            this.pausedTime := "" ; reset paused status
        }
        else ; start fresh
            this.startTime := A_Now

        SetTimer, UpdateTrackedTime, On
    }

    Pause() {
        SetTimer, UpdateTrackedTime, Off
        this.pausedTime := getPassedTimeSince(this.startTime)
    }

    Stop() {
        SetTimer, UpdateTrackedTime, Off
        this.Reset()
    }

    Reset() {
        SetTimer, UpdateTrackedTime, Off
        this.pausedTime := ""
        this.startTime := A_Now
    }

    Refresh() {
        this.passedTime := getPassedTimeSince(this.startTime)
    }
}

UpdateTrackedTime:
    ; CoordMode, Tooltip, Screen
    ; tooltip % getPassedTimeSince(TrackTime.startTime) "`n" A_Now,0,0
    TrackTime.Refresh()
return