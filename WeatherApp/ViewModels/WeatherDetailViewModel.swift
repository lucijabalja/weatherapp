//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {
    
    private let apiService: WeatherApiService
    private let locationService: LocationService
    private let coordinator: Coordinator
    var cityWeather: CityWeather
    var hourlyWeather: HourlyWeather?
    var dailyWeather: DailyWeather?
    
    var date: String {
        return Utils.getFormattedDate()
    }
    
    var time: String {
        return Utils.getFormattedTime()
    }
    
    init(appDependencies: AppDependencies, cityWeather: CityWeather, coordinator: Coordinator) {
        self.apiService = appDependencies.weatherApiService
        self.cityWeather = cityWeather
        self.coordinator = coordinator
        self.locationService = appDependencies.locationService
    }
    
    func getHourlyWeather(completion: @escaping (WeatherApiResponse) -> Void) {
        apiService.fetchHourlyWeather(for: cityWeather.city) { (weatherApiResponse) in
            switch weatherApiResponse {
                case .SUCCESSFUL(let data):
                    self.hourlyWeather = data as? HourlyWeather
                    completion(.SUCCESSFUL(data: data))
                
                case .FAILED(let error):
                completion(.FAILED(error: error))
            }
        }
    }
    
    func getDailyWeather(completion: @escaping (WeatherApiResponse) -> Void) {
        locationService.getLocationCoordinates(location: cityWeather.city) { (latitude, longitude ) in
            self.apiService.fetchDailyWeather(with: latitude, longitude) { (weatherApiResponse) in
                switch weatherApiResponse {
                    case .SUCCESSFUL(let data):
                        self.dailyWeather = data as? DailyWeather
                        completion(.SUCCESSFUL(data: data))
                    
                    case .FAILED(let error):
                    completion(.FAILED(error: error))
                }
            }
        }
    }
    
    func checkHourlyForecastCount(with index: Int) -> Bool {
        guard let hourlyForecast = hourlyWeather?.hourlyForecast else { return false }
        
        return hourlyForecast.count > index
    }
    
    func checkDailyForecastCount(with index: Int) -> Bool {
        guard let dailyWeather = dailyWeather?.dailyForecast else { return false }
        
        return dailyWeather.count > index
    }
    
}
