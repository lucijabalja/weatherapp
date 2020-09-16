//
//  DetailWeatherDataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 16/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import RxSwift

protocol DetailWeatherDataRepository {
    
    func getWeeklyWeather(latitude: Double, longitude: Double) -> Observable<Result<WeeklyForecastEntity, PersistanceError>>
    
}
