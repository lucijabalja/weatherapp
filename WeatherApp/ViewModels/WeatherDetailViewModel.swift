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
    
    func getHourlyWeather(completion: @escaping (Result<HourlyWeather, Error>) -> Void) {
        apiService.fetchHourlyWeather(for: cityWeather.city) { (result) in
            switch result {
            case .success(let hourlyWeather):
                self.hourlyWeather = hourlyWeather
                completion(.success(hourlyWeather))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getDailyWeather(completion: @escaping (Result<DailyWeather, Error>) -> Void) {
        locationService.getLocationCoordinates(location: cityWeather.city) { (latitude, longitude ) in
            self.apiService.fetchDailyWeather(with: latitude, longitude) { (result) in
                switch result {
                case .success(let dailyWeather):
                    self.dailyWeather = dailyWeather
                    completion(.success(dailyWeather))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
}
