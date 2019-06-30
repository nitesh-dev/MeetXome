//
//  RegistrationViewModel.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum ValidationState {
    case valid
    case invalid(String)
}
struct UserViewModel {
   
    private let minUserNameLength = 5
    private let minPasswordLength = 5
    
    private var user = User() {
        didSet {
            userName.value = user.userName
            userPassword.value = user.userPassword
            userEmail.value = user.userEmail
        }
    }
    let database = Firestore.firestore()
    
    var userName: Dynamic<String> = Dynamic("")
    var userPassword: Dynamic<String> = Dynamic("")
    var userEmail: Dynamic<String> = Dynamic("")
    
    init(user: User = User()) {
        self.user = user
        self.userName.value = user.userName
        self.userEmail.value = user.userEmail
        self.userPassword.value = user.userPassword
    }
    
}

extension UserViewModel {
    mutating func updateUserName(userName: String) {
        user.userName = userName
    }
    mutating func updatePassword(password: String) {
        user.userPassword = password
    }
    mutating func updateEmail(email: String) {
        user.userEmail = email
    }
    
    func validate() -> ValidationState {
        
        if user.userName.isEmpty || user.userPassword.isEmpty || user.userEmail.isEmpty {
            return .invalid("Please enter required fields")
        }
        if user.userName.count < minUserNameLength {
            return .invalid("Please enter atleast 5 characters user name")
        }
        if user.userPassword.count < minPasswordLength {
            return .invalid("Please enter atleast 5 characters password")
        }
        return .valid
    }
    
    func registerOnFirebase(completionHandler: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: user.userEmail, password: user.userPassword) { authResult, error in
            
            if error != nil {
                completionHandler(error!)
            }
            else {
                completionHandler(nil)
            }
        }
    }
    func registerUserDict(completionHandler: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            
            let userID = Auth.auth().currentUser?.uid
            
            self.database.collection("users").document(userID!).setData([
                "userName": self.user.userName,
                "email": self.user.userEmail,
                "password": self.user.userPassword
            ]) { err in
                if let err = err {
                    completionHandler(err)
                } else {
                    DispatchQueue.main.async {
                        self.createProfileChangeRequest(name: self.user.userName, {
                            error in
                        })
                    }
                    completionHandler(nil)
                }
            }
        }
    }

    func createProfileChangeRequest(name: String? = nil, _ callback: ((Error?) -> ())? = nil){
        if let request = Auth.auth().currentUser?.createProfileChangeRequest(){
            if let name = name{
                request.displayName = name
            }
            request.commitChanges(completion: { (error) in
                callback?(error)
            })
        }
    }
}
