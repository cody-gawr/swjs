//
//  AutobrainUITests.swift
//  AutobrainUITests
//
//  Created by Kyle Smith on 10/13/17.
//  Copyright © 2017 SWJG-Ventures, LLC. All rights reserved.
//

import XCTest

class AutobrainUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launchArguments += ["UI-Testing"]
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        app.launchArguments.removeAll()
    }
 
    // MARK: - Shared UITest functions
    
    // Fill in a textField with accessibilityIdentifier with text of your choice.
    // isSecure is used for password fields to work properly
    func fillInTextField(identifier: String, text: String, isSecure: Bool = false) {
        let textField =  isSecure ? app.secureTextFields[identifier] : app.textFields[identifier]
        textField.tap()
        textField.clearAndEnterText(text: text)
    }
    
    func tapButton(name: String) {
        app.buttons[name].tap()
    }
    
    // Look for a view in the heirarchy with accessibilityIdentifier
    func expectToSeeViewWith(identifier: String) {
        sleep(UInt32(2.5))
        XCTAssertTrue(app.otherElements[identifier].exists, "Unable to find view with identifier \(identifier).")
    }
    
    // Check for a navigation bar with title
    func expectToSeeNavigationWith(title: String) {
        XCTAssertTrue(app.navigationBars.staticTexts[title].exists)
    }
    
    // Check for a custom modal alert with title and message
    func expectToSeeAlertWith(title: String, message: String) {
        expectToSeeViewWith(identifier: "alertView")
        XCTAssertTrue(app.staticTexts[title].exists, "Unable to find label with text \(title).")
        XCTAssertTrue(app.staticTexts[message].exists, "Unable to find label with text \(message).")
    }
}

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        // let deleteString = stringValue.characters.map { _ in convertFromXCUIKeyboardKey(XCUIKeyboardKey.delete) }.joined(separator: "")
        
        self.typeText(deleteString)
        self.typeText(text)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromXCUIKeyboardKey(_ input: XCUIKeyboardKey) -> String {
	return input.rawValue
}
