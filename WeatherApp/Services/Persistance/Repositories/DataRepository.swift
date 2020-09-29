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
    
    typealias CurrentWeatherApiResponse = Observable<Result<CurrentWeatherResponse, NetworkError>>
    typealias ForecastApiResponse = Observable<Result<CurrentForecast, NetworkError>>
    typealias WeeklyApiResponse = Observable<Result<WeeklyWeatherResponse, NetworkError>>
    
    typealias CurrentWeatherDataResult = Observable<Result<[CurrentWeatherEntity], PersistanceError>>
    typealias WeeklyForecastDataResult = Observable<Result<[WeeklyForecastEntity], PersistanceError>>
    
    init(weatherApiService: ApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
}

extension DataRepository: WeatherListDataRepository {
    
    func getCurrentWeatherData() -> CurrentWeatherDataResult {
        let apiURL = URLGenerator.currentWeather(ids: getCurrentCityIds())
        let weatherData: CurrentWeatherApiResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if case let .success(currentForecast) = result {
                    return self.coreDataService.saveCurrentWeatherData(currentForecast.currentForecastList)
                }
            })
            .flatMap { [weak self ] (result) -> CurrentWeatherDataResult in
                guard let self = self else {
                    return Observable.just(.failure(PersistanceError.loadingError))
                }
                
                return self.coreDataService.loadCurrentWeatherData()
            }
    }
    
    func getCurrentWeatherData(for city: String) -> ForecastApiResponse {
        let apiURL = URLGenerator.currentCityWeather(forCity: city)
        let weatherData: ForecastApiResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if case let .success(currentForecast) = result {
                    self.coreDataService.saveCurrentWeatherData([currentForecast])
                }
            })
            .flatMap { (result) -> ForecastApiResponse in
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
        return cityIds.map { $0 }.joined(separator:",")
    }
    
}

extension DataRepository: DetailWeatherDataRepository {
    
    func getWeeklyWeather(latitude: Double, longitude: Double) -> WeeklyForecastDataResult {
        let apiURL = URLGenerator.weeklyWeather(with: latitude, longitude)
        let weeklyWeatherResponse: WeeklyApiResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weeklyWeatherResponse
            .do(onNext: { [weak self] result in
                guard let self = self else { return }
                
                if case let .success(weeklyWeatherResponse) = result {
                    self.coreDataService.saveWeeklyForecast(weeklyWeatherResponse)
                }
            }).flatMap { [weak self ] (result) -> WeeklyForecastDataResult in
                guard let self = self else {
                    return Observable.just(.failure(.loadingError))
                }
        
                return self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude)
            }
    }
    
}
