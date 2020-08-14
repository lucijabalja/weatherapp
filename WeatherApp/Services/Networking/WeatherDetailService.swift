//
//  WeatherDetailService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 13/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherDetailService {
    
    func fetchHourlyWeather(for city: String, completion: @escaping (Data) -> Void)
    
    func fetchDailyWeather(lat: String, lon: String, completion: @escaping (Data) -> Void)
    
}
