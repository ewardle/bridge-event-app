package com.bridgecalendar.bridgeyouthfamily.bridgecalendar;

import android.util.Log;

import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.FirebaseInstanceIdService;

/**
 * Created by Arya on 2/6/2017.
 */

public class FirebaseIDService extends FirebaseInstanceIdService {
    @Override
    public void onTokenRefresh() {
        super.onTokenRefresh();
        String refreshedToken = FirebaseInstanceId.getInstance().getToken();
        Log.d("DEBUG", "Refreshed token: " + refreshedToken);

    }
}
