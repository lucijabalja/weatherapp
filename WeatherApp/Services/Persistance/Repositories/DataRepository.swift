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
    
    let weatherApiService: ApiService
    let coreDataService: CoreDataService
    let disposeBag = DisposeBag()
    
    typealias WeatherResponse = Observable<Result<CurrentWeatherResponse, NetworkError>>
    typealias ForecastResponse = Observable<Result<CurrentForecast, NetworkError>>
    typealias WeeklyResponse = Observable<Result<WeeklyWeatherResponse, NetworkError>>
    
    init(weatherApiService: ApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
}

extension DataRepository: WeatherListDataRepository {
    
    func getCurrentWeatherData() -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> {
        let apiURL = URLGenerator.currentWeather(ids: getCurrentCityIds())
        let weatherData: WeatherResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if case let .success(currentForecast) = result {
                    self.coreDataService.saveCurrentWeatherData(currentForecast.currentForecastList)
                }
            }).flatMap { [weak self ] (_) -> Observable<[CurrentWeatherEntity]> in
                guard let self = self else {  return Observable.just([]) }
                
                return self.coreDataService.loadCurrentWeatherData()
            }.flatMap { (currentWeatherEntities) -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> in
                guard currentWeatherEntities.count > 0 else {
                    return Observable.just(.failure(.loadingError))
                }
                
                return Observable.just(.success(currentWeatherEntities))
            }
    }
    
    func getCurrentWeatherData(for city: String) -> ForecastResponse {
        let apiURL = URLGenerator.currentCityWeather(forCity: city)
        let weatherData: ForecastResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if case let .success(currentForecast) = result {
                    self.coreDataService.saveCurrentWeatherData([currentForecast])
                }
            })
            .flatMap { (result) -> ForecastResponse in
                return .just(result)
            }
    }
    
    func removeCurrentWeather(for city: String) {
        coreDataService.deleteCurrentWeather(with: city)
    }
    
    func reorderCurrentWeatherList(_ currentWeatherEntity: CurrentWeatherEntity,_ sourceIndex: Int,_ destinationIndex: Int) {
        coreDataService.reorderCurrentWeatherList(currentWeatherEntity, sourceIndex, destinationIndex)
    }
    
    private func getCurrentCityIds() -> String {
        let cityIds = coreDataService.loadCityEntites().map { String($0.id) }
        return cityIds.count > 0 ? cityIds.map { $0 }.joined(separator:",") : Constants.defaultCityIds
    }
    
}

extension DataRepository: DetailWeatherDataRepository {
    
    func getWeeklyWeather(latitude: Double, longitude: Double) -> Observable<[WeeklyForecastEntity]> {
        let apiURL = URLGenerator.weeklyWeather(with: latitude, longitude)
        let weeklyWeatherResponse: WeeklyResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weeklyWeatherResponse
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if case let .success(weeklyWeatherResponse) = result {
                    self.coreDataService.saveWeeklyForecast(weeklyWeatherResponse)
                }
            }).flatMap { [weak self ] (_) -> Observable<[WeeklyForecastEntity]> in
                guard let self = self else { return Observable.just([]) }
                
                return self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude)
        }
    }
    
}
