package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse;

import android.graphics.Color;
import android.util.Log;

import com.alamkanak.weekview.WeekViewEvent;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.R;
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

public class Event extends WeekViewEvent {
    @SerializedName("summary")
    private String summary;
    @SerializedName("description")
    private String description;
    @SerializedName("location")
    private String location;
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

    public String getDescription() {
        return description;
    }

    public String getEventLocation() {
        return this.location;
    }

    public WeekViewEvent toWeekViewEvent() {

        // Initialize start and end time.
        Calendar now = Calendar.getInstance();
        Calendar startTime = (Calendar) now.clone();

        startTime.setTimeInMillis(mStart.getCalendarDateTime().getValue());

        startTime.set(Calendar.YEAR, startTime.get(Calendar.YEAR));
        startTime.set(Calendar.MONTH, startTime.get(Calendar.MONTH));
        startTime.set(Calendar.DAY_OF_MONTH, startTime.get(Calendar.DAY_OF_MONTH));

        Calendar endTime = (Calendar) startTime.clone();

        endTime.setTimeInMillis(mEnd.getCalendarDateTime().getValue());
        endTime.set(Calendar.YEAR, startTime.get(Calendar.YEAR));
        endTime.set(Calendar.MONTH, startTime.get(Calendar.MONTH));
        endTime.set(Calendar.DAY_OF_MONTH, startTime.get(Calendar.DAY_OF_MONTH));

        // Create an week view event.
        WeekViewEvent weekViewEvent = new WeekViewEvent(0, getSummary(), startTime, endTime);
        weekViewEvent.setColor(Color.parseColor("#D48C70"));
//        if(weekViewEvent.getId() == 1){
//            weekViewEvent.setColor();
//        }
        if(getEventLocation() != null){
            weekViewEvent.setLocation(getEventLocation());
        }else {
            weekViewEvent.setLocation("Unknown location");
        }
/*
            if (weekViewEvent.getLocation().equals("Kelowna")) {
                weekViewEvent.setColor(Color.CYAN);
            }*/

        return weekViewEvent;
    }

    public String getEventStartTime() {
        Date date = new Date(mStart.getCalendarDateTime().getValue());
        SimpleDateFormat sdf = new SimpleDateFormat("MMMM d, yyyy 'at' h:mm a");
        String dateString = sdf.format(date);
        return dateString;
    }

    public String getEventEndTime() {
        Date date = new Date(mEnd.getCalendarDateTime().getValue());
        SimpleDateFormat sdf = new SimpleDateFormat("h:mm a");
        String dateString = sdf.format(date);
        return dateString;
    }

}
