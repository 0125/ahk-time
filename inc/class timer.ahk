class class_timer {
    __New() {
        this.SetTarget()
    }

    Setup() {
        this.SetTarget()
    }

    SetTarget(input) { ; in seconds
        ; If !(this.target)
        ;     msgbox % A_ThisFunc " -- <insert guiSetTarget() here> 0, 0"
        
        ; this.target := 10 ; debugging purposes

        this.target := input
        mainGui.SetText("Static3", FormatTimeSeconds(this.target))
    }

    SetTargetUntil() {
        InputBox, input, Set target, Please enter a 24 hours future timestamp eg. 1300, , 340, 130
        if (ErrorLevel)
            return ; CANCEL was pressed.
        
        inputTarget := input
        ; inputTarget := 1200

        ; modify target to be compatible with FormatTime
        loop, {
            loop, parse, inputTarget ; count total input digits
                count := A_Index
            If (count < 6) ; if less than 6 digits, add a 0
                inputTarget := inputTarget 0
            else
                break ; end loop when 6 digits are available
        }

        futureStamp := A_YYYY A_MM A_DD inputTarget
        differenceSeconds := futureStamp
        EnvSub, differenceSeconds, A_Now, Seconds

        If (differenceSeconds <= 0)
            differenceSeconds := 1

        this.target := differenceSeconds
        mainGui.SetText("Static3", FormatTimeSeconds(this.target))
        mainGui.SetText("Static2", "Until " input) ; title bar
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
        this.target := "0"
        mainGui.SetText("Static3", FormatTimeSeconds(this.target)) ; reset main gui
    }

    Reset() {
        SetTimer, RefreshTimer, Off
        TrackTime.Reset()
        mainGui.SetText("Static3", FormatTimeSeconds(this.target)) ; reset main gui
    }

    Refresh() {
        static previousRemaining
        
        If (TrackTime.passedTime = this.target) {
            this.Stop()
            msgbox %A_ThisFunc% - finished timer!
            return
        }

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