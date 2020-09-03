//
//  WeatherDetailService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 13/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherDetailServiceProtocol {
        
    func fetchWeeklyWeather(with latitude: Double,_ longitude: Double, completion: @escaping (Result<WeeklyWeatherResponse, NetworkError>) -> Void)
    
}
