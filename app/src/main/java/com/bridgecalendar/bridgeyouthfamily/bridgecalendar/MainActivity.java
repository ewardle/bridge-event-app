package com.bridgecalendar.bridgeyouthfamily.bridgecalendar;

import android.content.Intent;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.NavigationView;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.CalendarView;
import android.widget.TextView;
import android.widget.Toast;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.Event;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventListListener;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.EventResponseManager;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Settings.SettingsActivity;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.UpcomingEvents.UpcomingEventsActivity;

import org.w3c.dom.Text;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

/**
 * Created by Arya on 1/4/2017.
 */

public class MainActivity extends AppCompatActivity implements EventListListener {
    private List<Event> mEventList;
    private List<Event> mRecyclerViewEventList;

    private CalendarView mCalendarView;
    EventResponseManager eventResponseManager;
    private DrawerLayout mDrawerLayout;
    private NavigationView mNavigationView;
    private ActionBarDrawerToggle mDrawerToggle;
    private RecyclerView mRecyclerView;
    private EventAdapter mEventAdapter;

    private TextView mEmptyEventsTextView;

    //TODO set to query only current month + previous + next
    //TODO reupload server code to update setMaxResults = 2499
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        mEventList = new ArrayList<>();
        mRecyclerViewEventList = new ArrayList<>();

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setHomeButtonEnabled(true);

        mCalendarView = (CalendarView) findViewById(R.id.calendar_view);
        mEmptyEventsTextView = (TextView) findViewById(R.id.no_event_text_view);
        mEmptyEventsTextView.setVisibility(View.GONE);

        mRecyclerView = (RecyclerView) findViewById(R.id.event_recycler_view);
        mEventAdapter = new EventAdapter(this, mRecyclerViewEventList);
        mRecyclerView.setAdapter(mEventAdapter);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mRecyclerView.addItemDecoration(new DividerItemDecoration(this));

        mDrawerLayout = (DrawerLayout) findViewById(R.id.main_drawer_layout);
        mNavigationView = (NavigationView) findViewById(R.id.nav_view);
        mDrawerToggle = setupDrawerToggle();

        setNavDrawerListener(mNavigationView);


        eventResponseManager = new EventResponseManager();
        eventResponseManager.attachListener(this);
        Calendar calendar = Calendar.getInstance();
        int currentYear = calendar.get(Calendar.YEAR);
        int currentMonth = calendar.get(Calendar.MONTH) + 1;
        int nextMonth = currentMonth + 1;
        int previousMonth = currentMonth - 1;
        String currentMonthString = "" + currentMonth;
        String nextMonthString = "" + nextMonth;
        String previousMonthString = "" + previousMonth;
        if ((currentMonth) < 10) {
            currentMonthString = String.format("%02d", (currentMonth));
        }
        if ((nextMonth) < 10) {
            nextMonthString = String.format("%02d", (nextMonth));
        }
        if ((previousMonth) < 10) {
            previousMonthString = String.format("%02d", (previousMonth));
        }
        eventResponseManager.getSearchList("bridgekelowna@gmail.com", currentYear + "-" + previousMonthString + "-01T00:00:31-08:00", currentYear + "-" + nextMonthString + "-31T23:59:31-08:00");
        //calendar listener for user date selection change
        mCalendarView.setOnDateChangeListener(new CalendarView.OnDateChangeListener() {
            @Override
            public void onSelectedDayChange(CalendarView view, int year, int month, int dayOfMonth) {

                try {
                    //mTextView2.setText(""+month);
                    mRecyclerViewEventList.clear();
                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
                    String monthString = "" + (month + 1);
                    String dayOfMonthString = "" + dayOfMonth;
                    if ((month + 1) < 10) {
                        monthString = String.format("%02d", (month + 1));
                    }
                    if (dayOfMonth < 10) {
                        dayOfMonthString = String.format("%02d", dayOfMonth);
                    }
                    long unixTimeStart = dateFormat.parse("" + year + "-" + monthString + "-" + dayOfMonthString + "T" + "00:00:00-08:00").getTime();
                    long unixTimeEnd = dateFormat.parse("" + year + "-" + monthString + "-" + dayOfMonthString + "T" + "23:59:59-08:00").getTime();
                    int count = 0;
                    //mTextView.setText("" + unixTimeStart);
                    for (int i = 0; i < mEventList.size(); i++) {
                        if (mEventList.get(i).getStart().getCalendarDateTime() != null) {
                            long eventEnd = mEventList.get(i).getEnd().getCalendarDateTime().getValue();
                            long eventStart = mEventList.get(i).getStart().getCalendarDateTime().getValue();
                            //mTextView2.setText("" + eventEnd);
                            if (eventStart >= unixTimeStart && eventEnd <= unixTimeEnd) {
                                count++;
                                mRecyclerViewEventList.add(mEventList.get(i));
                                //mTextView.setText("" + mEventList.get(i).getSummary());
                            }

                        }
                    }
                    if (count == 0) {
                        mEmptyEventsTextView.setVisibility(View.VISIBLE);
                        mRecyclerView.setVisibility(View.GONE);
                    } else {
                        mRecyclerView.setVisibility(View.VISIBLE);
                        mEmptyEventsTextView.setVisibility(View.GONE);

                    }
                    mEventAdapter.notifyDataSetChanged();
                    Date date = new Date(unixTimeStart);
                    String dateFormatted = dateFormat.format(date);
                    //Toast.makeText(MainActivity.this, dateFormatted, Toast.LENGTH_SHORT).show();
                    //Toast.makeText(MainActivity.this, ""+unixTimeStart, Toast.LENGTH_SHORT).show();


                } catch (ParseException e) {
                    e.printStackTrace();
                }

            }
        });


    }

    private ActionBarDrawerToggle setupDrawerToggle() {
        return new ActionBarDrawerToggle(this, mDrawerLayout, R.string.drawer_open, R.string.drawer_close);
    }

    @Override
    protected void onPostCreate(@Nullable Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (mDrawerToggle.onOptionsItemSelected(item)) {
            return true;
        }
        return super.onOptionsItemSelected(item);


    }

    private void setNavDrawerListener(NavigationView navigationView) {
        navigationView.setNavigationItemSelectedListener(new NavigationView.OnNavigationItemSelectedListener() {
            @Override
            public boolean onNavigationItemSelected(MenuItem item) {
                drawerItemSelection(item);
                return true;
            }
        });
    }

    //drawer menu item actions
    private void drawerItemSelection(MenuItem item) {
        Class activityClassObject;
        switch (item.getItemId()) {
            case R.id.upcoming_events_menu:
                activityClassObject = UpcomingEventsActivity.class;
                break;
            case R.id.drawer_settings_menu:
                // Either use fragment or new settings activity
                activityClassObject = SettingsActivity.class;
                break;
            case R.id.drawer_website:
                startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse("http://www.thebridgeservices.ca/")));
            default:
                activityClassObject = UpcomingEventsActivity.class;
                break;
        }
        try {
            // fragment = (Fragment) fragmentClassObject.newInstance();
        } catch (Exception e) {
            e.printStackTrace();
        }
        Intent startActivity = new Intent(this, activityClassObject);
        startActivity(startActivity);
        mDrawerLayout.closeDrawers();
    }

    @Override
    protected void onStart() {
        super.onStart();
        if (eventResponseManager == null) {

            eventResponseManager.attachListener(this);
        }

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
        eventResponseManager.detachListener();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void setEventList(List<Event> eventList) {
        mEventList.clear();
        mEventList.addAll(eventList);
        // mTextView2.setText(""+mEventList.size());
    }
}
