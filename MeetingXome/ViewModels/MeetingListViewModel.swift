//
//  MeetingListViewModel.swift
//  MeetingXome
//
//  Created by Nitesh Singh # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct MeetingListViewModel {
    
    private let database = Firestore.firestore()
    
    let userID = Auth.auth().currentUser?.uid
    
    func fetchMeetingsFromFirebase(completionHandler: @escaping (CompletionState) -> Void) {
        database.collection("users").document(self.userID!).collection("meetings").addSnapshotListener { (querySnapshot, err) in
            var meetings: [Meeting] = []
            
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(.failure(err))
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let meeting = Meeting(dictionary: document.data())
                    meetings.append(meeting!)
                }
                completionHandler(.success(meetings))
            }
        }
    }
    
    func deleteNoteFromFirebase(userID: String, documentID: String, completionHandler: @escaping (CompletionState) -> Void)
    {
        database.collection("users").document(userID).collection("meetings").document(documentID).delete() { err in
            if let err = err {
                completionHandler(.failure(err))
                print("Error removing document: \(err)")
            } else {
                completionHandler(.success([]))
                print("Document successfully removed!")
            }
        }
    }
}
