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

class WeatherCityAddFavoriteViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var isoCountryTextField: UITextField!
    @IBOutlet weak var notValidatedLabel: UILabel!
    
    var addFavDelegate: CityAddFavDelegate!
    var weatherViewController = WeatherViewController.shared
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        cityTextField.delegate = self
        cityTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    @IBAction func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addFavButton(_ sender: UIButton) {
        if cityTextField.text! != "" {
            self.notValidatedLabel.isHidden = true
            weatherManager.fetchWeatherWithCity(cityTextField.text!, iso: isoCountryTextField.text!)

            print("add \(String(describing: cityTextField.text!))")
        } else {
            self.notValidatedLabel.isHidden = false
        }
    }
    
    @objc func textFieldDidChange() {
        self.notValidatedLabel.isHidden = true
    }
    
    private func displayAlert(error: WeatherManagerError) {
        let alertController = UIAlertController(title: "E R R 〇 R", message: error.message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
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

extension WeatherCityAddFavoriteViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        cityTextField.endEditing(true)
    }
    
}

extension WeatherCityAddFavoriteViewController: WeatherManagerDelegate {
    func didFetchWeatherResult(weatherResult: Result<WeatherModel, WeatherManagerError>, localize: Bool) {
        DispatchQueue.main.async { [weak self] in
            switch weatherResult {
            case .failure(let error):
                self?.displayAlert(error: error)
            case .success(let weather):
                self?.isoCountryTextField.text = weather.countryIsoCode
                print("done!")
            }
        }
    }
}
