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
    
    func fetchCityWeather(completionHandler: @escaping (Result<CityWeather, NetworkError>) -> Void) {
        cities.forEach { (city) in
            apiService.fetchCurrentWeather(for: city.rawValue) { (result) in
                switch result {
                case .success(let cityWeather):
                    self.cityWeather.append(cityWeather)
                    completionHandler(.success(cityWeather))
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
    
    func pushToDetailView(at index: Int) {
        guard let selectedCity = cityWeather[safeIndex: index] else { return }
        
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
