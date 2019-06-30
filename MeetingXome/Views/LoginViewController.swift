//
//  LoginViewController.swift
//  MeetingXome
//
//  Created by Nitesh Singh # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var userViewModel = UserViewModel()
    @IBAction func loginToFirebase(_ sender: UIButton) {
        
        FirebaseService.loginToFirebase(userEmail: userViewModel.userEmail.value, userPassword: userViewModel.userPassword.value, completionHandler: {
            (message, error) in
            if error == nil {
                let homeVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.homeViewController) as! HomeViewController
                let navController = UINavigationController(rootViewController: homeVC)
                self.present(navController, animated:true, completion: nil)
            }
            else {
                AlertHelper.showErrorMessage(vc: self, title: (error?.localizedDescription)!)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        userViewModel.userEmail.bindAndFire {
            print($0)
        }
        userViewModel.userPassword.bindAndFire {
            print($0)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.text = userViewModel.userEmail.value
        }
        if textField == passwordTextField {
            textField.text = userViewModel.userPassword.value
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == emailTextField {
            userViewModel.updateEmail(email: newString)
        }
        if textField == passwordTextField {
            userViewModel.updatePassword(password: newString)
        }
        return true
    }
}
