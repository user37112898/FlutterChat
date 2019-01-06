package com.example.flutterchatapplication;

import android.content.Context;

import io.flutter.app.FlutterApplication;

import android.support.multidex.MultiDex;


public class ChatApp extends FlutterApplication
{
    @Override
    protected void attachBaseContext(Context base)
    {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }
}
