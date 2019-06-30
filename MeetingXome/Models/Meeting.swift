//
//  File.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation

struct Meeting {
    var meetingTitle = String()
    var meetingDate = String()
    var meetingNotes = String()
    var author = String()
    var meetingDocID = String()
    
    init() {
        
    }
    init(mTitle: String,mDate: String, mNotes: String, mAuthor: String,  mDocID: String){
        self.meetingTitle = mTitle
        self.meetingDate = mDate
        self.meetingNotes = mNotes
        self.author = mAuthor
        self.meetingDocID = mDocID
    }
    init?(dictionary: [String : Any]) {
        self.meetingTitle = (dictionary["meetingTitle"] as? String)!
        self.meetingDate = (dictionary["meetingDate"] as? String)!
        self.meetingNotes = (dictionary["meetingNotes"] as? String)!
        self.author = (dictionary["author"] as? String)!
        self.meetingDocID = (dictionary["docID"] as? String)!
    }
}
