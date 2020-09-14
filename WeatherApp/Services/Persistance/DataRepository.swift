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
}
