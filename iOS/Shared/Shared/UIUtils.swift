//
//  Utils.swift
//  Shared
//
//  Created by kankan on 26/04/20.
//  Copyright © 2020 queuesafe. All rights reserved.
//

import Foundation
import MaterialTextField
import MaterialTextField.UIColor_MaterialTextField
import SwiftSpinner

public class UIUtils {
    public static func updateTextFieldsStyle(textfields: [MFTextField]) {
        textfields.forEach { (textfield) in
            let color = UIColor(named: "PositiveButtonColor", in: Bundle(for: UIUtils.self), compatibleWith: nil)!
            textfield.tintColor = color
        }
    }
    
    public static func clearValidationErrors(textfields: [MFTextField]) {
        textfields.forEach { (textfield) in
            textfield.setError(nil, animated: false)
        }
    }
    
    public static func validateEmails(emailContianer: MFTextField, confirmEmailContainer: MFTextField) -> Bool {
        let isValidIndividualEmail = validateTextField(type: InputType.Email, container: emailContianer) && validateTextField(type: InputType.Email, container: confirmEmailContainer)
        if isValidIndividualEmail {
            let email = emailContianer.text
            let emailConfirm = confirmEmailContainer.text
            if email != emailConfirm {
                let error = errorFromMessage("Email address don't match")
                confirmEmailContainer.setError(error, animated: true)
            } else {
                return true
            }
        }
        return false
    }
    
    public static func validateTextField(type: InputType, container: MFTextField) -> Bool {
        let regexInfo = getRegexInfo(type: type)
        guard let regex = try? NSRegularExpression(pattern: regexInfo.regexValue, options: []) else {
            container.setError(nil, animated: true)
            return true
        }
        
        guard let text = container.text, text.count > 0 else {
            let error = errorFromMessage("This field is required.")
            container.setError(error, animated: true)
            return false
        }
        
        if  regex.firstMatch(in: text, options: [], range: NSMakeRange(0, text.count)) == nil {
            let error = errorFromMessage(regexInfo.errorMessage)
            container.setError(error, animated: true)
            return false
        } else {
            container.setError(nil, animated: true)
            return true
        }
    }
    
    private static func errorFromMessage(_ text: String) -> NSError {
        return NSError(domain: "TextValidation", code: 1, userInfo: [NSLocalizedDescriptionKey: text])
    }
    
    private static func getRegexInfo(type: InputType) -> RegexInfo {
        switch type {
        case .Email:
            return RegexInfo("^[0-9a-zA-Z_\\-\\.]+@[0-9a-zA-Z_\\-]+(\\.[0-9a-zA-Z_\\-]+)*$", "Invalid email format")
        case .Password:
            return RegexInfo("^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$", "Password must contain at least one letter, at least one number, and be longer than six characters.")
        case .Phone:
            return RegexInfo("^[0-9\\+\\-]+$", "Phone number must only contain +, - and numbers.")
        case .BusinessName:
            return RegexInfo("^((?![\\^!@#$*~[&lt;][>] ?]).)((?![\\^!@#$*~?[&lt;][>]]).)*((?![\\^!@#$*~ ?[&lt;][>]]).)$", "The business name you entered contains invalid characters.")
        case .BusinessID:
            return RegexInfo("^[0-9a-zA-Z\\-]+$", "The business id you entered contains invalid characters.")
        case .Street:
            return RegexInfo("^[0-9a-zA-Z\\-_,\\.&\\s]+$", "The address you entered contains invalid characters.")
        case .Suburb:
            return RegexInfo("^[0-9a-zA-Z\\-\\s]+$", "The suburb you entered contains invalid characters.")
        case .City:
            return RegexInfo("^[0-9a-zA-Z\\-\\s]+$", "The city you entered contains invalid characters.")
        case .State:
            return RegexInfo("[0-9a-zA-Z\\-\\s]+", "The state you entered contains invalid characters.")
        case .ZipCode:
            return RegexInfo("^[0-9]+$", "Numbers only")
        }
    }
    
    public static func showloading() {
        SwiftSpinner.setTitleFont(UIFont.systemFont(ofSize: 15))
        SwiftSpinner.show("Loading...", animated: true)
    }
    
    public static func hideloading() {
        SwiftSpinner.hide()
    }
}

public enum InputType {
    case Email, Password, Phone, BusinessName, BusinessID, Street, Suburb, City, State, ZipCode
}

private class RegexInfo {
    let regexValue: String
    let errorMessage: String
    init(_ regexValue: String, _ errorMessage: String) {
        self.regexValue = regexValue
        self.errorMessage = errorMessage
    }
}
