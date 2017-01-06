package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time.End;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Time.Start;
import com.google.gson.annotations.SerializedName;

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

    public String getId() {
        return id;
    }

    public Start getStart() {
        return mStart;
    }

    public End getEnd() {
        return mEnd;
    }
}
