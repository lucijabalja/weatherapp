//
//  WeatherListService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 13/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

protocol WeatherListServiceProtocol {
    
    func fetchCurrentWeather(completion: @escaping (Result<CurrentWeatherResponse, NetworkError>) -> Void)

}
