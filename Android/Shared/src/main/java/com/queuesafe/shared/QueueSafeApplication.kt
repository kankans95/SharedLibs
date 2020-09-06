package com.queuesafe.shared

import android.app.Application
import android.content.Context
import java.lang.ref.WeakReference

class QueueSafeApplication : Application() {
    init {
        applicationInstance = WeakReference<QueueSafeApplication>(this)
    }
    companion object {
        private var applicationInstance: WeakReference<QueueSafeApplication>? = null
        fun getApplicationContext(): Context? {
            applicationInstance?.get()?.applicationContext?.let {
                return it
            }
            return null
        }
    }
}