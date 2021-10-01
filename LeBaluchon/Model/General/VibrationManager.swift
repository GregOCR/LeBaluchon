//
//  Vibrations.swift
//  LeBaluchon
//
//  Created by Greg on 20/09/2021.
//

import UIKit
import AudioToolbox

struct Vibration {
    
    enum For {
        
        case numbersAndDotButtons, calcScreenButtons, printer, acResetButton
        
        internal func perform() {
            switch self {
            case .numbersAndDotButtons:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                } else {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            case .calcScreenButtons:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                } else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            case .printer:
                AudioServicesPlaySystemSound(1521)
            case .acResetButton:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            }
        }
    }
}
