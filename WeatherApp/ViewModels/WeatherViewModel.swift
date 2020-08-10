//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherViewModel {
    
    private let cities = City.allCases
    private var coordinator: Coordinator
    var weatherData: [CityWeather] = []
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func fetchWeatherData(completionHandler: @escaping (ApiResponseStatus) -> Void) {
        cities.forEach { (city) in
            coordinator.getCityWeather(city.rawValue) { (cityWeather, responseStatus) in
                guard let cityWeather = cityWeather else {
                    completionHandler(.FAILED)
                    return
                }
                self.weatherData.append(cityWeather)
                completionHandler(.SUCCESSFUL)
            }
        }
    }
    
    func pushToDetailView(at index: Int) {
        guard checkCount(with: index) else {
            return
        }
        
        let selectedCity = weatherData[index]
        coordinator.pushDetailViewController(selectedCity)
    }
    
    func checkCount(with index: Int) -> Bool {
        return weatherData.count > index
    }
}
