package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse;

import com.google.gson.annotations.SerializedName;

import java.util.List;

/**
 * Created by Arya on 1/4/2017.
 */

public class EventResponse {
    @SerializedName("eventItems")
    private List<Event> mEventItems;

    public List<Event> getEventItems() {
        return mEventItems;
    }
}
