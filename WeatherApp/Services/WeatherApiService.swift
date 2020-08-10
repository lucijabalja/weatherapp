//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherApiService {
    private let apiKey = "56151fef235e6cebb33750525932d021"
    private lazy var apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    
    func fetchWeather(for city: String, completion: @escaping (CityWeather?) -> Void) {
        let urlString = "\(apiURL)&q=\(city)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completion(nil)
                print("Error with fetching weather data: \(error)")
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            guard let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                completion(nil)
                return
            }
                        
            let weatherData = weather.convertToWeatherData(with: city)
            completion(weatherData)
            
        })
        task.resume()
    }
}

