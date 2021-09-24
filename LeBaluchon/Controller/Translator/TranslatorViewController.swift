//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit
import CoreMotion

class TranslatorViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var currentDateLabel: UILabel!
    
    @IBOutlet weak var cityAnimationContainerView: UIView!
    @IBOutlet weak var cityAnimationLayer1View: UIView!
    @IBOutlet weak var cityAnimationLayer2View: UIView!
    @IBOutlet weak var cityAnimationLayer3View: UIView!
    
    @IBOutlet weak var cityAnimationLayer2WheelImageView: UIImageView!
    
    @IBOutlet weak var textEntryView: UITextView!
    
    var textViewPlaceholder = ""
    var motionManager = CMMotionManager()
    private let dateManager = DateManager.shared
    
    // set the color of content status bar in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEntryView.delegate = self
        textViewPlaceholder = ""
        textViewDidEndEditing(textEntryView)
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) {  (data, Error) in
            let coeff = (self.cityAnimationLayer1View.frame.size.width-self.cityAnimationContainerView.frame.size.width)/2
            if let mydata = data {
                if mydata.acceleration.x < 1 || mydata.acceleration.x < -1 {
                    UIView.animate(withDuration: 0.5) { [self] in
                        self.cityAnimationLayer1View.frame.origin.x = (CGFloat(mydata.acceleration.x)*coeff)-coeff
                        self.cityAnimationLayer2View.frame.origin.x = (CGFloat(mydata.acceleration.x/2)*coeff)-coeff
                        self.cityAnimationLayer3View.frame.origin.x = (CGFloat(mydata.acceleration.x/3)*coeff)-coeff
                    }
                }
            }
        }
    }
    
    func refreshDate() {
        self.currentDateLabel.text = dateManager.getDateInformation(.FullCurrentDate).uppercased()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.currentDateLabel.text = self.dateManager.getDateInformation(.FullCurrentDate).uppercased()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshDate()
        tabBarController?.tabBar.barTintColor = Color.darkTranslatorColor
    }
    
    @IBAction func sentenceSelectButtonTap(_ sender: UIButton) {
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: "sentenceList") as! TranslatorSentencesViewController
        selectionVC.selectionDelegate = self
        present(selectionVC, animated: true, completion: nil)
    }
    
    // hide keyboard when press ENTER key
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textEntryView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == #colorLiteral(red: 0.3743489583, green: 0.6320441929, blue: 0.7486979167, alpha: 1).withAlphaComponent(0.5) {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.0623490223, green: 0.1894281492, blue: 0.2469544492, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Sélectionnez ou écrivez\nune phrase à traduire"
            textView.textColor = #colorLiteral(red: 0.3743489583, green: 0.6320441929, blue: 0.7486979167, alpha: 1).withAlphaComponent(0.5)
            textViewPlaceholder = ""
        } else {
            textViewPlaceholder = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholder = textView.text
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

extension TranslatorViewController: SentenceSelectionDelegate {
    func didSelection(sentence: String) {
        self.textViewDidBeginEditing(textEntryView)
        self.textEntryView.text = sentence
    }
}
