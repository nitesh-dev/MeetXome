//
//  FirebaseNetworking.swift
//  MeetingXome
//
//  Created by Nitesh Singh # 2 on 29/06/19.
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
