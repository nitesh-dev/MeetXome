//
//  BindTextField.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 26/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

class BindTextField : UITextField {
    
    var textChanged :(String) -> () = { _ in }
    
    func bind(callback :@escaping (String) -> ()) {
        
        self.textChanged = callback
        self.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField :UITextField) {
        
        self.textChanged(textField.text!)
    }
    
}
