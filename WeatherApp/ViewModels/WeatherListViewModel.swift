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
    
    func fetchCityWeather(completionHandler: @escaping (WeatherApiResponse) -> Void) {
        dataRepository.fetchCurrentWeather(for: cities) { (weatherApiResponse) in
            
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
