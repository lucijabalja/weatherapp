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
    
    func getCurrentWeatherData() -> Observable<CurrentForecastEntity> {
        let weatherData: Observable<CurrentWeatherResponse> = weatherApiService.fetchData(urlString: URLGenerator.currentWeather())
        
        return weatherData.do(
            onNext: { [weak self] (currentWeatherResponse) in
                guard let self = self else { return }
                
                self.coreDataService.saveCurrentWeatherData(currentWeatherResponse)
        }).flatMap { (_) -> Observable<CurrentForecastEntity> in
            return  Observable.create({ [weak self] (observer) in
                guard let self = self else { return Disposables.create() }
                
                let loadedEntities = self.coreDataService.loadCurrentForecastData()
                guard let entities = loadedEntities else {
                    observer.onError(PersistanceError.loadingError)
                    return Disposables.create()
                }
                
                observer.onNext(entities)
                observer.onCompleted()
                
                return Disposables.create()
                })
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
