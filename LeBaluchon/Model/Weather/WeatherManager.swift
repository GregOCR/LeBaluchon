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
    case couldNotFetchWeatherDueToFailingJsonDecoding
    
    var message: String {
        switch self {
        case .couldNotFetchWeatherDueToFailingJsonDecoding: return "couldNotFetchWeatherDueToFailingJsonDecoding"
        case .couldNotFetchWeatherDueToInvalidUrl: return "couldNotFetchWeatherDueToInvalidUrl"
        case .couldNotFetchWeatherDueToNoData: return "couldNotFetchWeatherDueToNoData"
        case .couldNotFetchWeatherDueUnknownError: return "couldNotFetchWeatherDueUnknownError"
        }
    }
}

protocol WeatherManagerDelegate: AnyObject {
    func didFetchWeatherResult(weatherResult: Result<WeatherModel, WeatherManagerError>, localize: Bool)
}

class WeatherManager {
    weak var delegate: WeatherManagerDelegate?
    
    func fetchWeather(longitude: Double, latitude: Double, localize: Bool) {
        guard let url = getFetchWeatherUrl(longitude: longitude, latitude: latitude) else {
            delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToInvalidUrl), localize: localize)
            return
        }
        performRequest(with: url, localize: localize)
    }
    
    func fetchWeatherWithCity(_ name: String, iso: String) {
        guard let url = getFetchWeatherUrlWithCityNamed(name, iso: iso) else {
            delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToInvalidUrl), localize: false)
            return
        }
        performRequest(with: url, localize: false)
    }

    
    private func getFetchWeatherUrl(longitude: Double, latitude: Double) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "appid", value: "87989bfd88e94b4e65c48b71104226db"),
            .init(name: "lang", value: "fr"),
            .init(name: "units", value: "metric"),
            .init(name: "lon", value: "\(longitude)"),
            .init(name: "lat", value: "\(latitude)")
        ]
        
        return urlComponents.url
    }
    
    private func getFetchWeatherUrlWithCityNamed(_ name: String, iso: String) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            .init(name: "appid", value: "87989bfd88e94b4e65c48b71104226db"),
//            .init(name: "lang", value: "fr"),
//            .init(name: "units", value: "metric"),
            .init(name: "q", value: "\(name),\(iso)")
        ]
        
        return urlComponents.url
    }

    
    private func performRequest(with url: URL, localize: Bool) {
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueUnknownError), localize: localize)
                return
            }
            
            guard let data = data else {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToNoData), localize: localize)
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(WeatherData.self, from: data) else {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToFailingJsonDecoding), localize: localize)
                return
            }
            
            guard let mappedModel = self?.mapResponseModel(decodedData: decodedData) else {
                self?.delegate?.didFetchWeatherResult(weatherResult: .failure(.couldNotFetchWeatherDueToFailingJsonDecoding), localize: localize)
                return
            }
            self?.delegate?.didFetchWeatherResult(weatherResult: .success(mappedModel), localize: localize)
        }
        task.resume()
    }
    
    private func mapResponseModel(decodedData: WeatherData) -> WeatherModel? {
        let cityName = decodedData.cityName
        let countryIsoCode = decodedData.system.countryIsoCode
        let currentTime = decodedData.currentTime
        let timeZone = decodedData.timeZone
        let weatherDescription = decodedData.weather[0].description
        let weatherTypeCode = decodedData.weather[0].typeCode
        let minTemperature = decodedData.furtherInfos.temperatureMin
        let maxTemperature = decodedData.furtherInfos.temperatureMax
        let temperature = decodedData.furtherInfos.temperature
        let sunriseTime = decodedData.system.sunriseTime
        let sunsetTime = decodedData.system.sunsetTime
        let pressure = decodedData.furtherInfos.pressure
        let humidity = decodedData.furtherInfos.humidity
        
        let weather = WeatherModel(
            cityName: cityName,
            countryIsoCode: countryIsoCode,
            currentTime: currentTime,
            timeZone: timeZone,
            weatherDescription: weatherDescription,
            weatherTypeCode: weatherTypeCode,
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
