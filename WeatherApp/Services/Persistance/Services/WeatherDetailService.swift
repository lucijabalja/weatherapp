//
//  WeatherDetailService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 16/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherDetailCoreDataService {
    
    func saveWeeklyForecast(_ weeklyWeatherResponse: WeeklyWeatherResponse)
    func loadWeeklyForecast(withCoordinates latitude: Double, _ longitude: Double) -> WeeklyForecastEntity?

}
