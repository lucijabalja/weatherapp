//
//  MainWeatherDataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 16/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift

protocol MainWeatherDataRepository {
    
    func getCurrentWeatherData() -> Observable<Result<[CurrentWeatherEntity],PersistanceError>>
    
    func getCurrentCityWeather(for city: String)
    
}
