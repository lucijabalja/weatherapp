//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {
    
    var cityWeather: CityWeather
    var dailyWeather: DailyWeather?
    private var apiService: WeatherDetailService
    private var parsingService: ParsingService
    private var coordinator: Coordinator
    
    var date: String {
        return Utils.getFormattedDate()
    }
    
    var time: String {
        return Utils.getFormattedTime()
    }
    
    init(coordinator: Coordinator, apiService: WeatherDetailService, parsingService: ParsingService, cityWeather: CityWeather) {
        self.coordinator = coordinator
        self.apiService = apiService
        self.cityWeather = cityWeather
        self.parsingService = parsingService
    }
    
    func getDailyWeather(completion: @escaping (ApiResponseMessage) -> Void) {
        apiService.fetchDailyWeather(for: cityWeather.city) { (data) in
            let parsedResponse = self.parsingService.parseDailyWeather(data, city: self.cityWeather.city)
            guard let dailyWeather = parsedResponse else {
                completion(.FAILED)
                return
            }
            self.dailyWeather = dailyWeather
            completion(.SUCCESSFUL)
        }
    }
    
}
