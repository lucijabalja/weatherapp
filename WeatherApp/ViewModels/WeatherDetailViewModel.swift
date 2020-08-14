//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import CoreLocation

class WeatherDetailViewModel {
    
    var hourlyWeather: HourlyWeather?
    var dailyWeather: [DailyWeather] = []
    private var apiService: WeatherDetailService
    private var parsingService: ParsingService
    private var locationService: LocationService
    private var coordinator: Coordinator
    var cityWeather: CityWeather
    
    var date: String {
        return Utils.getFormattedDate()
    }
    
    var time: String {
        return Utils.getFormattedTime()
    }
    
    init(coordinator: Coordinator, apiService: WeatherDetailService, parsingService: ParsingService, locationService: LocationService, cityWeather: CityWeather) {
        self.coordinator = coordinator
        self.apiService = apiService
        self.cityWeather = cityWeather
        self.parsingService = parsingService
        self.locationService = locationService
    }
    
    func getHourlyWeather(completion: @escaping (ApiResponseMessage) -> Void) {
        apiService.fetchHourlyWeather(for: cityWeather.city) { (data) in
            let parsedResponse = self.parsingService.parseHourlyWeather(data, city: self.cityWeather.city)
            guard let hourlyWeather = parsedResponse else {
                completion(.FAILED)
                return
            }
            self.hourlyWeather = hourlyWeather
            completion(.SUCCESSFUL)
        }
    }
    
    func getDailyWeather(completion: @escaping (ApiResponseMessage) -> Void) {
        locationService.getLocationCoordinates(location: cityWeather.city) { (latitude, longitude) in
            self.apiService.fetchDailyWeather(lat: latitude, lon: longitude) { data in
                let parsedResponse = self.parsingService.parseDailyWeather(data)
                if parsedResponse.count == 0 {
                    completion(.FAILED)
                }
                self.dailyWeather.append(contentsOf: parsedResponse)
                completion(.SUCCESSFUL)
            }
        }
    }
    
    func checkHourlyForecastCount(with index: Int) -> Bool {
        guard let hourlyForecast = hourlyWeather?.hourlyForecast else { return false }
        
        return hourlyForecast.count > index
    }
    
    func checkDailyForecastCount(with index: Int) -> Bool {
        return dailyWeather.count > index
    }
    
}
