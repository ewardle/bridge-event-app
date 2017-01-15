package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse;

import android.graphics.Color;

import com.alamkanak.weekview.WeekViewEvent;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time.End;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time.Start;
import com.google.gson.annotations.SerializedName;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * Created by Arya on 1/4/2017.
 */

public class Event {
    @SerializedName("summary")
    private String summary;
    @SerializedName("id")
    private String id;
    @SerializedName("start")
    private Start mStart;
    @SerializedName("end")
    private End mEnd;

    public String getSummary() {
        return summary;
    }

    public String getEventId() {
        return id;
    }

    public Start getStart() {
        return mStart;
    }

    public End getEnd() {
        return mEnd;
    }

    public WeekViewEvent toWeekViewEvent() {

        // Parse time.
        SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
        Date start = new Date();
        Date end = new Date();
        try {
            start = sdf.parse("09:22");
        } catch (ParseException e) {
            e.printStackTrace();
        }
        try {
            end = sdf.parse("12:22");
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // Initialize start and end time.
        Calendar now = Calendar.getInstance();
        Calendar startTime = (Calendar) now.clone();
        startTime.setTimeInMillis(start.getTime());
        startTime.set(Calendar.YEAR, now.get(Calendar.YEAR));
        startTime.set(Calendar.MONTH, now.get(Calendar.MONTH));
        startTime.set(Calendar.DAY_OF_MONTH, 9);
        Calendar endTime = (Calendar) startTime.clone();
        endTime.setTimeInMillis(end.getTime());
        endTime.set(Calendar.YEAR, startTime.get(Calendar.YEAR));
        endTime.set(Calendar.MONTH, startTime.get(Calendar.MONTH));
        endTime.set(Calendar.DAY_OF_MONTH, startTime.get(Calendar.DAY_OF_MONTH));

        // Create an week view event.
        WeekViewEvent weekViewEvent = new WeekViewEvent();
        weekViewEvent.setName(getSummary());
        weekViewEvent.setStartTime(startTime);
        weekViewEvent.setEndTime(endTime);


        return weekViewEvent;
    }
    public String getEventStartTime(){
        Date date = new Date(mStart.getCalendarDateTime().getValue());
        return date.toString();
    }
}
