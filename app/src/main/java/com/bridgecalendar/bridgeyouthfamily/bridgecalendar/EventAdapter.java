package com.bridgecalendar.bridgeyouthfamily.bridgecalendar;

import android.content.Context;

import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.EventResponse.Event;


import org.w3c.dom.Text;

import java.util.List;

/**
 * Created by Arya on 1/14/2017.
 */

public class EventAdapter extends RecyclerView.Adapter<EventAdapter.ViewHolder> {
    private List<Event> mEventList;
    private Context mContext;

    public EventAdapter(Context context, List<Event> eventList) {
        mEventList = eventList;
        this.mContext = context;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater layoutInflater = LayoutInflater.from(context);

        View eventRowView = layoutInflater.inflate(R.layout.event_row, parent, false);

        return new ViewHolder(eventRowView);
    }

    @Override
    public void onBindViewHolder(ViewHolder holder, int position) {
        Event event = mEventList.get(position);
        TextView eventSummaryTextView = holder.eventSummaryTextView;
        TextView eventStartTextView = holder.eventStartTextView;
        TextView eventDescriptionTextView = holder.eventDescriptionTextView;

        if (event.getSummary() != null) {
            eventSummaryTextView.setText(event.getSummary());
        } else {
            eventSummaryTextView.setText("Unknown");
        }
        if (event.getEventLocation() != null) {
            eventDescriptionTextView.setText("Location: " + event.getEventLocation());
        } else {
            eventDescriptionTextView.setText("Unknown");
        }

        eventStartTextView.setText(event.getEventStartTime() + " - " + event.getEventEndTime());

    }

    @Override
    public int getItemCount() {
        return mEventList.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        private TextView eventSummaryTextView;
        private TextView eventStartTextView;
        private TextView eventDescriptionTextView;

        public ViewHolder(View itemView) {
            super(itemView);
            eventSummaryTextView = (TextView) itemView.findViewById(R.id.event_summary_text_view);
            eventDescriptionTextView = (TextView) itemView.findViewById(R.id.event_description_text_view);
            eventStartTextView = (TextView) itemView.findViewById(R.id.event_start_time_text_view);
        }
    }
}
