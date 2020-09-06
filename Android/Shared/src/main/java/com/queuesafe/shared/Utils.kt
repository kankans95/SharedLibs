package com.queuesafe.shared

import android.content.Context

object Utils {
    private const val preferencesFileName = "com.xasino.queuesafe"
    private const val TOKEN = "token"
    private const val PUSH_TOKEN = "pushToken"
    private const val MEMBERED_ID = "rememberedID"

    private fun saveKeyValueToSharePreferences(
        context: Context,
        key: String,
        value: String
    ) {
        val sharedPreferences = context.getSharedPreferences(
            preferencesFileName,
            Context.MODE_PRIVATE
        )
        val editor = sharedPreferences.edit()
        editor.putString(key, value)
        editor.apply()
    }

    private fun getValueFromKeyInSharedPreferences(
        context: Context,
        key: String
    ): String? {
        val sharedPreferences = context.getSharedPreferences(
            preferencesFileName,
            Context.MODE_PRIVATE
        )
        return if (sharedPreferences.contains(key)) {
            sharedPreferences.getString(key, "")
        } else {
            null
        }
    }

    fun saveMemberID(context: Context, token: String) {
        saveKeyValueToSharePreferences(context, MEMBERED_ID, token)
    }

    fun getMemberID(context: Context): String? {
        return getValueFromKeyInSharedPreferences(context, MEMBERED_ID)
    }

    fun savePushToken(context: Context, token: String) {
        saveKeyValueToSharePreferences(context, PUSH_TOKEN, token)
    }

    fun getPushToken(context: Context): String? {
        return getValueFromKeyInSharedPreferences(context, PUSH_TOKEN)
    }

    fun saveToken(context: Context, token: String) {
        saveKeyValueToSharePreferences(context, TOKEN, token)
    }

    fun getToken(context: Context): String? {
        return getValueFromKeyInSharedPreferences(context, TOKEN)
    }

    fun resetPushToken(context: Context) {
        val sharedPreferences = context.getSharedPreferences(
            preferencesFileName,
            Context.MODE_PRIVATE
        )
        val editor = sharedPreferences.edit()
        editor.remove(PUSH_TOKEN)
        editor.apply()
    }

    fun resetToken(context: Context) {
        val sharedPreferences = context.getSharedPreferences(
            preferencesFileName,
            Context.MODE_PRIVATE
        )
        val editor = sharedPreferences.edit()
        editor.remove(TOKEN)
        editor.apply()
    }

    fun resetAll(context: Context) {
        val sharedPreferences = context.getSharedPreferences(
            preferencesFileName,
            Context.MODE_PRIVATE
        )
        val editor = sharedPreferences.edit()
        editor.remove(TOKEN)
        editor.remove(PUSH_TOKEN)
        editor.apply()
    }
}