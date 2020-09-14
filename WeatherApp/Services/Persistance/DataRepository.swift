//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DataRepository {
    
    let weatherApiService: WeatherApiService
    let coreDataService: CoreDataService
    let disposeBag = DisposeBag()
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
    func getCurrentWeatherData() -> Observable<Result<CurrentForecastEntity, PersistanceError>> {
        let weatherData: Observable<Result<CurrentWeatherResponse, NetworkError>> = weatherApiService.fetchData(urlString: URLGenerator.currentWeather())
        
        return weatherData.do(onNext: { [weak self] (result) in
            guard let self = self else { return }
            
            if case let .success(currentWeatherResponse) = result {
                self.coreDataService.saveCurrentWeatherData(currentWeatherResponse)
            }
        }).flatMap { [weak self ] (_) -> Observable<Result<CurrentForecastEntity, PersistanceError>> in
            guard
                let self = self,
                let currentForecastEntity = self.coreDataService.loadCurrentForecastData()
                else {
                    return Observable.just(.failure(.loadingError))
            }
            
            return Observable.of(.success(currentForecastEntity))
        }
    }
    
    func getWeeklyWeather(latitude: Double, longitude: Double) -> Observable<Result<WeeklyForecastEntity, PersistanceError>> {
        let weeklyWeatherResponse: Observable<Result<WeeklyWeatherResponse, NetworkError>> = weatherApiService.fetchData(urlString: URLGenerator.weeklyWeather(latitude: latitude, longitude: longitude))
        
        return weeklyWeatherResponse
            .do(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if case let .success(weeklyWeatherResponse) = result {
                    self.coreDataService.saveWeeklyForecast(weeklyWeatherResponse)
                }
            })
            .flatMap { [weak self ] (_) -> Observable<Result<WeeklyForecastEntity, PersistanceError>> in
                guard
                    let self = self,
                    let loadedEntities = self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude)
                    else {
                        return Observable.just(.failure(.loadingError))
                }
                
                return Observable.of(.success(loadedEntities))
        }
    }
    
}
