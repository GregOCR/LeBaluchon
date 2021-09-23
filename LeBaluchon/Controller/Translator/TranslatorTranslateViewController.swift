//
//  TranslateTranslatorViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit

class TranslatorTranslateViewController: UIViewController {
    
    @IBOutlet weak var translatedTextLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func copyTranslationInClipboardButton(_ sender: Any) {
        UIPasteboard.general.string = self.translatedTextLabel.text
        self.dismiss()
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
