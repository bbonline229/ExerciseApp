//
//  UIViewController+Extension.swift
//  ExerciseApp
//
//  Created by Jack on 6/30/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles: [String], actionStyle: [UIAlertAction.Style], action: [((UIAlertAction) -> Void)?]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: action[index])
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func popupActionSheet(title: String, message: String?, actionTitles: [String], actionStyle: [UIAlertAction.Style], action: [((UIAlertAction) -> Void)?]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: actionStyle[index], handler: action[index])
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
}
