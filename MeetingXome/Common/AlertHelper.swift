//
//  AlertHelper.swift
//  MeetingXome
//
//  Created by Cognizant Technology Solutions # 2 on 29/06/19.
//  Copyright © 2019 Nitesh Singh. All rights reserved.
//

import Foundation
import UIKit

struct AlertHelper {
    static func showErrorMessage(vc: UIViewController, title: String) {
        let alert = UIAlertController(title: "Error", message: title, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { _ in
        }))
        vc.present(alert, animated: true, completion: nil)
    }
}
