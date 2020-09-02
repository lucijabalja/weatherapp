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

enum LoadError: Error {
    case loadingError
}

class DataRepository {
    
    let weatherApiService: WeatherApiService
    let coreDataService: CoreDataService
    let disposeBag = DisposeBag()
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
    func getCurrentWeatherData() -> Observable<[CurrentWeather]> {
        let weatherData: Observable<CurrentWeatherResponse> = weatherApiService.fetchData(urlString: URLGenerator.currentWeather())
        
        return weatherData.do(onNext: { [weak self] (currentWeatherResponse) in
            guard let self = self else { return }
            
            self.coreDataService.saveCurrentWeatherData(currentWeatherResponse)
        }).flatMap { [weak self] (currentWeatherResponse) -> Observable<[CurrentWeather]> in
            guard let self = self else { return Observable.of() }
            
            let loadedEntities = self.coreDataService.loadCurrentForecastData()
            guard let entities = loadedEntities else { return Observable.of() }
            
            let curentWeatherList = entities.currentWeather.map { CurrentWeather(from: $0 as! CurrentWeatherEntity )}
            return Observable.of(curentWeatherList)
        }
    }
    
    func getWeeklyWeather(latitude: Double, longitude: Double) -> Observable<WeeklyForecastEntity> {
        let weeeklyWeatherResponse: Observable<WeeklyWeatherResponse> = weatherApiService.fetchData(urlString: URLGenerator.weeklyWeather(latitude: latitude, longitude: longitude))
        
        return weeeklyWeatherResponse
            .do(onNext: { [weak self] (weeeklyWeatherResponse) in
                guard let self = self else { return }
                
                self.coreDataService.saveWeeklyForecast(weeeklyWeatherResponse)
            })
            .flatMap { [weak self ] (_) -> Observable<WeeklyForecastEntity> in
                guard let self = self else { return Observable.of() }
                
                let loadedEntities = self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude)
                guard let entities = loadedEntities else { return Observable.of() }
                
                return Observable.of(entities)
        }
    }
}
