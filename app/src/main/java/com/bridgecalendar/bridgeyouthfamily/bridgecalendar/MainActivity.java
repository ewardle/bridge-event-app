package com.bridgecalendar.bridgeyouthfamily.bridgecalendar;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.widget.TextView;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.Event;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventListListener;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponse;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponseManager;

import org.w3c.dom.Text;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Arya on 1/4/2017.
 */

public class MainActivity extends AppCompatActivity implements EventListListener{
    public List<Event> mEventList;
    public TextView mTextView;
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        mEventList = new ArrayList<>();
        EventResponseManager eventResponseManager = new EventResponseManager(this);
        eventResponseManager.getSearchList("bridgekelowna@gmail.com","2016-01-12T10:00:31-08:00","2016-12-31T11:00:31-08:00");
        mTextView  = (TextView) findViewById(R.id.test_text_view);
    }

    @Override
    protected void onStart() {
        super.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();

    }

    @Override
    protected void onPause() {
        super.onPause();
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
    public void setEventList(List<Event> eventList) {
        mEventList.clear();
        mEventList.addAll(eventList);
        mTextView.setText(""+mEventList.size());
    }
}
