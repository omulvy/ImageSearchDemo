//
//  ImageSearchDemoUITests.swift
//  ImageSearchDemoUITests
//
//  Created by Mark Mulvehill on 6/3/18.
//  Copyright © 2018 Adroita. All rights reserved.
//

import XCTest

class ImageSearchDemoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBlankField(){
        XCUIApplication().buttons["Google Image Search"].tap()
        //TODO record more when not overlimit
    }
    
    func testBasicSearchResultDetail(){
        //Happy Path
        let app = XCUIApplication()
        let textField = app.otherElements.containing(.staticText, identifier:"Enter Search Terms").children(matching: .textField).element
        textField.tap()
        textField.typeText("")
        textField.typeText("Minneapolis Sunset")
        app.buttons["Google Image Search"].tap()
        
        //TODO record more when limit resets
    }
    

    
}
