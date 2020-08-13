//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherApiService: WeatherListService, WeatherDetailService {
    
    private let apiURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey = "appid=56151fef235e6cebb33750525932d021"
    private let units = "units=metric"
    
    func fetchCurrentWeather(for city: String, completion: @escaping (Data) -> Void) {
        let urlString = "\(apiURL)/weather?\(apiKey)&\(units)&q=\(city)"
        
        performRequest(with: urlString, city) { (data) in
            completion(data)
        }
    }
    
    func fetchDailyWeather(for city: String, completion: @escaping (Data) -> Void) {
        let urlString = "\(apiURL)/forecast?\(apiKey)&\(units)&q=\(city)"
        
        performRequest(with: urlString, city) { (data) in
            completion(data)
        }
    }
    
    func performRequest(with urlString: String, _ city: String, completion: @escaping (Data) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching weather data: \(error)")
                return
            }
            
            guard let data = data else {
                return
            }
            
            completion(data)
        })
        task.resume()
    }
    
}

