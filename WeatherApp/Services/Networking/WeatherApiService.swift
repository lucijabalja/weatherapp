//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherApiService {
    
    private let apiURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey = "appid=56151fef235e6cebb33750525932d021"
    private let units = "units=metric"
    private let exclusions = "exclude=minutely,hourly"
    private let parsingService: ParsingService
    
    init(parsingService: ParsingService) {
        self.parsingService = parsingService
    }
    
    private func performRequest(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURLError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let _ = error {
                completion(.failure(.URLSessionError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unwrappingError))
                return
            }
            
            completion(.success(data))
        })
        task.resume()
    }
    
}

extension WeatherApiService: WeatherListServiceProtocol {
    
    func fetchCurrentWeather(completion: @escaping (Result<CurrentWeatherResponse, NetworkError>) -> Void) {
        let ids = City.allCases.map{ $0.rawValue}.map { $0 }.joined(separator:",")
        let urlString = "\(apiURL)/group?\(apiKey)&\(exclusions)&\(units)&id=\(ids)"
        
        performRequest(with: urlString) { (result) in
            switch result {
            case .success(let data):
                let parsedResponse = self.parsingService.parseCurrentWeather(data)
                
                guard let currentWeather = parsedResponse else {
                    completion(.failure(.unwrappingError))
                    return
                }
                completion(.success(currentWeather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}

extension WeatherApiService: WeatherDetailServiceProtocol {
    
    func fetchHourlyWeather(for city: String, completion: @escaping (Result<HourlyWeatherResponse, NetworkError>) -> Void) {
        let urlString = "\(apiURL)/forecast?\(apiKey)&\(units)&q=\(city)"
        
        performRequest(with: urlString) { (result) in
            switch result {
            case .success(let data):
                let parsedResponse = self.parsingService.parseHourlyWeather(data, city: city)
                
                guard let hourlyWeather = parsedResponse else {
                    completion(.failure(.decodingError))
                    return
                } 
                
                completion(.success(hourlyWeather))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDailyWeather(with latitude: Double,_ longitude: Double, completion: @escaping (Result<DailyWeatherResponse, NetworkError>) -> Void) {
        let urlString = "\(apiURL)/onecall?\(apiKey)&\(units)&lat=\(latitude)&lon=\(longitude)&\(exclusions)"
        
        performRequest(with: urlString) { (result) in
            
            switch result {
            case .success(let data):
                let parsedResponse = self.parsingService.parseDailyWeather(data)
                
                guard let dailyWeather = parsedResponse else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(dailyWeather))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
