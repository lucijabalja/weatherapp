//
//  WeatherDetailService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 13/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherDetailServiceProtocol {
    
    func fetchHourlyWeather(for city: String, completion: @escaping (WeatherApiResponse) -> Void)
    
    func fetchDailyWeather(with latitude: String,_ longitude: String, completion: @escaping (WeatherApiResponse) -> Void)
    
}
