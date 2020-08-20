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
            completion(.failure(.invalidURLError(message: "Invalid URL passed.")))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let _ = error {
                completion(.failure(.URLSessionError(message: "URL session failed. Try again.")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.decodingError(message: "Unwrapping data failed.")))
                return
            }
            
            completion(.success(data))
        })
        task.resume()
    }
    
}

extension WeatherApiService: WeatherListServiceProtocol {

   func fetchCurrentWeather(completion: @escaping (Result<[CurrentWeather], NetworkError>) -> Void) {
       let ids = City.allCases.map{ $0.rawValue}.map { String($0) }.joined(separator:",")
       let urlString = "\(apiURL)/group?\(apiKey)&\(exclusions)&\(units)&id=\(ids)"

       performRequest(with: urlString) { (result) in
        if case let Result.success(data) = result {
            let parsedResponse = self.parsingService.parseCurrentWeather(data)
            
            guard let currentWeather = parsedResponse else {
                completion(.failure(.decodingError(message: "Cannot parse data correctly.")))
                return
            }
            print(currentWeather.currentWeatherList)
            completion(.success(currentWeather.currentWeatherList))
            
        } else if case let Result.failure(error) = result {
            completion(.failure(error))
        }
       }
   }
    
}

extension WeatherApiService: WeatherDetailServiceProtocol {
    
    func fetchHourlyWeather(for city: String, completion: @escaping (Result<HourlyWeather, NetworkError>) -> Void) {
        let urlString = "\(apiURL)/forecast?\(apiKey)&\(units)&q=\(city)"
        
        performRequest(with: urlString) { (result) in
            
            if case let Result.success(data) = result {
                let parsedResponse = self.parsingService.parseHourlyWeather(data, city: city)
                
                guard let hourlyWeather = parsedResponse else {
                    completion(.failure(.decodingError(message: "Cannot parse data correctly.")))
                    return
                } 
                
                completion(.success(hourlyWeather))
            } else if case let Result.failure(error) = result {
                completion(.failure(error))
            }
        }
    }
    
    func fetchDailyWeather(with latitude: String,_ longitude: String, completion: @escaping (Result<DailyWeather, NetworkError>) -> Void) {
        let urlString = "\(apiURL)/onecall?\(apiKey)&\(units)&lat=\(latitude)&lon=\(longitude)&\(exclusions)"
        
        performRequest(with: urlString) { (result) in
            
            if case let Result.success(data) = result {
                let parsedResponse = self.parsingService.parseDailyWeather(data)
                
                guard let dailyWeather = parsedResponse else {
                    completion(.failure(.decodingError(message: "Cannot parse data correctly.")))
                    return
                }
                
                completion(.success(dailyWeather))
            } else if case let Result.failure(error) = result {
                completion(.failure(error))
            }
        }
    }
    
}
