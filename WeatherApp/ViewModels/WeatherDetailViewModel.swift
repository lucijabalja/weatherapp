//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherDetailViewModel {
    
    private let locationService: LocationService
    private let coordinator: Coordinator
    private var dataRepository: DataRepository
    var currentWeather: CurrentWeather
    var hourlyWeatherList = [HourlyWeather]()
    var dailyWeatherList = [DailyWeather]()
    
    var date: String {
        Utils.getFormattedDate()
    }
    
    var time: String {
        Utils.getFormattedTime()
    }
    
    init(appDependencies: AppDependencies, currentWeather: CurrentWeather, coordinator: Coordinator) {
        self.currentWeather = currentWeather
        self.coordinator = coordinator
        self.locationService = appDependencies.locationService
        self.dataRepository = appDependencies.dataRepository
    }
    
    func getHourlyWeather(completion: @escaping (Result<Bool, Error>) -> Void) {
        dataRepository.getHourlyWeather(city: currentWeather.city) { [weak self] (result) in
            switch result {
            case .success(let hourlyForecastEntity):
                self?.saveToHourlyWeather(with: hourlyForecastEntity)
                completion(.success(true))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveToHourlyWeather(with hourlyForecastEntity: HourlyForecastEntity) {
        for hourlyWeatherEntity in hourlyForecastEntity.hourlyWeather {
            let hourly = hourlyWeatherEntity as! HourlyWeatherEntity
            
            let hourlyWeather = HourlyWeather(city: hourlyForecastEntity.city,
                                              time: Int(hourly.time),
                                              temperature: Utils.getFormattedTemperature(hourly.temperature),
                                              icon: Utils.resolveWeatherIcon(Int(hourly.conditionID)))
            
            hourlyWeatherList.append(hourlyWeather)
        }
        hourlyWeatherList.sort { $0.time < $1.time }
    }
    
    func getDailyWeather(completion: @escaping (Result<Bool, Error>) -> Void) {
        locationService.getLocationCoordinates(location: currentWeather.city) { [weak self] (latitude, longitude ) in
            self?.dataRepository.getDailyWeather(latitude: latitude, longitude: longitude) { [weak self] (result) in
                switch result {
                case .success(let dailyForecastEntity):
                    self?.saveToDailyWeather(with: dailyForecastEntity)
                    
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        }
    }
    
    func saveToDailyWeather(with dailyForecastEntity: DailyForecastEntity) {
        for dailyWeather in dailyForecastEntity.dailyWeather {
            let daily = dailyWeather as! DailyWeatherEntity
            let temperature = convertToCurrentTemperature(daily.temperature)
            let dailyWeather = DailyWeather(weekDay: daily.weekDay, temperature: temperature, icon: daily.icon)
            
            dailyWeatherList.append(dailyWeather)
        }
    }
    
    func convertToCurrentTemperature(_ temperature: TemperatureEntity) -> CurrentTemperature {
        CurrentTemperature(now: nil,
                           min: Utils.getFormattedTemperature(temperature.min),
                           max: Utils.getFormattedTemperature(temperature.max))
    }
    
}
