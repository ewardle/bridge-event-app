package com.bridgecalendar.bridgeyouthfamily.bridgecalendar.Settings;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.TextView;

import com.bridgecalendar.bridgeyouthfamily.bridgecalendar.R;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Arya on 3/10/2017.
 */

public class FilterAdapter extends RecyclerView.Adapter<FilterAdapter.ViewHolder> {
    private List<String> filterList;
    private List<String> filteredList;
    private List<Integer> isSelectedList;
    private Context context;

    public FilterAdapter(Context context, List<String> filterList) {
        this.filterList = filterList;
        isSelectedList = new ArrayList<>();
        filteredList = new ArrayList<>();
        this.context = context;
    }

    @Override
    public FilterAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        Context context = parent.getContext();
        LayoutInflater layoutInflater = LayoutInflater.from(context);

        View eventRowView = layoutInflater.inflate(R.layout.filter_row, parent, false);

        return new FilterAdapter.ViewHolder(eventRowView);
    }

    @Override
    public void onBindViewHolder(final FilterAdapter.ViewHolder holder, int position) {
        String filter = filterList.get(position);
        TextView filterTextView = holder.filterTextView;

        filterTextView.setText(filter);
        holder.filterCheckBox.setOnCheckedChangeListener(null);

        if(filteredList.contains(holder.filterTextView.getText().toString())){

            holder.filterCheckBox.setChecked(true);
        }

        //if true, your checkbox will be selected, else unselected
        //holder.filterCheckBox.setChecked(isSelectedList.contains(filterList.get(position)));

        holder.filterCheckBox.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    isSelectedList.add(holder.getAdapterPosition());
                    filteredList.add(holder.filterTextView.getText().toString());

                }
                if (!isChecked) {
                    isSelectedList.remove(new Integer(holder.getAdapterPosition()));
                    filteredList.remove(holder.filterTextView.getText().toString());

                }

            }
        });

    }

    @Override
    public int getItemCount() {
        return filterList.size();
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {
        private TextView filterTextView;
        private CheckBox filterCheckBox;


        public ViewHolder(View itemView) {
            super(itemView);
            filterTextView = (TextView) itemView.findViewById(R.id.filter_text_view);
            filterCheckBox = (CheckBox) itemView.findViewById(R.id.filter_row_checkbox);

        }
    }
    public List<Integer> getSelectedList(){
        return this.isSelectedList;
    }
    public List<String> getFilterList(){
        return this.filteredList;
    }

    public void setFilteredList(List<String> filteredList) {
        this.filteredList = filteredList;

    }

    public void setIsSelectedList(List<Integer> isSelectedList) {
        this.isSelectedList = isSelectedList;
    }
}
