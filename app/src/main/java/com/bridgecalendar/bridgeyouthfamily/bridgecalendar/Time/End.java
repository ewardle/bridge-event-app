package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time;

import com.google.gson.annotations.SerializedName;

/**
 * Created by Arya on 1/5/2017.
 */

public class End {
    @SerializedName("dateTime")
    private CalendarDateTime mCalendarDateTime;

    public CalendarDateTime getCalendarDateTime() {
        return mCalendarDateTime;
    }
}
