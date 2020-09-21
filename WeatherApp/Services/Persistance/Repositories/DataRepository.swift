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
    
    typealias WeatherResponse = Observable<Result<CurrentWeatherResponse, NetworkError>>
    typealias ForecastResponse = Observable<Result<CurrentForecast, NetworkError>>
    typealias WeeklyWeatherResult = Observable<Result<WeeklyForecastEntity, PersistanceError>>
    typealias WeeklyResponse = Observable<Result<WeeklyWeatherResponse, NetworkError>>
    
    init(weatherApiService: WeatherApiService, coreDataService: CoreDataService) {
        self.weatherApiService = weatherApiService
        self.coreDataService = coreDataService
    }
    
}

extension DataRepository: MainWeatherDataRepository {
    
    func getCurrentWeatherData() -> Observable<[CurrentWeatherEntity]> {
        let apiURL = URLGenerator.currentWeather(ids: getCurrentCityIds())
        let weatherData: WeatherResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData
            .do(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if case let .success(currentWeatherResponse) = result {
                    self.coreDataService.saveCurrentWeatherData(currentWeatherResponse.currentForecastList)
                }
            }).flatMap { [weak self ] (_) -> Observable<[CurrentWeatherEntity]> in
                guard let self = self else {  return Observable.just([]) }
                
                return self.coreDataService.loadCurrentWeatherData()
        }
    }
    
    func getCurrentCityWeather(for city: String) {
        let apiURL = URLGenerator.currentCityWeather(city: city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city)
        let weatherData: ForecastResponse = weatherApiService.fetchData(urlString: apiURL)
        
        weatherData
            .subscribe(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if case let .success(currentWeatherResponse) = result {
                    self.coreDataService.saveCurrentWeatherData([currentWeatherResponse])
                }
            })
            .disposed(by: disposeBag)
    }
    
    func removeCurrentWeather(with city: String) {
        coreDataService.deleteCurrentWeather(with: city)
    }
    
    private func getCurrentCityIds() -> String {
        let cityIds = coreDataService.loadCityEntites().map { String($0.id) }
        return cityIds.count > 0 ? cityIds.map { $0 }.joined(separator:",") : Constants.defaultCityIds
    }
    
}

extension DataRepository: DetailWeatherDataRepository {
    
    func getWeeklyWeather(latitude: Double, longitude: Double) -> Observable<[WeeklyForecastEntity]> {
        let apiURL = URLGenerator.weeklyWeather(latitude: latitude, longitude: longitude)
        let weeklyWeatherResponse: WeeklyResponse = weatherApiService.fetchData(urlString: apiURL)
        
        return weeklyWeatherResponse
            .do(onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if case let .success(weeklyWeatherResponse) = result {
                    self.coreDataService.saveWeeklyForecast(weeklyWeatherResponse)
                }
            }).flatMap { [weak self ] (_) -> Observable<[WeeklyForecastEntity]> in
                guard let self = self else {
                        return Observable.just([])
                }
                
                return self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude)
        }
    }
}
