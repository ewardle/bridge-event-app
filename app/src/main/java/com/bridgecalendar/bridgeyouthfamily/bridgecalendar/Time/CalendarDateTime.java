package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Arya on 1/5/2017.
 */

public class CalendarDateTime {
    @SerializedName("value")
    private long value;
    @SerializedName("dateOnly")
    private Boolean dateOnly;
    @SerializedName("timeZoneShift")
    private int timeZoneShift;

    public long getValue() {
        return value;
    }

    public Boolean getDateOnly() {
        return dateOnly;
    }

    public int getTimeZoneShift() {
        return timeZoneShift;
    }
}
