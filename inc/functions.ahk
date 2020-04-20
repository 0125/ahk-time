; input = date time stamp eg. A_Now or A_YYYY A_MM A_DD 00 00 00
getPassedTimeSince(input) {
    output := A_Now
    ; EnvAdd, output, 5, Seconds ; debugging: add 5 seconds to current time
    EnvSub, output, input, Seconds ; amount of seconds passed since input

    return output
}

; input = seconds
; output = seconds formatted in HH:mm:ss format
FormatTimeSeconds(input) {
    DateTimeString := g_nullTime
    EnvAdd, DateTimeString, input, Seconds ; add passed seconds to nulltime
    FormatTime, output, % DateTimeString, HH:mm:ss ; format created timestamp into readable format

    return output
}