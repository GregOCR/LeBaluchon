//
//  Extension.swift
//  LeBaluchon
//
//  Created by Greg on 30/08/2021.
//

import UIKit

enum Direction {
    case Up, Down
}

//extension UIView{
//    func infiniteRotate() {
//        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//        rotation.toValue = NSNumber(value: Double.pi * 2)
//        rotation.duration = 1
//        rotation.isCumulative = true
//        rotation.repeatCount = Float.greatestFiniteMagnitude
//        self.layer.add(rotation, forKey: "rotationAnimation")
//    }
//}
//
//extension UIImageView {
//    func moveAndFadeOutInLoop(_ direction: Direction) {
//        var move: CGFloat
//        
//        switch direction {
//        case .Up:
//            move = -300
//        case .Down:
//            move = 300
//        }
//        
//        UIView.animate(withDuration: 1,
//                       delay: 0,
//                       options: [.repeat],
//                       animations: {
//                        self.frame.origin.y += move
//                        self.alpha = 0
//                       }, completion: nil)
//    }
//}
