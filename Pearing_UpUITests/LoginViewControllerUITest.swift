//
//  LoginViewControllerUITest.swift
//  Pearing_UpUITests
//
//  Created by Ali Arshad on 2018-07-02.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import XCTest

class LoginViewControllerUITest: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.buttons["LOG IN"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCorrectLogin() {
        app.navigationBars["Pearing_Up.LoginView"].buttons["Back"].tap()
        app.buttons["SIGN UP"].tap()
        SignUpViewControllerUITest().testCorrectSignUp()
        
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText("ilovetrees78@sfu.ca")
        app.secureTextFields["Password"].tap()
        app.typeText("tree3")
        app.buttons["LOG IN"].tap()
    }
    
}
