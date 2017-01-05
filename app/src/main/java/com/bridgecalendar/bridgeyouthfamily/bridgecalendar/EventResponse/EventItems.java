package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Arya on 1/5/2017.
 */

public class EventItems {
    @SerializedName("eventItems")
    private List<Event> mEventList;

    public List<Event> getEventList() {
        return mEventList;
    }
}
