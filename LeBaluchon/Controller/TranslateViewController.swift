//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate {

    var textViewPlaceholder = ""
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    
    @IBOutlet weak var textEntryView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEntryView.delegate = self
        textViewPlaceholder = ""
        textViewDidEndEditing(textEntryView)
        self.currentDateLabel.text = getDateInformation(.CurrentDate)
        self.currentTimeLabel.text = getDateInformation(.CurrentTime)
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
        if textView.textColor == UIColor(red: 0.87, green: 0.56, blue: 0.27, alpha: 0.5) {
            textView.text = ""
            textView.textColor = UIColor(red: 0.87, green: 0.56, blue: 0.27, alpha: 1.00)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Écrivez ou sélectionnez une phrase à traduire"
            textView.textColor = UIColor(red: 0.87, green: 0.56, blue: 0.27, alpha: 0.5)
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
