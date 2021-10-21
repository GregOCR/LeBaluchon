//
//  Extensions.swift
//  LeBaluchon
//
//  Created by Greg on 12/10/2021.
//

import UIKit

extension String {
    func asDouble() -> Double {
        var result = Double(self)
        // if a string in chain is not number or dot, return 0 as double
        self.forEach( {
            if $0 != "." && !$0.isNumber {
                result = 0
            }
        })
        return result!
    }
}

extension UIViewController {
    func popUpAlert(title: String, message: String, asActionSheet: Bool, autoDismissTime: Double) {
        var alertStyle = UIAlertController.Style.alert
        if asActionSheet == true {
            alertStyle = UIAlertController.Style.actionSheet
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        if autoDismissTime != 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + autoDismissTime) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}

