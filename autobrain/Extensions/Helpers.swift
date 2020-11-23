//
//  Helpers.swift
//  Autobrain
//
//  Created by Kyle Smith on 9/20/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

class Helpers: NSObject {
    
    //MARK: - Form validation
    static func isEmailValid(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isNameValid(name: String) -> Bool {
        return name.utf8CString.count > 1 ? true : false
    }
    
    static func isPasswordValid(password: String) -> Bool {
        return password.utf8CString.count > 5 ? true : false
    }
    
    static func doPasswordsMatch(password: String, confirm: String) -> Bool {
        return password == confirm ? true : false
    }
    
    static func isPhoneValid(phone: String) -> Bool {
        return phone.utf8CString.count == 14 ? true : false
    }
    
    static func unformatPhoneNumber(phone: String) -> String {
        var formattedPhone = phone
        formattedPhone.remove(at: formattedPhone.startIndex)
        formattedPhone.remove(at: formattedPhone.index(formattedPhone.startIndex, offsetBy: 3))
        formattedPhone.remove(at: formattedPhone.index(formattedPhone.startIndex, offsetBy: 3))
        formattedPhone.remove(at: formattedPhone.index(formattedPhone.startIndex, offsetBy: 6))
        return formattedPhone
    }
    
    // MARK: -
    static func calculateDaysSinceDate(date: String) -> Int {
        //"2015-04-13T12:48:23.310Z"
        let dateFormatter = DateFormatter() 
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = dateFormatter.date(from: date) {
            let calendar = Calendar.current
            let dayComponents = calendar.dateComponents([.day], from: date, to: Date())
            let days = dayComponents.day!
            return days
        }
        
        return -1
    }
    
    
}
