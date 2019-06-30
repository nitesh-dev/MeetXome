//
//  FirebaseNetworking.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 27/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import FirebaseAuth

struct FirebaseService {
    
    static func loginToFirebase(userEmail: String, userPassword: String, completionHandler: @escaping (String?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { user, error in
            if let err = error {
                completionHandler(nil, err)
            }
            else if error == nil {
                completionHandler("Success", nil)
            }
        }
    }
}
