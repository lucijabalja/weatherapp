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
    
    func getCurrentWeatherData() -> Observable<Result<[CurrentWeatherEntity],PersistanceError>> {
        let apiURL = URLGenerator.currentWeather(ids: getCurrentCityIds())
        let weatherData: Observable<Result<CurrentWeatherResponse, NetworkError>> = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData.do(onNext: { [weak self] (result) in
            guard let self = self else { return }
            
            if case let .success(currentWeatherResponse) = result {
                self.coreDataService.saveCurrentWeatherData(currentWeatherResponse.currentForecastList)
            }
        }).flatMap { [weak self ] (_) -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> in
            guard let self = self else {  return Observable.just(.failure(.loadingError)) }
            
            let currentWeatherEntities = self.coreDataService.loadCurrentForecastData()
            
            return Observable.of(.success(currentWeatherEntities))
        }
    }
    
    func getCurrentCityWeather(for city: String) -> Observable<Result<[CurrentWeatherEntity], PersistanceError>>  {
        let apiURL = URLGenerator.currentCityWeather(city: city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city)
        let weatherData: Observable<Result<CurrentForecast, NetworkError>> = weatherApiService.fetchData(urlString: apiURL)
        
        return weatherData.do(
            onNext: { [weak self] (result) in
                guard let self = self else { return }
                
                if case let .success(currentWeatherResponse) = result {
                    self.coreDataService.saveCurrentWeatherData([currentWeatherResponse])
                }
        }).flatMap { [weak self ] (_) -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> in
            guard let self = self else { return Observable.just(.failure(.loadingError)) }
            
            let currentWeatherEntities = self.coreDataService.loadCurrentForecastData()
            
            return Observable.of(.success(currentWeatherEntities))
        }
    }
    
    func getWeeklyWeather(latitude: Double, longitude: Double, completion: @escaping (Result<WeeklyForecastEntity, Error>) -> Void) {
        weatherApiService.fetchWeeklyWeather(with: latitude, longitude) { (result) in
            switch result {
            case .success(let dailyWeatherResponse):
                self.coreDataService.saveWeeklyForecast(dailyWeatherResponse)
                guard let weeklyForecastEntity = self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude) else { return }
                
                completion(.success(weeklyForecastEntity))
                
            case .failure(_):
                guard let weeklyForecastEntity = self.coreDataService.loadWeeklyForecast(withCoordinates: latitude, longitude) else {
                    return
                }
                
                completion(.success(weeklyForecastEntity))
            }
        }
    }
    
    private func getCurrentCityIds() -> String {
        let cityIds = coreDataService.loadCityEntites().map { String($0.id) }
        return cityIds.count > 0 ? cityIds.map { $0 }.joined(separator:",") : Constants.defaultCityIds
    }
}
