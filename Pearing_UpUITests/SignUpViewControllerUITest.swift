//
//  SignUpViewControllerUITest.swift
//  Pearing_UpUITests
//
//  All tests revolve around the sign up feature
//
//  Created by Ali Arshad on 2018-06-30.
//  Copyright © 2018 Manan Maniyar. All rights reserved.
//

import XCTest

class SignUpViewControllerUITest: XCTestCase {
    
    
    
    private let app = XCUIApplication()
    private var username = "ilovetrees78"
    private var username2 = "treesareokay"
    private var username3 = "ali"
    private var username4 = "ali1"
    private var email = "ilovetrees78@sfu.ca"
    private var email2 = "treesareokay@tree.com"
    private var email3 = "ali@sfu.ca"
    private var email4 = "aaa@sfu.ca"
    private var password = "tree3"
    private var wrongPassword = "tree34"
    private let fullName = "Tree Man"
    private let address = "12345 Tree Street"
    private let city = "Tree Town"
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app.buttons["SIGN UP"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    private func getBackspaces(numberOfBackspaces: Int) -> String{
        let bs = String(UnicodeScalar(8))
        return String(repeating: "\(bs)", count: numberOfBackspaces)
    }
    
    func testCorrectSignUp() {
        
        app.textFields["htsang"].tap()
        app.typeText(username)
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(email)
        app.secureTextFields["Password"].tap()
        app.typeText(password)
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(password)
        app.buttons["NEXT"].tap()
        
        app.textFields["Herbert Tsang"].tap()
        app.typeText(fullName)
        app.textFields["8888 University Drive"].tap()
        app.typeText(address)
        app.textFields["Burnaby"].tap()
        app.typeText(city)
        app.buttons["REGISTER"].tap()
        
        XCTAssert(app.buttons["LOG IN"].exists)
    }
    
    func testDuplicateSignUp() {
        //Duplicate username and email
        app.textFields["htsang"].tap()
        app.typeText(username)
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(email)
        app.secureTextFields["Password"].tap()
        app.typeText(password)
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(password)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //Duplicate email
        app.textFields["htsang"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: username.count) + username2)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //Duplicate username
        app.textFields["htsang"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: username2.count) + username)
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: email.count) + email2)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //Correct Info
        app.textFields["htsang"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: username.count) + username2)
        app.buttons["NEXT"].tap()
        
        app.textFields["Herbert Tsang"].tap()
        app.typeText(fullName)
        app.textFields["8888 University Drive"].tap()
        app.typeText(address)
        app.textFields["Burnaby"].tap()
        app.typeText(city)
        app.buttons["REGISTER"].tap()
        
        XCTAssert(app.buttons["LOG IN"].exists)
    }
    
    func testEmptyFields() {
        
        //No fields
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //No username
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(email3)
        app.secureTextFields["Password"].tap()
        app.typeText(password)
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(password)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //No email
        app.textFields["htsang"].tap()
        app.typeText(username3)
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: email3.count))
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //No first password
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(email3)
        app.secureTextFields["Password"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: password.count))
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //Neither passwords
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: password.count))
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //No confirm password
        app.secureTextFields["Password"].tap()
        app.typeText(password)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //Correct Login
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(password)
        app.buttons["NEXT"].tap()
        
        app.buttons["REGISTER"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //No address or city
        app.textFields["Herbert Tsang"].tap()
        app.typeText(fullName)
        app.buttons["REGISTER"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //No city
        app.textFields["8888 University Drive"].tap()
        app.typeText(address)
        app.buttons["REGISTER"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        //Correct user info
        app.textFields["Burnaby"].tap()
        app.typeText(city)
        app.buttons["REGISTER"].tap()
        
        XCTAssert(app.buttons["LOG IN"].exists)
        print("Test Worked!")
    }
    
    func testInvalidPasswords() {
        app.textFields["htsang"].tap()
        app.typeText(username4)
        app.textFields["htsang@sfu.ca"].tap()
        app.typeText(email4)
        app.secureTextFields["Password"].tap()
        app.typeText(password)
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(wrongPassword)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        app.secureTextFields["Password"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: password.count) + wrongPassword)
        app.secureTextFields["Confirm Password"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: wrongPassword.count) + password)
        app.buttons["NEXT"].tap()
        
        app.alerts["Alert"].buttons["Ok"].tap()
        
        app.secureTextFields["Password"].tap()
        app.typeText(getBackspaces(numberOfBackspaces: wrongPassword.count) + password)
        app.buttons["NEXT"].tap()
        
        app.textFields["Herbert Tsang"].tap()
        app.typeText(fullName)
        app.textFields["8888 University Drive"].tap()
        app.typeText(address)
        app.textFields["Burnaby"].tap()
        app.typeText(city)
        app.buttons["REGISTER"].tap()
        
        XCTAssert(app.buttons["LOG IN"].exists)
    }
}
