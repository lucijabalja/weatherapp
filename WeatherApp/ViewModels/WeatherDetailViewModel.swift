//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {
    
    private var coordinator: Coordinator
    var cityWeather: CityWeather
    
    init(coordinator: Coordinator, cityWeather: CityWeather) {
        self.coordinator = coordinator
        self.cityWeather = cityWeather
    }
    
    func getCurrentCityWeather() -> CityWeather {
        return cityWeather
    }
    
    func fetchDailyWeather() {
        coordinator.getDailyWeather("Zagreb") { (dailyWeather) in
        }
    }
    
}
