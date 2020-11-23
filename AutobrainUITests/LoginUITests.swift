//
//  LoginUITests.swift
//  Autobrain
//
//  Created by Kyle Smith on 10/16/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import XCTest

class LoginUITests: AutobrainUITests {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testEmptyUsername() {
        fillInTextField(identifier: "passwordTextField", text: "welcome", isSecure: true)
        tapButton(name: "Log in")
        expectToSeeAlertWith(title: "Login Error", message: "Your username or password is empty!")
    }

    func testEmptyPassword() {
        fillInTextField(identifier: "emailTextField", text: "john@example.com")
        tapButton(name: "Log in")
        expectToSeeAlertWith(title: "Login Error", message: "Your username or password is empty!")
    }

    func testWrongUsername() {
        fillInTextField(identifier: "emailTextField", text: "johnnyboy@example.com")
        fillInTextField(identifier: "passwordTextField", text: "welcome", isSecure: true)
        tapButton(name: "Log in")
        expectToSeeAlertWith(title: "Login Error", message: "Your username and password combination is incorrect.")
    }

    func testWrongPassword() {
        fillInTextField(identifier: "emailTextField", text: "john@example.com")
        fillInTextField(identifier: "passwordTextField", text: "unwelcomed", isSecure: true)
        tapButton(name: "Log in")
        expectToSeeAlertWith(title: "Login Error", message: "Your username and password combination is incorrect.")
    }

    func testValidLogin() {
        fillInTextField(identifier: "emailTextField", text: "john@example.com")
        fillInTextField(identifier: "passwordTextField", text: "welcome", isSecure: true)
        tapButton(name: "Log in")
        expectToSeeViewWith(identifier: "mainView")
    }

//    func testForgotPassword() {
//        tapButton(name: "Forgot Password?")
//        expectToSeeViewWith(identifier: "forgotPasswordView")
//    }

    func testTermsOfUse() {
        tapButton(name: "Terms of Use")
        expectToSeeViewWith(identifier: "termsView")
        tapButton(name: "Done")
    }

    func testPrivacyPolicy() {
        tapButton(name: "Privacy Policy")
        expectToSeeViewWith(identifier: "termsView")
        tapButton(name: "Done")
    }

//    func testCreateAccount() {
//        tapButton(name: "Create Account")
//        expectToSeeViewWith(identifier: "createAccountView")
//    }
    
    func testNeedADevice() {
        tapButton(name: "Need a Device?")
        //expect to see a webView
    }
}
