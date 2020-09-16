//
//  WeatherListService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 16/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherListCoreDataService {
    
    func saveCurrentWeatherData(_ currentForecastList: [CurrentForecast])
    func loadCurrentWeatherData() -> [CurrentWeatherEntity]

}
