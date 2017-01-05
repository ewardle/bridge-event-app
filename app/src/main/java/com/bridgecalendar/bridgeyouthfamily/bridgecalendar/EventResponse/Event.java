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
    @SerializedName("start")
    private Start mStart;
    @SerializedName("end")
    private End mEnd;

}
