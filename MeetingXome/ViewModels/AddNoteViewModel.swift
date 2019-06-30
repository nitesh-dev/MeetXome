//
//  AddNoteViewModel.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum CompletionState {
    case success([Meeting])
    case failure(Error)
}

struct AddNoteViewModel {
    
    private var meeting = Meeting() {
        didSet {
            meetingTitle.value = meeting.meetingTitle
            meetingDate.value = meeting.meetingDate
            meetingNotes.value = meeting.meetingNotes
            author.value = meeting.author
        }
    }
    private let database = Firestore.firestore()
    
    var meetingTitle: Dynamic<String> = Dynamic("")
    var meetingDate: Dynamic<String> = Dynamic("")
    var meetingNotes: Dynamic<String> = Dynamic("")
    var author: Dynamic<String> = Dynamic("")
    
    init(meeting: Meeting = Meeting()) {
        self.meeting = meeting
        meetingTitle.value = meeting.meetingTitle
        meetingDate.value = meeting.meetingDate
        meetingNotes.value = meeting.meetingNotes
        author.value = meeting.author
    }
}
extension AddNoteViewModel {
    mutating func updateTitle(title: String) {
        meeting.meetingTitle = title
    }
    mutating func updateDate(date: String) {
        meeting.meetingDate = date
    }
    mutating func updateNotes(notes: String) {
        meeting.meetingNotes = notes
    }
    
    func addMeetingNoteToFirebaseAndUpdateLocal(completionHandler: @escaping (CompletionState) -> Void) {
        
        let userID = Auth.auth().currentUser?.uid
        
        let meetingDocID = generateUniqueId(20)
        
        let docData: [String: Any] = [
            "meetingTitle": meeting.meetingTitle,
            "meetingDate": meeting.meetingDate,
            "meetingNotes": meeting.meetingNotes,
            "author": userID as Any,
            "docID": meetingDocID
        ]
        DispatchQueue.global(qos: .background).async {
            self.database.collection("users").document(userID!).collection("meetings").document(meetingDocID).setData(docData) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    //print("Document added with ID: \(ref!.documentID)")
                }
            }
        }
        completionHandler(.success([]))
    }
    
    func editMeetingNote(editedMeeting: Meeting, completionHandler: @escaping (CompletionState) -> Void) {
        
        let userID = Auth.auth().currentUser?.uid
        
        let updatedData: [String: Any] = [
            "meetingTitle": meeting.meetingTitle,
            "meetingDate": meeting.meetingDate,
            "meetingNotes": meeting.meetingNotes
        ]
        DispatchQueue.global(qos: .background).async {
            
            let ref = self.database.collection("users").document(userID!).collection("meetings").document(editedMeeting.meetingDocID)
            
            ref.updateData(updatedData) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
        completionHandler(.success([]))
    }
}
extension AddNoteViewModel {
    func generateUniqueId(_ c: Int) -> String
    {
        let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        var generatedStr = ""
        
        for _ in 0..<c
        {
            let random = Int(arc4random_uniform(UInt32(chars.count)))
            generatedStr += String(chars[chars.index(chars.startIndex, offsetBy: random)])
        }
        return generatedStr
    }
    func validateMeetingForm() -> ValidationState {
        
        if meeting.meetingNotes.isEmpty || meeting.meetingTitle.isEmpty || meeting.meetingDate.isEmpty {
            return .invalid("Please enter required fields")
        }
        if meeting.meetingTitle.count < 5 {
            return .invalid("Please enter atleast 5 characters user name")
        }
        if meeting.meetingNotes.count > 100 {
            return .invalid("Meeting note character limit exceeded, please enter less than 100 characters")
        }
        return .valid
    }
}
