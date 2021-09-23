//
//  WeatherCityAddFavViewController.swift
//  LeBaluchon
//
//  Created by Greg on 21/09/2021.
//

import UIKit

protocol CityAddFavDelegate {
    func didValidated(city: String, ISOcode: String, country: String)
}

class WeatherCityAddFavViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var isoCountryTextField: UITextField!
    @IBOutlet weak var notValidatedLabel: UILabel!
    
    var addFavDelegate: CityAddFavDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
        cityTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func addFavButton(_ sender: UIButton) {
        if cityTextField.text! != "" {
            self.notValidatedLabel.isHidden = true
            print("add \(String(describing: cityTextField.text!))")
        } else {
            self.notValidatedLabel.isHidden = false
        }
    }
    
    @objc func textFieldDidChange() {
        self.notValidatedLabel.isHidden = true
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

extension WeatherCityAddFavViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        cityTextField.endEditing(true)
    }
    
}
