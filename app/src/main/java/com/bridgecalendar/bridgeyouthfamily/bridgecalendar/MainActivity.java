package com.bridgecalendar.bridgeyouthfamily.bridgecalendar;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.widget.CalendarView;
import android.widget.TextView;
import android.widget.Toast;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.Event;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventListListener;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponse;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponseManager;

import org.w3c.dom.Text;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

/**
 * Created by Arya on 1/4/2017.
 */

public class MainActivity extends AppCompatActivity implements EventListListener {
    private List<Event> mEventList;
    private TextView mTextView;
    private TextView mTextView2;
    private CalendarView mCalendarView;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);

        mTextView = (TextView) findViewById(R.id.test_text_view);
        mTextView2 = (TextView) findViewById(R.id.test2_text_view);
        mCalendarView = (CalendarView) findViewById(R.id.calendar_view);



        mCalendarView.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @Override
            public void onSelectedDayChange(CalendarView view, int year, int month, int dayOfMonth) {

                try {
                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
                    long unixTimeStart = dateFormat.parse("" + year + "-" + (month + 1) + "-" + dayOfMonth + "T" + "00:00:00-08:00").getTime();
                    long unixTimeEnd = dateFormat.parse("" + year + "-" + (month + 1) + "-" + dayOfMonth + "T" + "23:59:59-08:00").getTime();
                    int count = 0;
                    mTextView.setText(""+unixTimeStart);
                    for (int i = 0; i < mEventList.size(); i++) {
                        long eventEnd = mEventList.get(i).getEnd().getCalendarDateTime().getValue();
                        long eventStart = mEventList.get(i).getStart().getCalendarDateTime().getValue();
                        mTextView2.setText(""+eventEnd);
                        if (eventStart >= unixTimeStart  && eventEnd <= unixTimeEnd) {
                            count++;
                            mTextView.setText("" + mEventList.get(i).getSummary());
                        }
                        if(count==0){
                            mTextView.setText("No Event Scheduled");
                        }

                    }
                    Date date = new Date(unixTimeStart);
                    String dateFormatted = dateFormat.format(date);
                    //Toast.makeText(MainActivity.this, dateFormatted, Toast.LENGTH_SHORT).show();
                    Toast.makeText(MainActivity.this, "" + count, Toast.LENGTH_SHORT).show();

                } catch (ParseException e) {
                    e.printStackTrace();
                }

            }
        });

        mEventList = new ArrayList<>();
        EventResponseManager eventResponseManager = new EventResponseManager(this);
        eventResponseManager.getSearchList("bridgekelowna@gmail.com", "2016-01-12T10:00:31-08:00", "2016-12-31T11:00:31-08:00");

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
        //mTextView.setText(""+mEventList.size());
    }
}
