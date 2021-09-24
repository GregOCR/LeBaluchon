//
//  WeatherViewController.swift
//  LeBaluchon
//
//  Created by Greg on 01/09/2021.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    @IBOutlet private weak var currentDateLabel: UILabel!
    @IBOutlet private weak var cityISOLabel: UILabel!
    
    @IBOutlet private weak var cityIllustrationView: UIView!
    @IBOutlet private var weatherStackViews: [UIStackView]!
    @IBOutlet private weak var whiteGradientImageView: UIImageView!
    
    @IBOutlet private weak var localizeYourselfImageView: UIImageView!
    
    @IBOutlet private weak var weatherPictoImage: UIImageView!
    
    @IBOutlet private weak var cityButton: UIButton!
    
    @IBOutlet private weak var currentWeatherDescriptionLabel: UILabel!
    @IBOutlet private weak var currentTemperatureLabel: UILabel!
    @IBOutlet private weak var todayMinimalTemperatureLabel: UILabel!
    @IBOutlet private weak var todayMaximalTemperatureLabel: UILabel!
    @IBOutlet private weak var todaySunriseTimeLabel: UILabel!
    @IBOutlet private weak var todaySunsetTimeLabel: UILabel!
    @IBOutlet private weak var currentPressureLabel: UILabel!
    @IBOutlet private weak var currentHumidityLabel: UILabel!
    
    
    private let weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    private let dateManager = DateManager.shared
    
    private var selectedCity: City? {
        didSet {
            handleCitySelectionChange()
        }
    }
    
    private func handleCitySelectionChange() {
        updateCityLocalData()
        fetchCityData()
    }
    
    private func updateCityLocalData() {
//        guard selectedCity != nil else { return }
        weatherViewComponentsAreVisible(true)
    }
    
    private func fetchCityData() {
        guard let selectedCity = selectedCity else { return }
        weatherManager.fetchWeather(for: selectedCity)
    }
    
    // set the color of the status bar content in white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherViewComponentsAreVisible(false)
        
        locationManager.delegate = self
        weatherManager.delegate = self
    }
    
    private func weatherViewComponentsAreVisible(_ visibility: Bool) {
        localizeYourselfImageView.isHidden = true
        cityIllustrationView.alpha = 0.5
        whiteGradientImageView.isHidden = true
        weatherStackViews.forEach { $0.isHidden = !visibility }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // set full current date to label in date view
        currentDateLabel.text = dateManager.getDateInformation(.FullCurrentDate).uppercased()
        // set dark color theme to the tab bar section
        tabBarController?.tabBar.barTintColor = Color.darkWeatherColor
    }
    
    @IBAction func localizeButtonTap(_ sender: Any) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        updateCityLocalData()
    }
    
    @IBAction func cityToChooseButtonTap(_ sender: UIButton) {
        navigateToCitySelectionView()
    }
    
    private func navigateToCitySelectionView() {
        guard let selectionViewController = storyboard?.instantiateViewController(withIdentifier: "weatherCitiesList") as? WeatherCitiesListController else { return }
        selectionViewController.selectionDelegate = self
        present(selectionViewController, animated: true, completion: nil)
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
        let alertController = UIAlertController(title: "E R R 0 R", message: error.message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAlertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension WeatherViewController: WeatherManagerDelegate {
    func didFetchWeatherResult(weatherResult: Result<WeatherModel, WeatherManagerError>) {
        DispatchQueue.main.async { [weak self] in
            switch weatherResult {
            case .failure(let error):
                self?.displayAlert(error: error)
                
            case .success(let weather):
                self?.cityButton.setTitle(weather.cityName, for: .normal)
                self?.cityISOLabel.text = weather.cityCountryID
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
            weatherManager.fetchWeatherWithCoordinates(longitude: longitude, latitude: latitude)
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
