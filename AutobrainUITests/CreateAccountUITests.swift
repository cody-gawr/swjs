//
//  CreateAccountUITests.swift
//  Autobrain
//
//  Created by Kyle Smith on 10/16/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import XCTest

class CreateAccountUITests: AutobrainUITests {
    
    override func setUp() {
        super.setUp()
        
        //navigate to create account page
        tapButton(name: "Create Account")
        
        //make sure the navigation bar is showing on every load -- been having issues
        expectToSeeNavigationWith(title: "Create Account")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //First name checks against length (>2)
    func testEmptyFirst() {
        fillInTextField(identifier: "firstTextField", text: "")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid First", message: "Your first name is invalid. Please fix it.")
    }
    
    func testInvalidFirst() {
        fillInTextField(identifier: "firstTextField", text: "a")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid First", message: "Your first name is invalid. Please fix it.")
    }
    
    // This can test multiple things at once
    func testValidFirstAndEmptyOrInvalidLast() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Last", message: "Your last name is invalid. Please fix it.")
        
        fillInTextField(identifier: "lastTextField", text: "a")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Last", message: "Your last name is invalid. Please fix it.")
    }
    
    func testValidLastAndEmptyOfInvalidEmail() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Your email is not valid. Please fix it.")
        
        fillInTextField(identifier: "emailTextField", text: "johnboy@")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Your email is not valid. Please fix it.")
        
        fillInTextField(identifier: "emailTextField", text: "johnboy@a.c")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Your email is not valid. Please fix it.")
        
        fillInTextField(identifier: "emailTextField", text: "ax@b.com.ske.28389djkbka")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Your email is not valid. Please fix it.")
    }
    
    func testTakenEmail() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "john@example.com")
        app.textFields["phoneTextField"].tap()
        expectToSeeAlertWith(title: "Invalid Email", message: "Email is already in use.")
    }
    
    func testInvalidEmailIntoValidEmailAndEmptyPhone() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnboy@")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Your email is not valid. Please fix it.")
        
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Phone", message: "Your phone number is not valid. Please fix it.")
    }
    
    // Currently allows letters in the name. Needs to be fixed.
    // Phone numbers cannot be longer than 10 characters
    func testPhoneNumberTooShort() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "828283838")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Phone", message: "Your phone number is not valid. Please fix it.")
    }
    
    func testValidPhoneNumber() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "5046067089")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Password", message: "Your password needs to be at least 8 characters")
    }
    
    func testEmptyPasswordWithValidConfirm() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "5046067089")
        fillInTextField(identifier: "confirmTextField", text: "password", isSecure: true)
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Password", message: "Your password needs to be at least 8 characters")
    }
    
    func testPasswordTooShortWithValidConfirm() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "5046067089")
        fillInTextField(identifier: "passwordTextField", text: "passw", isSecure: true)
        fillInTextField(identifier: "confirmTextField", text: "password", isSecure: true)
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Password", message: "Your password needs to be at least 8 characters")
    }
    
    func testValidPasswordWithEmptyConfirm() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "5046067089")
        fillInTextField(identifier: "passwordTextField", text: "password", isSecure: true)
        fillInTextField(identifier: "confirmTextField", text: "", isSecure: true)
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Confirm", message: "Your passwords do not match.")
    }
    
    func testValidPasswordWithConfirmTooShort() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "5046067089")
        fillInTextField(identifier: "passwordTextField", text: "password", isSecure: true)
        fillInTextField(identifier: "confirmTextField", text: "passw", isSecure: true)
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Confirm", message: "Your passwords do not match.")
    }
    
    func testMismatchedValidPasswords() {
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@myautobrain.com")
        fillInTextField(identifier: "phoneTextField", text: "5046067089")
        fillInTextField(identifier: "passwordTextField", text: "password", isSecure: true)
        fillInTextField(identifier: "confirmTextField", text: "password1", isSecure: true)
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Confirm", message: "Your passwords do not match.")
    }
    
    // TODO: Fix main code to send back appropriate code from phone number with letters, then make test. Just says server error now.
    func testSuccessfulAccountCreation() {
        let time = UInt32(NSDate().timeIntervalSinceReferenceDate)
        srand48(Int(time))
        var username = drand48()
        username = username * 10
        
        fillInTextField(identifier: "firstTextField", text: "Johnny")
        fillInTextField(identifier: "lastTextField", text: "Boy")
        fillInTextField(identifier: "emailTextField", text: String(username) + "@m.com")
        fillInTextField(identifier: "phoneTextField", text: "5555555555")
        fillInTextField(identifier: "passwordTextField", text: "password", isSecure: true)
        fillInTextField(identifier: "confirmTextField", text: "password", isSecure: true)
        tapButton(name: "Submit")
        
        XCTAssertEqual(app.alerts.element.label, "Success")
        tapButton(name: "Ok, Thanks")
        expectToSeeViewWith(identifier: "loginView")
    }
}
