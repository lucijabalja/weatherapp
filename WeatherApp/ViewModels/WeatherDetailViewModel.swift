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
    var weeklyWeather: WeeklyWeather
    
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
        self.weeklyWeather = WeeklyWeather(city: currentWeather.city, dailyWeather: [], hourlyWeather: [])
    }
    
    func getWeeklyWeather(completion: @escaping (Result<Bool, Error>) -> Void) {
        locationService.getLocationCoordinates(location: currentWeather.city) { (latitude, longitude ) in
            self.dataRepository.getWeeklyWeather(latitude: latitude, longitude: longitude) { (result) in
                switch result {
                case .success(let dailyForecastEntity):
                    self.saveToWeeklyWeather(with: dailyForecastEntity)
                    
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
        }
    }
    
    func saveToWeeklyWeather(with weeklyForecastEntity: WeeklyForecastEntity) {
        for dailyWeatherEntity in weeklyForecastEntity.dailyWeather {
            let dailyWeather = dailyWeatherEntity as! DailyWeatherEntity
            let daily = DailyWeather(from: dailyWeather)
            weeklyWeather.dailyWeather.append(daily)
        }
        
        for hourlyWeatherEntity in weeklyForecastEntity.hourlyWeather {
            let hourlyWeather = hourlyWeatherEntity as! HourlyWeatherEntity
  
            let hourly = HourlyWeather(from: hourlyWeather)
            weeklyWeather.hourlyWeather.append(hourly)
        }
        
        weeklyWeather.dailyWeather.sort { $0.dateTime < $1.dateTime }
        weeklyWeather.hourlyWeather.sort { $0.dateTime < $1.dateTime }
    }
    
}
