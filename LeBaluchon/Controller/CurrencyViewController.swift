//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit
import AVFoundation

class CurrencyViewController: UIViewController {
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var ticketDateTimeLabel: UILabel!
    @IBOutlet weak var ticketMaskView: UIView!
    @IBOutlet weak var shareDestroyStackView: UIStackView!
    
    var soundToPlay: AVAudioPlayer?


    @IBOutlet weak var ticketView: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var inputCurrencyTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.currentDateLabel.text = getDateInformation(.CurrentDate)
        self.currentTimeLabel.text = getDateInformation(.CurrentTime)
        self.addDoneButtonOnKeyboard()

        
    }
    
   
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 1) { [self] in
            self.ticketView.frame.origin.y = -ticketMaskView.frame.height
        }
        UIView.animate(withDuration: 0.25) { [self] in
            self.shareDestroyStackView.alpha = 0
            self.blurView.alpha = 0.011
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.ticketView.frame.origin.y = self.ticketMaskView.frame.height+20
            self.blurView.alpha = 0
            self.ticketMaskView.alpha = 0
        }
    }
    @IBAction func swipeDownTicketAction(_ sender: UISwipeGestureRecognizer) {
            UIView.animate(withDuration: 1) { [self] in
                self.ticketView.frame.origin.y = +ticketMaskView.frame.height+20
            }
            UIView.animate(withDuration: 0.25) { [self] in
                self.shareDestroyStackView.alpha = 0
                self.blurView.alpha = 0.011
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.ticketView.frame.origin.y = self.ticketMaskView.frame.height+20
                self.blurView.alpha = 0
                self.ticketMaskView.alpha = 0

            }
    }
    
    @IBAction func ticketShowUpButton(_ sender: Any) {
        self.ticketDateTimeLabel.text = getDateInformation(.CurrentUTCTime)
        self.blurView.alpha = 0.011
        self.ticketMaskView.alpha = 1

        UIView.animate(withDuration: 1) { [self] in
            ticketView.frame.origin.y = (ticketMaskView.frame.height/2) - (ticketView.frame.height/2) + 50
        }
        self.blurView.appearWithDelay()
        self.shareDestroyStackView.appearWithDelay()

        playSound(named: "printer.mp3")
    }

    func playSound(named soundName: String) {
        let path = Bundle.main.path(forResource: soundName, ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            soundToPlay = try AVAudioPlayer(contentsOf: url)
            soundToPlay?.play()
        } catch {
            // couldn't load file :(
        }

    }
    
    
    func addDoneButtonOnKeyboard(){
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = .default

            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction))

            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()

        inputCurrencyTextField.inputAccessoryView = doneToolbar
        }

        @objc func doneButtonAction(){
            inputCurrencyTextField.resignFirstResponder()
        }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension UIVisualEffectView {
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

extension UIStackView {
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
