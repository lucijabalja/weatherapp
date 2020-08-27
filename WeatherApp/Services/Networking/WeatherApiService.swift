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
    private let exclusions = "exclude=minutely"
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
    
    func fetchCurrentWeather(completion: @escaping (Result<CurrentWeatherResponse, NetworkError>) -> Void) {
        let ids = City.allCases.map{ $0.rawValue}.map { $0 }.joined(separator:",")
        let urlString = "\(apiURL)/group?\(apiKey)&\(exclusions)&\(units)&id=\(ids)"
        
        performRequest(with: urlString) { (result) in
            switch result {
            case .success(let data):
                let parsedResponse = self.parsingService.parseCurrentWeather(data)
                
                guard let currentWeather = parsedResponse else {
                    completion(.failure(.decodingError(message: "Cannot parse data correctly.")))
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

    func fetchWeeklyWeather(with latitude: Double,_ longitude: Double, completion: @escaping (Result<WeeklyWeatherResponse, NetworkError>) -> Void) {
        let urlString = "\(apiURL)/onecall?\(apiKey)&\(units)&lat=\(latitude)&lon=\(longitude)&\(exclusions)"
        
        performRequest(with: urlString) { (result) in
            
            switch result {
            case .success(let data):
                let parsedResponse = self.parsingService.parseWeeklyWeather(data)
                
                guard let weeklyWeather = parsedResponse else {
                    completion(.failure(.decodingError(message: "Cannot parse data correctly.")))
                    return
                }
                
                completion(.success(weeklyWeather))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
