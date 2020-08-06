//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherApiService {
    let apiURL = "https://api.openweathermap.org/data/2.5/weather?appid=\(Global.apiKey)&units=metric"
    
    func fetchWeather(for city: String, completion: @escaping (WeatherData) -> Void) {
        let url = URL(string: "\(apiURL)&q=\(city)")!
        
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

