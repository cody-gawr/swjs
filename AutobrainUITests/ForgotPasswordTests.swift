//
//  ForgotPasswordTests.swift
//  Autobrain
//
//  Created by Kyle Smith on 10/17/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import XCTest

class ForgotPasswordTests: AutobrainUITests {
        
    override func setUp() {
        super.setUp()
        
        //navigate to create account page
        tapButton(name: "Forgot Password?")
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPressCancel() {
        tapButton(name: "Cancel")
        expectToSeeViewWith(identifier: "loginView")
    }
    
    func testEmptyEmail() {
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Please type in a valid email address.")
    }
    
    func testInvalidEmail() {
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@c")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "Please type in a valid email address.")
    }
    
    func testEmailDoesNotExist() {
        fillInTextField(identifier: "emailTextField", text: "johnnyappleseed194@myautobrain.co")
        tapButton(name: "Submit")
        expectToSeeAlertWith(title: "Invalid Email", message: "We could not find an account with that email. Try again.")
    }
    
    func testValidEmail() {
        fillInTextField(identifier: "emailTextField", text: "john@example.com")
        tapButton(name: "Submit")
        
        XCTAssertEqual(app.alerts.element.label, "Success")
        tapButton(name: "Ok, Thanks")
        expectToSeeViewWith(identifier: "loginView")
    }
}
