//
//  MeetingXomeTests.swift
//  MeetingXomeTests
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import XCTest
@testable import MeetingXome

class LoginRegistrationTests: XCTestCase {
    
    var validUser: User!
    var invalidUser: User!
    var validUserViewModel: UserViewModel!
    var invalidUserViewModel: UserViewModel!
    var addNoteViewModel: AddNoteViewModel!
    var random = String()
    
    override func setUp() {
        super.setUp()
        validUser = User(userName: "Nitesh Singh", userEmail: "niteshsingh12@outlook.com", userPassword: "Hello@123")
        invalidUser = User(userName: "", userEmail: "vishu", userPassword: "hel")
        validUserViewModel = UserViewModel(user: validUser)
        invalidUserViewModel = UserViewModel(user: invalidUser)
        let meeting = Meeting(mTitle: "New Meeting", mDate: "12 July", mNotes: "This is normal sprint meeting", mAuthor: "Nitesh Singh", mDocID: "gcugcuegccyegcuyeg66786")
        addNoteViewModel = AddNoteViewModel(meeting: meeting)
        random = addNoteViewModel.generateUniqueId(8)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        validUser = nil
        invalidUser = nil
    }
    func testUsername() {
        XCTAssertEqual(validUserViewModel.userName.value, "Nitesh Singh")
    }
    
    func testPassword() {
        XCTAssertEqual(validUserViewModel.userPassword.value, "Hello@123")
    }
    func testUpdateUsername() {
        validUserViewModel.updateUserName(userName: "niteshsingh")
        XCTAssertEqual(validUserViewModel.userName.value, "niteshsingh")
    }
    func testUpdatePassword() {
        validUserViewModel.updatePassword(password: "Hello")
        XCTAssertEqual(validUserViewModel.userPassword.value, "Hello")
    }
    func testUpdateEmail() {
        validUserViewModel.updateEmail(email: "niteshsingh12@outlook.com")
        XCTAssertEqual(validUserViewModel.userEmail.value, "niteshsingh12@outlook.com")
    }
    
    func testIfUserIsValid() {
        let validation = validUserViewModel.validate()
        
        if case .valid = validation {
            XCTAssert(true)
        }
    }
    func testIfUserIsInvalid() {
        let validation = invalidUserViewModel.validate()
        
        if case .invalid = validation {
            XCTAssert(true)
        }
    }
    
    func testValidateFieldMissing() {
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Please enter required fields")
        } else {
            XCTAssert(false)
        }
    }
    func testValidateUsernameLength() {
        invalidUserViewModel = UserViewModel(user: User(userName: "nite", userEmail: "niteshsingh12@outlook.com", userPassword: "Hello"))
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Please enter atleast 5 characters user name")
        } else {
            XCTAssert(false)
        }
    }
    func testValidatePasswordLength() {
        invalidUserViewModel = UserViewModel(user: User(userName: "nitesh", userEmail: "niteshsingh12@outlook.com", userPassword: "Hell"))
        let validation = invalidUserViewModel.validate()
        
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Please enter atleast 5 characters password")
        } else {
            XCTAssert(false)
        }
    }
    
    func testLoginSuccess() {
        
        let expectation = self.expectation(description: "LoginCheck")
        var err: Error?
        
        FirebaseNetworking.loginToFirebase(userEmail: validUserViewModel.userEmail.value, userPassword: validUserViewModel.userPassword.value, completionHandler: {
            (message, error) in
            err = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(err)
    }
    
    func testLoginFailure() {
        //When user enters wrong password
        invalidUserViewModel = UserViewModel(user: User(userName: "Nitesh Singh", userEmail: "niteshsingh12@outlook.com", userPassword: "Hell@12"))
        
        FirebaseNetworking.loginToFirebase(userEmail: invalidUserViewModel.userEmail.value, userPassword: invalidUserViewModel.userPassword.value, completionHandler: {
            (message, error) in
            XCTAssertEqual(error?.localizedDescription, "The password is invalid or the user does not have a password.")
            XCTAssertNil(message)
        })
    }
    func testRegisterFailure() {
        let expectation = self.expectation(description: "ModelCheck")
        var err: Error?
        
        let randomUserViewModel = UserViewModel(user: User(userName: "Nitesh Singh", userEmail: "niteshsingh12@outlook.com", userPassword: "Hell@12"))
        
        randomUserViewModel.registerOnFirebase(completionHandler: { error in
            err = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(err?.localizedDescription, "The email address is already in use by another account.")
    }
    
    func testRegisterSuccess() {
        let expectation = self.expectation(description: "ModelCheck2")
        var err: Error?
        
        
        let randomUserViewModel = UserViewModel(user: User(userName: "Nitesh Singh", userEmail: random + "@gmail.com", userPassword: "Hello@12"))
        
        randomUserViewModel.registerOnFirebase(completionHandler: { error in
            err = error
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(err)
    }
    
    func testRegisterUserDictSuccess() {
        validUserViewModel.registerUserDict(completionHandler: {
            error in
            XCTAssertNil(error)
        })
    }
    func testRegisterUserDictFailure() {
        invalidUserViewModel = UserViewModel(user: User(userName: "", userEmail: "", userPassword: ""))
        validUserViewModel.registerUserDict(completionHandler: {
            error in
            XCTAssertNotNil(error)
        })
    }
}
