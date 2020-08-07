//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherApiService {
    var apiKey = "56151fef235e6cebb33750525932d021"
    private lazy var apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey)&units=metric"
    
    func fetchWeather(for city: String, completion: @escaping (CityWeather) -> Void) {
        let urlString = "\(apiURL)&q=\(city)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching weather data: \(error)")
                return
            }
            
            guard let safedata = data else { return }
            
            let weather = try? JSONDecoder().decode(Weather.self, from: safedata)
            
            if let safeWeather = weather {
                let weatherData = safeWeather.convertToWeatherData(with: city)
                completion(weatherData)
            }
        })
        task.resume()
    }
}

