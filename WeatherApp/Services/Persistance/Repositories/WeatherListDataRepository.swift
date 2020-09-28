//
//  WeatherListDataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 16/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherListDataRepository {
    
    func getCurrentWeatherData() -> Observable<Result<[CurrentWeatherEntity], PersistanceError>>
    
    func getCurrentWeatherData(for city: String) -> Observable<Result<CurrentForecast, NetworkError>>
    
    func removeCurrentWeather(for city: String)
    
    func reorderCurrentWeatherList(_ currentWeatherEntity: CurrentWeatherEntity,_ sourceIndex: Int,_ destinationIndex: Int)
}
