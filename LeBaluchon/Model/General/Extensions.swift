//
//  Extensions.swift
//  LeBaluchon
//
//  Created by Greg on 12/10/2021.
//

import UIKit

extension String {
    func asDouble() -> Double {
        let test = Double(self)!
        if test * 1 != 0 {
            return test
        } else {
            return 0
        }
    }
}

extension UIView {
    func appearWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
            }
        }
    }
    func disappearWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1) {
                self.alpha = 0
            }
        }
    }
}

extension UIViewController {
    func popUpAlert(title: String, message: String, asActionSheet: Bool, autoDismiss: Bool) {
        var alertStyle = UIAlertController.Style.alert
        if asActionSheet == true {
            alertStyle = UIAlertController.Style.actionSheet
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        if autoDismiss == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                alert.dismiss(animated: true, completion: nil)
            }
        } else {
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        }
        self.present(alert, animated: true, completion: nil)
    }
}
