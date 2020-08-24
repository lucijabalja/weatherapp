//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {

    func saveCurrentWeatherData(_ currentWeatherResponse: CurrentWeatherResponse) {
        CurrentForecastEntity.createFrom(currentWeatherResponse)
    }
    
    func loadCurrentForecastData() -> CurrentForecastEntity? {
        CurrentForecastEntity.loadCurrentForecast()
    }
    
    func saveDailyForecast(_ dailyWeatherResponse: DailyWeatherResponse) {
        DailyForecastEntity.createFrom(dailyWeatherResponse)
    }
    
    func loadDailyForecast(withCoordinates latitude: Double, _ longitude: Double) -> DailyForecastEntity? {
        DailyForecastEntity.loadDailyForecast(with: latitude, longitude)
    }
    
    func loadHourlyForecast(forCity city: String) -> HourlyForecastEntity? {
        HourlyForecastEntity.loadHourlyForecast(for: city)
    }
    
    func saveHourlyForecast(_ hourlyWeatherResponse: HourlyWeatherResponse,_ city: String) {
        HourlyForecastEntity.createFrom(hourlyWeatherResponse, city)
    }
    
}
