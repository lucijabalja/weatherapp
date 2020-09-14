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
        let weatherData: Observable<Result<CurrentWeatherResponse, NetworkError>> = weatherApiService.fetchData(urlString: URLGenerator.currentWeather())
        
        return weatherData.do(
            onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                switch result {
                case .success(let currentWeatherResponse):
                    self.coreDataService.saveCurrentWeatherData(currentWeatherResponse)
                case .failure(let error):
                    print(error)
                }
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
