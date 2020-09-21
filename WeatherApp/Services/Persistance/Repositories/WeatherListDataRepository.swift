//
//  MainWeatherDataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 16/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherListDataRepository {
    
    func getCurrentWeatherData() -> Observable<[CurrentWeatherEntity]>
    
    func getCurrentWeatherData(for city: String)

    func removeCurrentWeather(for city: String)
    
}
