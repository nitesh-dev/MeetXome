//
//  MeetingXomeUITests.swift
//  MeetingXomeUITests
//
//  Created by Nitesh Singh # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import XCTest
@testable import MeetingXome

class MeetingXomeUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    
}
