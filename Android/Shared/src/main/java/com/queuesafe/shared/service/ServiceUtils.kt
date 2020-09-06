package com.queuesafe.shared.service

import android.content.Context
import android.text.TextUtils
import com.auth0.android.jwt.JWT
import com.google.gson.GsonBuilder
import com.queuesafe.shared.QueueSafeApplication
import com.queuesafe.shared.Utils
import com.queuesafe.shared.ui.UIUtils
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import okhttp3.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory


object ServiceUtils {
    private const val baseUrl = "https://api.queuesafe.net"

    val client: OkHttpClient = OkHttpClient.Builder()
        .addInterceptor(HeaderInterceptor())
        .build()

    val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(baseUrl)
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    private var myAccessToken: AccessToken? = null

    fun getAccessToken(): AccessToken? {
        if (myAccessToken == null) {
            QueueSafeApplication.getApplicationContext()?.let {
                val tokenValue = Utils.getToken(it)
                tokenValue?.let {
                    myAccessToken = AccessToken(it)
                }
            }
        }
        return myAccessToken
    }

    fun setAccessToken(tokenValue: String?) {
        tokenValue?.let { it ->
            myAccessToken = AccessToken(it)
            QueueSafeApplication.getApplicationContext()?.let { context ->
                Utils.saveToken(context, it)
            }
            return
        }
        myAccessToken = null
        QueueSafeApplication.getApplicationContext()?.let {
            Utils.resetToken(it)
        }
    }

    fun resetAuthInfo(context: Context) {
        setAccessToken(null)
        Utils.resetPushToken(context)
    }
}

class AccessToken(val tokenValue: String) {
    private var jwt: JWT? = null

    init {
        val tokenSlices = tokenValue.split(' ')
        if (tokenSlices.size > 1) {
            val token = tokenSlices[1]
            try {
                jwt = JWT(token)
            } catch (e: Exception) {}
        }
    }

    fun isTokenExpired(): Boolean {
        jwt ?: return true
        return jwt!!.isExpired(5)
    }

    fun isManagerToken(): Boolean {
        val queueStatus = jwt?.getClaim("QUEUE")
        queueStatus ?: return false
        val queueStatusValue = queueStatus.asString()
        queueStatusValue ?: return false
        return queueStatusValue.split(',').contains("QUEUE_NEXT")
    }
}

class HeaderInterceptor : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response = chain.run {
        var request = request()

        val tokenValue = ServiceUtils.getAccessToken()?.tokenValue
        if (!tokenValue.isNullOrEmpty()) {
            request = request
                .newBuilder()
                .addHeader("Authorization", tokenValue)
                .build()
        }

        val response = proceed(
            request
        )
        val token  = response.header("WWW-Authenticate")
        if (!token.isNullOrEmpty()) {
            ServiceUtils.setAccessToken(token)
        }
        return response
    }
}