package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time;

/**
 * Created by Arya on 1/5/2017.
 */

public class CalendarDateTime {
    private long value;
    private Boolean dateOnly;
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
