/*! Copyright 2017 Ayogo Health Inc. */

package com.ayogo.cordova.appscope;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;


public class AppScopePlugin extends CordovaPlugin {
    private String appScope;

    private final String TAG = "AppScopePlugin";


    /**
     * Called after plugin construction and fields have been initialized.
     */
    @Override
    public void pluginInitialize() {
        LOG.v(TAG, "Initializing");

        this.appScope = preferences.getString("scope", null);

        onNewIntent(cordova.getActivity().getIntent());
    }



    /**
     * Called when the activity receives a new intent.
     */
    @Override
    public void onNewIntent(Intent intent) {
        if (intent == null || !intent.getAction().equals(Intent.ACTION_VIEW)) {
            return;
        }

        final Uri intentUri = intent.getData();

        LOG.v(TAG, "Handling intent URL: " + intentUri.toString());

        if (intentUri.toString().startsWith(this.appScope)) {
            this.webView.loadUrlIntoView(intentUri.toString(), true);
        }
    }


    /**
     * Hook for blocking the loading of external resources.
     */
    @Override
    public Boolean shouldAllowRequest(String url) {
        if (url.startsWith(this.appScope)) {
            return true;
        }

        return null;
    }


    /**
     * Hook for blocking navigation by the Cordova WebView.
     *
     * This applies both to top-level and iframe navigations.
     */
    @Override
    public Boolean shouldAllowNavigation(String url) {
        if (url.startsWith(this.appScope)) {
            return true;
        }

        return null;
    }


    /**
     * Hook for redirecting requests.
     *
     * Applies to WebView requests as well as requests made by plugins.
     */
    @Override
    public Uri remapUri(Uri uri) {
        if (!uri.toString().startsWith(this.appScope)) {
            return null;
        }

        String remapped = uri.toString().replace(this.appScope, "file:///android_asset/www/");
        return Uri.parse(remapped);
    }
}