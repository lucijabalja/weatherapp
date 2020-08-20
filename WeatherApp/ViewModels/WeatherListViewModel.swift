//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherListViewModel {
    
    private let coordinator: Coordinator
    private let dataRepository: DataRepository
    private let cities = City.allCases
    var cityWeather = [CityWeather]()
    
    init(coordinator: Coordinator, dataRepository: DataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
    }
    
    func fetchCityWeather(completionHandler: @escaping (Result<Bool,NetworkError>) -> Void) {
        cities.forEach { (city) in
            dataRepository.getCurrentCityWeather() { (cityWeather) in
                self.cityWeather.append(contentsOf: cityWeather)
                completionHandler(.success(true))
            }
        }
    }
    
    func pushToDetailView(at index: Int) {
        guard let selectedCity = cityWeather[safeIndex: index] else { return }
        
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
