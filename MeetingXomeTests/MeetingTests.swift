//
//  MeetingTests.swift
//  MeetingXomeTests
//
//  Created by Cognizant Technology Solutions # 2 on 27/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import XCTest
@testable import MeetingXome

class MeetingTests: XCTestCase {
    
    
    var validMeeting: Meeting!
    var invalidMeeting: Meeting!
    var validMeetingViewModel: AddNoteViewModel!
    var invalidMeetingViewModel: AddNoteViewModel!
    var meetingListModel: MeetingListViewModel?
    
    override func setUp() {
        super.setUp()
        validMeeting = Meeting(mTitle: "New Meeting", mDate: "12 July", mNotes: "This is normal sprint meeting", mAuthor: "Nitesh Singh", mDocID: "gcugcuegccyegcuyeg66786")
        validMeetingViewModel = AddNoteViewModel(meeting: validMeeting)
        
        invalidMeeting = Meeting(mTitle: "", mDate: "12 July", mNotes: "This is normal sprint meeting", mAuthor: "Nitesh Singh", mDocID: "gcugcuegccyegcuyeg66786")
        invalidMeetingViewModel = AddNoteViewModel(meeting: invalidMeeting)
        
        meetingListModel = MeetingListViewModel()
    }
    
    func testUpdateTitle() {
        validMeetingViewModel.updateTitle(title: "New Meeting 2")
        XCTAssertEqual(validMeetingViewModel.meetingTitle.value, "New Meeting 2")
    }
    func testUpdateDate() {
        validMeetingViewModel.updateDate(date: "13 July")
        XCTAssertEqual(validMeetingViewModel.meetingDate.value, "13 July")
    }
    func testUpdateNotes() {
        validMeetingViewModel.updateNotes(notes: "This is special sprint meeting")
        XCTAssertEqual(validMeetingViewModel.meetingNotes.value, "This is special sprint meeting")
    }
    
    func testValidateFieldMissing() {
        let validation = invalidMeetingViewModel.validateMeetingForm()
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Please enter required fields")
        }
    }
    func testMeetingTitleCharacterCountCheck() {
        validMeeting = Meeting(mTitle: "New", mDate: "12 July", mNotes: "This is normal sprint meeting", mAuthor: "Nitesh Singh", mDocID: "gcugcuegccyegcuyeg66786")
        validMeetingViewModel = AddNoteViewModel(meeting: validMeeting)
        
        let validation = validMeetingViewModel.validateMeetingForm()
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Please enter atleast 5 characters user name")
        }
    }
    func testMeetingNoteCharacterCountCheck() {
        validMeeting = Meeting(mTitle: "New Meeting", mDate: "12 July", mNotes: "This is normal sprint meeting This is normal sprint meeting This is normal sprint meeting This is normal sprint meeting This is normal sprint meeting", mAuthor: "Nitesh Singh", mDocID: "gcugcuegccyegcuyeg66786")
        
        validMeetingViewModel = AddNoteViewModel(meeting: validMeeting)
        
        let validation = validMeetingViewModel.validateMeetingForm()
        if case .invalid(let message) = validation {
            XCTAssertEqual(message, "Meeting note character limit exceeded, please enter less than 100 characters")
        }
    }
    
    func testValidateIfAllFieldsArePerfect() {
        let validation = validMeetingViewModel.validateMeetingForm()
        print(validation)
        if case .valid = validation {
            
        }
    }
    
    func testRandomNumberGenerator() {
        let randomStr = validMeetingViewModel.generateUniqueId(20)
        XCTAssertEqual(randomStr.count, 20)
    }
    
    func testAddMeetingNoteToFirebaseAndUpdateLocal() {
        validMeetingViewModel.addMeetingNoteToFirebaseAndUpdateLocal(completionHandler: { state in
            
            
        })
    }
    
    func testDeleteMeetingNoteFromFirebaseSuccess() {
        let documentID = "uvDjKLvFsWU7yG8AQ3d9"
        let expectation = self.expectation(description: "DeleteMockModel")
        var err: Error?
        let userID = "y39PBmIvjhWYokTMiHEI3DVNRUm1"
        meetingListModel?.deleteNoteFromFirebase(userID: userID, documentID: documentID, completionHandler: { state in
            switch state {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                err = error
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
        print(err?.localizedDescription as Any)
        XCTAssertNil(err)
    }
    
    
    func testEditMeetingNoteFromFirebaseSuccess() {
        let meeting = Meeting(mTitle: "New Meeting 2", mDate: "12 July", mNotes: "This is normal sprint meeting", mAuthor: "Nitesh Singh", mDocID: "gcugcuegccyegcuyeg66786")
        let expectation = self.expectation(description: "DeleteMockModel")
        var err: Error?
        validMeetingViewModel.editMeetingNote(editedMeeting: meeting, completionHandler: {
            (state) in
            switch state {
            case .success:
                expectation.fulfill()
            case .failure(let error):
                err = error
                expectation.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
        print(err?.localizedDescription as Any)
        XCTAssertNil(err)
        
    }
    
    func testBindAndBindFire() {
        let name: Dynamic<String> = Dynamic("")
        name.bindAndFire {
            print($0)
        }
        name.value = "Nitesh"
        XCTAssertEqual(name.value, "Nitesh")
        
        name.bind {
            print($0)
        }
        name.value = "Nitesh2"
        XCTAssertEqual(name.value, "Nitesh2")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
}
