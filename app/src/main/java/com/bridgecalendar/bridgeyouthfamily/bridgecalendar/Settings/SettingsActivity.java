package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Settings;

import android.content.Context;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.alamkanak.weekview.WeekView;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventAdapter;
import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.R;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by Arya on 1/14/2017.
 */

public class SettingsActivity extends AppCompatActivity {
    List<String> filterLocationList;
    List<String> filteredList;
    List<Integer> isSelectedList;
    private RecyclerView recyclerView;
    private FilterAdapter filterAdapter;
    private Button saveFilterButton;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.settings_activity);

        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        saveFilterButton = (Button) findViewById(R.id.save_filter_button);
        saveFilterButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                isSelectedList = filterAdapter.getSelectedList();
                filteredList = filterAdapter.getFilterList();

                SharedPreferences prefs = getSharedPreferences("bridge", Context.MODE_PRIVATE);
                SharedPreferences.Editor edit = prefs.edit();
                Set<String> set = new HashSet<>();
                set.addAll(filteredList);
                edit.putStringSet("filterList", set);
                edit.commit();
                finish();
            }
        });
        filterLocationList = getIntent().getStringArrayListExtra("filterList");
        SharedPreferences prefs = this.getSharedPreferences("bridge", Context.MODE_PRIVATE);
        Set<String> set = prefs.getStringSet("filterList", null);
        filterLocationList.removeAll(Collections.singleton(null));

        recyclerView = (RecyclerView) findViewById(R.id.filter_recycler_view);
        filterAdapter = new FilterAdapter(this, filterLocationList);
        if (set != null) {
            filteredList = new ArrayList<>(set);
            filterAdapter.setFilteredList(filteredList);
        }
        recyclerView.setAdapter(filterAdapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
        filterAdapter.notifyDataSetChanged();
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
}
