//
//  RegisterViewController.swift
//  MeetingXome
//
//  Created by Nitesh Singh # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    private var viewModel = UserViewModel()
    
    @IBOutlet weak var userNameTextField : UITextField!
    @IBOutlet weak var emailTextField : UITextField!
    @IBOutlet weak var passwordTextField : UITextField!
    
    @IBAction func registerUserToFirebase(_ sender: UIButton) {
        switch viewModel.validate() {
        case .valid:
            viewModel.registerOnFirebase(completionHandler: {
                error in
                if error == nil {
                    self.viewModel.registerUserDict(completionHandler: {
                        error in
                        if error != nil {
                            print("error occured")
                        }
                    })
                    let homeVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.homeViewController) as! HomeViewController
                    let navController = UINavigationController(rootViewController: homeVC)
                    self.present(navController, animated:true, completion: nil)
                }
                else {
                    AlertHelper.showErrorMessage(vc: self, title: (error?.localizedDescription)!)
                }
            })
        case .invalid(let error):
            AlertHelper.showErrorMessage(vc: self, title: error)
    }
    }
    
    
    @IBAction func backToLoginPage(_ sender: UIButton) {
        let loginVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.loginViewController) as! LoginViewController
        self.present(loginVC, animated:true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        viewModel.userName.bindAndFire {
            print($0)
        }
        viewModel.userEmail.bindAndFire {
            print($0)
        }
        viewModel.userPassword.bindAndFire {
            print($0)
        }
    }
}
extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == userNameTextField {
            textField.text = viewModel.userName.value
        }
        if textField == emailTextField {
            textField.text = viewModel.userEmail.value
        }
        if textField == passwordTextField {
            textField.text = viewModel.userPassword.value
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if textField == userNameTextField {
            viewModel.updateUserName(userName: newString)
        }
        if textField == emailTextField {
            viewModel.updateEmail(email: newString)
        }
        if textField == passwordTextField {
            viewModel.updatePassword(password: newString)
        }
        return true
    }
}

