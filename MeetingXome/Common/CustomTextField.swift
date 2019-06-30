//
//  CustomTextField.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 27/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.


import Foundation
import UIKit

class CustomTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

