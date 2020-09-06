package com.queuesafe.shared.service

import com.google.gson.Gson
import com.google.gson.JsonIOException
import com.google.gson.JsonSyntaxException
import com.google.gson.annotations.SerializedName
import com.queuesafe.shared.R
import okhttp3.ResponseBody


enum class Status {
    ERROR, SUCCESS, LOADING
}

data class ModelWrapper<out T>(val status: Status, val model: T? = null, val error: ServiceError? = null) {
    companion object {
        fun <T> success(model: T? = null): ModelWrapper<T> {
            return ModelWrapper(
                Status.SUCCESS,
                model
            )
        }

        fun <T> failure(error: ServiceError? = null, model: T? = null): ModelWrapper<T> {
            return ModelWrapper(
                Status.ERROR,
                model,
                error
            )
        }

        fun <T> loading(model: T? = null): ModelWrapper<T> {
            return ModelWrapper(
                Status.LOADING,
                model
            )
        }
    }
}

data class ServiceError(
    @SerializedName("Code") val errorCode: Int? = null,
    var messageID: Int? = null,
    @SerializedName("Message") val errorMessage: String? = null) {
    companion object{
        fun fromResponse(body: ResponseBody?): ServiceError {
            body ?: return ServiceError(R.string.generic_error_message)
            return try {
                Gson().fromJson(body.charStream(), ServiceError::class.java)
            } catch (e: Exception){
                ServiceError(R.string.generic_error_message)
            }
        }
    }
}