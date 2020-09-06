package com.queuesafe.shared.ui

import android.app.Activity
import android.content.Context
import android.content.DialogInterface
import android.view.WindowManager
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.textfield.TextInputLayout
import com.queuesafe.shared.R
import com.queuesafe.shared.service.ServiceError


object UIUtils {
    fun showLoading(activity: AppCompatActivity) {
        LoadingFragment().show(activity.supportFragmentManager, LoadingFragment.TAG)
    }

    fun hideLoading(activity: AppCompatActivity) {
        val fragment = activity.supportFragmentManager.findFragmentByTag(LoadingFragment.TAG) as? LoadingFragment
        fragment?.dismiss()
    }

    fun hideKeyboard(activity: Activity) {
        val imm =
            activity.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
        val view = activity.currentFocus
        if (view != null && view.windowToken != null && EditText::class.java.isAssignableFrom(view.javaClass)) {
            view.clearFocus()
            imm?.hideSoftInputFromWindow(view.windowToken, 0)
        } else {
            activity.window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN)
        }
    }

    fun clearErrors(errorHandler: List<TextInputLayout>) {
        errorHandler.forEach {
            it.isErrorEnabled = false
            it.error = null
        }
    }

    fun validatePassword(password: String, passwordErrorHandler: TextInputLayout): Boolean {
        if (!password.matches(passwordErrorHandler.resources.getString(R.string.password_regex).toRegex())) {
            passwordErrorHandler.isErrorEnabled = true
            passwordErrorHandler.error = passwordErrorHandler.resources.getString(R.string.reg_error_password_not_match)
            return false
        }
        return true
    }

    fun validateEmails(email: String, emailErrorHandler: TextInputLayout, emailConfirm: String, emailConfirmErrorHandler: TextInputLayout): Boolean {
        val areIndividualsValid = validateEmail(email, emailErrorHandler) and
                validateEmail(emailConfirm, emailConfirmErrorHandler)
        if (areIndividualsValid) {
            if (email == emailConfirm) {
                return true
            } else {
                emailConfirmErrorHandler.isErrorEnabled = true
                emailConfirmErrorHandler.error = emailConfirmErrorHandler.resources.getString(R.string.reg_error_email_not_match)
            }
        }
        return false
    }

    fun validateEmail(email: String, errorHandler: TextInputLayout): Boolean {
        if (email.isEmpty()) {
            errorHandler.isErrorEnabled = true
            errorHandler.error = errorHandler.resources.getString(R.string.error_field_required)
            return false
        }
        if (!email.matches(errorHandler.resources.getString(R.string.email_regex).toRegex())) {
            errorHandler.isErrorEnabled = true
            errorHandler.error = errorHandler.resources.getString(R.string.reg_error_invalid_email)
            return false
        }
        return true
    }

    fun validateField(type: InputFieldType, value: String, errorHandler: TextInputLayout): Boolean {
        if (value.isEmpty()) {
            errorHandler.isErrorEnabled = true
            errorHandler.error = errorHandler.resources.getString(R.string.error_field_required)
            return false
        }
        val regexInfo = getRegexInfo(type)
        if (!value.matches(errorHandler.resources.getString(regexInfo.regexResourceID).toRegex())) {
            errorHandler.isErrorEnabled = true
            errorHandler.error = errorHandler.resources.getString(regexInfo.errorMessageResourceID)
            return false
        }
        return true
    }

    private fun getRegexInfo(type: InputFieldType): RegexInfo {
        return when(type) {
            InputFieldType.Phone -> RegexInfo(R.string.phone_regex, R.string.reg_error_invalid_phone)
            InputFieldType.BusinessName -> RegexInfo(R.string.business_name_regex, R.string.reg_error_business_name)
            InputFieldType.BusinessID -> RegexInfo(R.string.business_id_regex, R.string.reg_error_business_id)
            InputFieldType.Street -> RegexInfo(R.string.street_regex, R.string.reg_error_street)
            InputFieldType.Suburb -> RegexInfo(R.string.suburb_regex, R.string.reg_error_suburb)
            InputFieldType.City -> RegexInfo(R.string.city_regex, R.string.reg_error_city)
            InputFieldType.State -> RegexInfo(R.string.state_regex, R.string.reg_error_state)
            InputFieldType.ZipCode -> RegexInfo(R.string.zipcode_regex, R.string.reg_error_zipcode)
        }
    }

    fun handleServiceError(activity: AppCompatActivity, error: ServiceError?, buttonClickHandler: DialogInterface.OnClickListener?) {
        error ?: return
        var message = error.errorMessage
        val messageID = error.messageID
        if (messageID != null) {
            message = activity.getString(messageID)
        }
        if (message != null) {
            showErrorMessage(activity, message, buttonClickHandler)
        } else {
            showErrorMessage(activity, activity.getString(R.string.generic_error_message), buttonClickHandler)
        }
    }

    fun showErrorMessage(activity: AppCompatActivity, message: String, buttonClickHandler: DialogInterface.OnClickListener? = null) {
        val dialog = AlertDialog.Builder(activity)
            .setMessage(message)
            .setNegativeButton(R.string.dialog_button_ok, buttonClickHandler)
            .setCancelable(buttonClickHandler == null)
            .create()
        dialog.show()
    }

    fun handleServiceError(activity: AppCompatActivity, error: ServiceError?) {
        handleServiceError(activity, error, null)
    }
}

enum class InputFieldType {
    Phone,
    BusinessName,
    BusinessID,
    Street,
    Suburb,
    City,
    State,
    ZipCode
}

data class RegexInfo(val regexResourceID: Int, val errorMessageResourceID: Int)
