//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherListViewModel {
    
    private var apiService: WeatherListServiceProtocol
    private let coordinator: Coordinator
    private let cities = City.allCases
    var cityWeather: [CityWeather] = []
    
    init(apiService: WeatherListServiceProtocol, coordinator: Coordinator) {
        self.apiService = apiService
        self.coordinator = coordinator
    }
    
    func fetchCityWeather(completionHandler: @escaping (WeatherApiResponse) -> Void) {
        cities.forEach { (city) in
            apiService.fetchCurrentWeather(for: city.rawValue) { (apiResponse) in
                switch apiResponse {
                case .SUCCESSFUL(let cityWeather):
                    self.cityWeather.append(cityWeather as! CityWeather)
                    completionHandler(.SUCCESSFUL(data: cityWeather))
                    
                case .FAILED(let error):
                    completionHandler(.FAILED(error: error))
                }
            }
        }
    }
    
    func pushToDetailView(at index: Int) {
        guard checkCount(with: index) else { return }
        
        let selectedCity = cityWeather[index]
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
    func checkCount(with index: Int) -> Bool {
        cityWeather.count > index
    }
    
}
