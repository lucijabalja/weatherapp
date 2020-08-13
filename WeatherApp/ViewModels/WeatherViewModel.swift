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
    private let coordinator: Coordinator
    private let weatherService = WeatherApiService()
    private let parsingService = ParsingService()
    var weatherData: [CityWeather] = []
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func fetchCityWeather(completionHandler: @escaping (ApiResponseStatus) -> Void) {
        cities.forEach { (city) in
            weatherService.fetchCurrentWeather(for: city.rawValue) { (data) in
                let parsedResponse = self.parsingService.parseCityWeather(data, city: city.rawValue)
                guard let cityWeather = parsedResponse else {
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
