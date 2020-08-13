//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {
    
    private var coordinator: Coordinator?
    private let weatherService = WeatherApiService()
    private let parsingService = ParsingService()
    var cityWeather: CityWeather
    var dailyWeather: DailyWeather?
    
    var date: String {
        return Utils.getFormattedDate()
    }
    
    var time: String {
        return Utils.getFormattedTime()
    }
    
    init(cityWeather: CityWeather) {
        self.cityWeather = cityWeather
    }
    
    func setCoordinator(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func getDailyWeather(completion: @escaping (ApiResponseStatus) -> Void) {
        weatherService.fetchDailyWeather(for: cityWeather.city) { (data) in
            let parsedResponse = self.parsingService.parseDailyWeather(data, city: self.cityWeather.city)
            self.dailyWeather = parsedResponse
            guard let _ = parsedResponse else {
                completion(.FAILED)
                return
            }
            completion(.SUCCESSFUL)
        }
    }
    
}
