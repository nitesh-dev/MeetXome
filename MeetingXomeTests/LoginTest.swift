//
//  LoginTest.swift
//  MeetingXomeTests
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import XCTest
@testable import MeetingXome

class LoginTest: XCTestCase {
    
    var validUserViewModel: UserViewModel!
    var invalidUserViewModel: UserViewModel!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let user = User(userName: "nite", userEmail: "nitesh@gmail.com", userPassword: "Hello@123")
        validUserViewModel = UserViewModel(user: user)
        invalidUserViewModel = UserViewModel()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
