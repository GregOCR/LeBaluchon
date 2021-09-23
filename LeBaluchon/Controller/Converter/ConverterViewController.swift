//
//  CurrencyViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit
import CoreMotion

class ConverterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var firstCurrencyFullLabel: UILabel!
    @IBOutlet weak var firstCurrencyShortLabel: UILabel!
    @IBOutlet weak var firstCurrencyAmountLabel: UILabel!
    @IBOutlet weak var secondCurrencyFullLabel: UILabel!
    @IBOutlet weak var secondCurrencyShortLabel: UILabel!
    @IBOutlet weak var secondCurrencyAmountLabel: UILabel!
        
    @IBOutlet weak var ticketDateTimeLabel: UILabel!
    @IBOutlet weak var ticketChangeLabel: UILabel!
    @IBOutlet weak var ticketFirstCurrencyShortLabel: UILabel!
    @IBOutlet weak var ticketFirstCurrencyAmountLabel: UILabel!
    @IBOutlet weak var ticketFirstCurrencyFullLabel: UILabel!
    @IBOutlet weak var ticketSecondCurrencyShortLabel: UILabel!
    @IBOutlet weak var secondCurrencyUnitAmountLabel: UILabel!
    @IBOutlet weak var ticketSecondCurrencyAmountLabel: UILabel!
    @IBOutlet weak var ticketSecondCurrencyFullLabel: UILabel!
            
    @IBOutlet weak var ticketMaskView: UIView!
    @IBOutlet weak var shareTrashStackView: UIStackView!
    
    @IBOutlet weak var ticketView: UIView!
    
    @IBOutlet weak var overAllView: UIView!
    
    // set the color of content status bar in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
//        SoundManager.initialize()

        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ticketView.layer.shadowColor = #colorLiteral(red: 0.2605186105, green: 0.2605186105, blue: 0.2605186105, alpha: 1).cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshDate()
        tabBarController?.tabBar.barTintColor = UIColor.black
    }
    
    var motionManager = CMMotionManager()
    private let dateManager = DateManager.shared
    
    
    @IBAction func numberButtonTouchUpInside(_ sender: UIButton) {
        Vibration.For.numbersAndDotButtons.perform()
        guard let entry = sender.title(for: .normal) else {
            return
        }
        print(entry)
    }
    @IBAction func acButtonTouchUpInside(_ sender: UIButton) {
        Vibration.For.acResetButton.perform()
    }
    
    @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.5) { [self] in
            self.ticketView.frame.origin.y = -ticketMaskView.frame.height
            SoundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            self.shareTrashStackView.alpha = 0
            self.overAllView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.ticketView.frame.origin.y = self.shareTrashStackView.frame.origin.y
            self.ticketMaskView.alpha = 0
            self.share(shareImage: self.captureTheTicket())
        }
    }
    
    @IBAction func swipeDownTicketAction(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.33) { [self] in
            self.ticketView.frame.origin.y = +ticketMaskView.frame.height+20
            SoundManager.play(.Woop)
        }
        UIView.animate(withDuration: 0.25) { [self] in
            self.shareTrashStackView.alpha = 0
            self.overAllView.alpha = 0.011
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
            SoundManager.play(.Paper)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            self.ticketView.frame.origin.y = self.ticketMaskView.frame.height+20
            self.overAllView.alpha = 0
            self.ticketMaskView.alpha = 0
        }
    }
    
    @IBAction func ticketShowUpButton(_ sender: Any) {
        self.updateTicketLabels()
        self.overAllView.alpha = 0.011
        self.ticketMaskView.alpha = 1
        
        UIView.animate(withDuration: 1.25) { [self] in
            ticketView.frame.origin.y = ticketMaskView.frame.height - ticketView.frame.height
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { [self] in
            self.overAllView.alpha = 1
            UIView.animate(withDuration: 0.25) { [self] in
                ticketView.frame.origin.y = ticketMaskView.frame.origin.y + (shareTrashStackView.frame.size.height/2 - ticketView.frame.size.height/2)
            }
        }
        self.overAllView.appearWithDelay()
        //        self.shareTrashStackView.appearWithDelay()
        SoundManager.play(.Printer)
    }
    
    func updateTicketLabels() {
        self.ticketDateTimeLabel.text = dateManager.getDateInformation(.CurrentUTCTime)
        self.ticketFirstCurrencyFullLabel.text = self.firstCurrencyFullLabel.text?.uppercased()
        self.ticketFirstCurrencyShortLabel.text = self.firstCurrencyShortLabel.text
        self.ticketFirstCurrencyAmountLabel.text = self.firstCurrencyAmountLabel.text
        self.ticketChangeLabel.text = "1 \(firstCurrencyShortLabel.text!) = \(secondCurrencyUnitAmountLabel.text!) \(secondCurrencyShortLabel.text!)"
        self.ticketSecondCurrencyFullLabel.text = self.secondCurrencyFullLabel.text?.uppercased()
        self.ticketSecondCurrencyShortLabel.text = self.secondCurrencyShortLabel.text
        self.ticketSecondCurrencyAmountLabel.text = self.secondCurrencyAmountLabel.text
    }

    
    private func captureTheTicket() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.ticketView.bounds.size)
        let image = renderer.image { ctx in
            self.ticketView.drawHierarchy(in: self.ticketView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    
    func share(shareImage:UIImage?){
        
        var objectsToShare = [UIImage]()
        
        if let shareImageObj = shareImage {
            objectsToShare.append(shareImageObj)
        }
        
        if shareImage != nil{
            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func refreshDate() {
        self.currentDateLabel.text = dateManager.getDateInformation(.FullCurrentDate).uppercased()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentDateLabel.text = self.dateManager.getDateInformation(.FullCurrentDate).uppercased()
        }
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
//
//extension UIStackView {
//    func appearWithDelay() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            UIView.animate(withDuration: 0.5) {
//                self.alpha = 1
//            }
//        }
//    }
//    func disappearWithDelay() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            UIView.animate(withDuration: 1) {
//                self.alpha = 0
//            }
//        }
//    }
//}
//
