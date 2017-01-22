package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.UpcomingEvents;

import android.app.Fragment;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import com.alamkanak.weekview.MonthLoader;
import com.alamkanak.weekview.WeekView;
import com.alamkanak.weekview.WeekViewEvent;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.Event;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventListListener;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponseManager;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Arya on 1/14/2017.
 */

public class UpcomingEventsActivity extends AppCompatActivity implements EventListListener{
    private List<Event> mEventList;
    WeekView mWeekView;
    EventResponseManager eventResponseManager;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.upcoming_events_activity);
        mWeekView = (WeekView) findViewById(R.id.weekView);

        mEventList = new ArrayList<>();
        eventResponseManager = new EventResponseManager(this);
        eventResponseManager.getSearchList("bridgekelowna@gmail.com", "2016-01-09T10:00:31-08:00", "2017-12-31T11:00:31-08:00");


        mWeekView.setMonthChangeListener(new MonthLoader.MonthChangeListener() {
            @Override
            public List<? extends WeekViewEvent> onMonthChange(int newYear, int newMonth) {
                List<WeekViewEvent> weekViewEvents = new ArrayList<>();
                for(Event event: mEventList){
                    weekViewEvents.add(event.toWeekViewEvent());
                }
                Log.d("APP DEBUG"," weekViewEvents.add(event.toWeekViewEvent()) size:" + weekViewEvents.size());
                    return weekViewEvents;
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onStop() {
        super.onStop();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onPause() {
        super.onPause();
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public void setEventList(List<Event> eventList) {
        mEventList.clear();
        mEventList.addAll(eventList);
        Log.d("APP DEBUG"," retrofit event list size:" + mEventList.size());
    }
}
