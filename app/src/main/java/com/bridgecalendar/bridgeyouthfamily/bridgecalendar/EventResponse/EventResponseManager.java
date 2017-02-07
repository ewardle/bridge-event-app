package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse;

import android.util.Log;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.CalendarAPI.CalendarAPI;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Created by Arya on 1/4/2017.
 */

public class EventResponseManager {
    public static final String BASE_URL = "http://138.197.129.140:8080";
    private EventResponse mEventResponse;
    private EventListListener mEventListListener;

    public EventResponseManager(EventListListener eventListListener) {
        mEventListListener = eventListListener;
    }

    public void getSearchList(String calendarName, String minTime, String maxTime) {
        Retrofit retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        CalendarAPI calendarAPI = retrofit.create(CalendarAPI.class);
        Call<EventResponse> call2 = calendarAPI.getEvents(calendarName, minTime, maxTime);
        call2.enqueue(new Callback<EventResponse>() {
            @Override
            public void onResponse(Call<EventResponse> call, Response<EventResponse> response) {
                if (response.isSuccessful()) {
                    mEventResponse = response.body();
                    if (mEventListListener != null) {
                        mEventListListener.setEventList(mEventResponse.getEventItems());
                    }

                } else {
                    Log.d("TEST", "Response Error");
                }
            }

            @Override
            public void onFailure(Call<EventResponse> call, Throwable t) {

            }

        });

    }

    public void attachListener(EventListListener eventListListener) {
        this.mEventListListener = eventListListener;
    }

    public void detachListener() {
        this.mEventListListener = null;
    }
}
