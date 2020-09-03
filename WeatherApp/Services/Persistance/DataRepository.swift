//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class DataRepository {
    
    let weatherApiService: WeatherApiService
    let coreDataService: CoreDataService
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
    func getCurrentWeatherData(completion: @escaping (Result<CurrentForecastEntity, Error>) -> Void) {
        weatherApiService.fetchCurrentWeather(completion: { [weak self] (result) in
            switch result {
            case .success(let currentWeatherResponse):
                self?.coreDataService.saveCurrentWeatherData(currentWeatherResponse)
                
                guard let currentWeatherEntity = self?.coreDataService.loadCurrentForecastData() else {
                    completion(.failure(PersistanceError.loadingError))
                    return
                }
                
                completion(.success(currentWeatherEntity))
                
            case .failure(let error):
                guard let currentWeatherEntity = self?.coreDataService.loadCurrentForecastData() else {
                    completion(.failure(error))
                    return
                }
                
                completion(.success(currentWeatherEntity))
            }
        })
    }
    
    func getWeeklyWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeeklyForecastEntity, Error>) -> Void) {
        weatherApiService.fetchWeeklyWeather(with: latitude, longitude) { (result) in
            switch result {
            case .success(let dailyWeatherResponse):
                self.coreDataService.saveWeeklyForecast(dailyWeatherResponse)
                guard let weeklyForecastEntity = self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude) else { return }
                
                completion(.success(weeklyForecastEntity))
                
            case .failure(_):
                guard let weeklyForecastEntity = self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude) else {
                    return
                }
                
                completion(.success(weeklyForecastEntity))
            }
        }
    }
}
