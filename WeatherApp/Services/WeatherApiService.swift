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
        let url = URL(string: apiURL + "&q=\(city)")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching weather data: \(error)")
                return
            }
            
            guard let safedata = data else { return }
            
            let weather = try? JSONDecoder().decode(Weather.self, from: safedata)
            if let safeWeather = weather {
                let weatherData = self.prepareData(safeWeather, city)
                completion(weatherData)
            }
        })
        task.resume()
    }
    
    func prepareData(_ weather: Weather, _ city: String) -> WeatherData {
        let weatherIcon = setWeatherIcon(weather.weatherDescription[0].conditionID)
        return WeatherData(city: city, parameters: weather.mainWeatherData, icon: weatherIcon, description: weather.weatherDescription[0].weatherDescription)
    }
    
    func setWeatherIcon(_ weatherID: Int) -> String {
        switch weatherID {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fog.fill"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}

