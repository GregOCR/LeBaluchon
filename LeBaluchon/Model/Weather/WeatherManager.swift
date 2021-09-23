//
//  Weather.swift
//  LeBaluchon
//
//  Created by Greg on 09/09/2021.
//

import Foundation

enum WeatherManagerError: Error {
    case couldNotFetchWeatherDueToInvalidUrl
    case couldNotFetchWeatherDueUnknownError
    case couldNotFetchWeatherDueToNoData
    case couldNotFetchWeatherDueToFailingJsonDecodding
    
    var message: String {
        switch self {
        case .couldNotFetchWeatherDueToFailingJsonDecodding: return "couldNotFetchWeatherDueToFailingJsonDecodding"
        case .couldNotFetchWeatherDueToInvalidUrl: return "couldNotFetchWeatherDueToInvalidUrl"
        case .couldNotFetchWeatherDueToNoData: return "couldNotFetchWeatherDueToNoData"
        case .couldNotFetchWeatherDueUnknownError: return "couldNotFetchWeatherDueUnknownError"
        }
    }
}

protocol WeatherManagerDelegate: AnyObject {
    func didFetchWeatherResult(weatherResult: Result<WeatherModel, WeatherManagerError>)
}

class WeatherManager {
    weak var delegate: WeatherManagerDelegate?
    
    let APIurl = "https://api.openweathermap.org/data/2.5/weather?appid=87989bfd88e94b4e65c48b71104226db&lang=fr&units=metric&q="
    
    func fetchWeather(for city: City) {
        guard let url = getFetchWeatherUrl(city: city) else {
            delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToInvalidUrl))
            return
        }
        performRequest(with: url)
    }
    
    private func getFetchWeatherUrl(city: City) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "appid", value: "87989bfd88e94b4e65c48b71104226db"),
            .init(name: "lang", value: "fr"),
            .init(name: "units", value: "metric"),
            .init(name: "q", value: "\(city.title),\(city.country.iso)")
        ]
        
        return urlComponents.url
    }
    
    private func performRequest(with url: URL) {
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueUnknownError))
                return
            }
            
            guard let data = data else {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToNoData))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToFailingJsonDecodding))
                return
            }
            
            guard let mappedModel = self?.mapResponseModel(decodedData: decodedData) else {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToFailingJsonDecodding))
                return
            }
            
            self?.delegate?.didFetchWeatherResult(weatherResult: .success(mappedModel))
            
        }
        task.resume()
        
    }
    
    private func mapResponseModel(decodedData: WeatherData) -> WeatherModel? {
        let cityName = decodedData.name
        let cityCountryID = decodedData.sys.country
        let timeZone = decodedData.timezone
        let weatherDescription = decodedData.weather[0].description
        let weatherID = decodedData.weather[0].id
        let minTemperature = decodedData.main.temperatureMin
        let maxTemperature = decodedData.main.temperatureMax
        let temperature = decodedData.main.temperature
        let sunriseTime = decodedData.sys.sunrise
        let sunsetTime = decodedData.sys.sunset
        let pressure = decodedData.main.pressure
        let humidity = decodedData.main.humidity
        
        let weather = WeatherModel(
            cityName: cityName,
            cityCountryID: cityCountryID,
            timeZone: timeZone,
            weatherDescription: weatherDescription,
            weatherID: weatherID,
            minTemperature: minTemperature,
            maxTemperature: maxTemperature,
            temperature: temperature,
            sunriseTime: sunriseTime,
            sunsetTime: sunsetTime,
            pressure: pressure,
            humidity: humidity
        )
        
        return weather
    }
}
