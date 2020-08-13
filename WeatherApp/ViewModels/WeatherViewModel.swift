//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherViewModel {
    
    private var apiService: WeatherListService
    private var parsingService: ParsingService
    private let coordinator: Coordinator
    private let cities = City.allCases
    var weatherData: [CityWeather] = []
    
    init(coordinator: Coordinator, apiService: WeatherListService, parsingService: ParsingService) {
        self.coordinator = coordinator
        self.apiService = apiService
        self.parsingService = parsingService
    }
    
    func fetchCityWeather(completionHandler: @escaping (ApiResponseMessage) -> Void) {
        cities.forEach { (city) in
            apiService.fetchCurrentWeather(for: city.rawValue) { (data) in
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
        guard checkCount(with: index) else { return }
        
        let selectedCity = weatherData[index]
        coordinator.pushDetailViewController(selectedCity)
    }
    
    func checkCount(with index: Int) -> Bool {
        return weatherData.count > index
    }
    
}
