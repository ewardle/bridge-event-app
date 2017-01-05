package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.CalendarAPI;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.CalendarResponse.CalendarResponse;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponse;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Query;

/**
 * Created by Arya on 1/4/2017.
 */

public interface CalendarAPI {
    @GET("/calendarlist")
    Call<CalendarResponse> getCalendarList();

    @GET("/calendar/events")
    Call<EventResponse> getEvents(@Query("calendarName") String calendarName, @Query("min") String minTime, @Query("max") String maxTime);
}
