//
//  AppConstants.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    static let eventType = "Events"
    static let appointmentType = "Appointments"
    static var userName = ""
    
    struct Controller {
        static let loginViewController = "LoginViewController"
        static let registerViewController = "RegisterViewController"
        static let homeViewController = "HomeViewController"
        static let addNoteViewController = "AddNoteViewController"
    }
    
    struct Cells {
        static let MeetingCell = "MeetingCell"
    }
}
struct Storyboards {
    static let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
}
