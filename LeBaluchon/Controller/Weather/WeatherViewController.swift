//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

// comment utiliser le weatherManager dans le cityAdd
// comment rajouter des villes dans la fav de façon persistente
// comment savoir lorsque les données sont récupérées et pouvoir ainsi admettre certaines actions ? (errors?)

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {

    @IBOutlet private weak var currentDateLabel: UILabel!
    @IBOutlet private weak var countryIsoCodeLabel: UILabel!
    
    @IBOutlet private weak var cityIllustrationView: UIView!
    @IBOutlet private var weatherStackViews: [UIStackView]!
    @IBOutlet private weak var weatherInformationsComponentsStackView: UIStackView!
    @IBOutlet private weak var whiteGradientImageView: UIImageView!
    
    @IBOutlet private weak var localizeYourselfImageView: UIImageView!
    
    @IBOutlet private weak var weatherPictoImage: UIImageView!
    
    @IBOutlet private weak var cityNameButton: UIButton!
    
    @IBOutlet private weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var todayMinimalTemperatureLabel: UILabel!
    @IBOutlet private weak var todayMaximalTemperatureLabel: UILabel!
    @IBOutlet private weak var todaySunriseTimeLabel: UILabel!
    @IBOutlet private weak var todaySunsetTimeLabel: UILabel!
    @IBOutlet private weak var currentPressureLabel: UILabel!
    @IBOutlet private weak var currentHumidityLabel: UILabel!
    
    static var shared = WeatherViewController()
    
    private let weatherManager = WeatherManager()
    
    private let locationManager = CLLocationManager()
    
    private let dateManager = DateManager.shared
    private let soundManager = SoundManager.shared
    
    private var selectedCity: City? {
        didSet {
            handleCitySelectionChange()
        }
    }
    
    private func handleCitySelectionChange() {
        fetchCityData()
    }
    
    private func updateCityLocalData() {
//        guard selectedCity != nil else { return }
        switchWeatherViewComponentsToNormal()
        
    }
    
    private func fetchCityData() {
        guard let selectedCity = selectedCity else { return }
        weatherManager.fetchWeather(longitude: selectedCity.longitude, latitude: selectedCity.latitude, localize: false)
        updateCityLocalData()
    }
    
    // set the color of the status bar content in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBarItem.image?.withTintColor(UIColor.red, renderingMode: .automatic)
        locationManager.delegate = self
        weatherManager.delegate = self
    }
    
    private func switchWeatherViewComponentsToNormal() {
        localizeYourselfImageView.isHidden = true
        cityIllustrationView.alpha = 0.5
        whiteGradientImageView.isHidden = true
        weatherStackViews.forEach { $0.isHidden = false }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // set full current date to label in date view
        currentDateLabel.text = dateManager.getFormattedDate(.FullCurrentDate).uppercased()
    }
    
    @IBAction func localizeButtonTap(_ sender: UIButton) {        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        updateCityLocalData()
    }
    
    @IBAction func cityNameButtonTap(_ sender: UIButton) {
        navigateToCitySelectionView()
    }
    
    private func navigateToCitySelectionView() {
        guard let weatherCitiesListStoryboard = storyboard?.instantiateViewController(withIdentifier: ElementIdentifier.named.weatherCitiesListStoryboard) as? WeatherCitiesListController else { return }
        weatherCitiesListStoryboard.selectionDelegate = self
        present(weatherCitiesListStoryboard, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    private func displayAlert(error: WeatherManagerError) {
        let alertController = UIAlertController(title: "E R R 〇 R", message: error.message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherViewController: WeatherManagerDelegate {
    func didFetchWeatherResult(weatherResult: Result<WeatherModel, WeatherManagerError>, localize: Bool) {
        DispatchQueue.main.async { [weak self] in
            switch weatherResult {
            case .failure(let error):
                self?.displayAlert(error: error)
                
            case .success(let weather):
                // If fetch weather is localize, city name is json city name ELSE city name is local database city name
                if localize == true {
                    self?.cityNameButton.setTitle(weather.cityName, for: .normal)
                } else {
                    self?.cityNameButton.setTitle(self?.selectedCity?.name, for: .normal)
                }
                self?.countryIsoCodeLabel.text = weather.countryIsoCode
                self?.currentHumidityLabel.text = weather.todayHumidity
                self?.currentWeatherDescriptionLabel.text = weather.currentDescription
                self?.currentTemperatureLabel.text = weather.currentTemperature
                self?.weatherPictoImage.image = UIImage(systemName: weather.weatherCaseStringImageID)
                self?.todayMinimalTemperatureLabel.text = weather.todayMinTemperature
                self?.todayMaximalTemperatureLabel.text = weather.todayMaxTemperature
                self?.todaySunriseTimeLabel.text = weather.todaySunriseTime
                self?.todaySunsetTimeLabel.text = weather.todaySunsetTime
                self?.currentPressureLabel.text = weather.todayPressure
                self?.currentHumidityLabel.text = weather.todayHumidity
                if weather.cityIsDayTime { // if the city time is in night, the weather picto color is dark blue, else white
                    self?.weatherPictoImage.tintColor = UIColor.white
                } else {
                    self?.weatherPictoImage.tintColor = Color.shared.darkWeatherColor
                }
                self?.weatherInformationsComponentsStackView.alpha = 1
            }
        }
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            let longitude = location.coordinate.longitude
            let latitude = location.coordinate.latitude
            weatherManager.fetchWeather(longitude: longitude, latitude: latitude, localize: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension WeatherViewController: CitySelectionDelegate {
    func didSelect(city: City) {
        self.selectedCity = city
    }
}
