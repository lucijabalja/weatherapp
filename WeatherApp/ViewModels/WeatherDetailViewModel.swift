//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherDetailViewModel {
    
    private let locationService: LocationService
    private let coordinator: Coordinator
    private var dataRepository: DataRepository
    var currentWeather: CurrentWeather
    var weeklyWeather: BehaviorRelay<WeeklyWeather>
    var refreshData = PublishSubject<Void>()
    var showLoading = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var date: String {
        Utils.getFormattedDate()
    }
    
    var time: String {
        Utils.getFormattedTime()
    }
    
    init(appDependencies: AppDependencies, currentWeather: CurrentWeather, coordinator: Coordinator) {
        self.currentWeather = currentWeather
        self.coordinator = coordinator
        self.locationService = appDependencies.locationService
        self.dataRepository = appDependencies.dataRepository
        self.weeklyWeather = BehaviorRelay(value: WeeklyWeather(city: currentWeather.city, dailyWeatherList: [], hourlyWeatherList: []))
        
        locationService.getLocationCoordinates(location: currentWeather.city)
        getWeeklyWeather()
        bindRefreshData()
    }
    
    private func getWeeklyWeather() {
        dataRepository.getWeeklyWeather(latitude: locationService.coordinates.value.latitude,
                                        longitude: locationService.coordinates.value.longitude)
            .subscribe(
                onNext: { [weak self] (result) in
                    guard let self = self else { return }
                    self.showLoading.accept(true)
                    
                    if case let .success(weeklyForecastEntity) = result {
                        let newWeeklyWeather = self.mapWeeklyDataToViewModel(weeklyForecastEntity)
                        self.weeklyWeather.accept(newWeeklyWeather)
                        self.showLoading.accept(false)
                        
                    }
            }).disposed(by: self.disposeBag)
    }
    
    private func bindRefreshData() {
        refreshData
            .asObservable()
            .flatMap{ _ -> Observable<Result<WeeklyForecastEntity, PersistanceError>> in
                self.showLoading.accept(true)
                return self.dataRepository.getWeeklyWeather(latitude: self.locationService.coordinates.value.latitude,
                                                            longitude: self.locationService.coordinates.value.longitude)
        }
        .flatMap { (result) -> Observable<WeeklyWeather> in
            switch result {
            case .success(let weeklyForecastEntity):
                let newWeeklyWeather = self.mapWeeklyDataToViewModel(weeklyForecastEntity)
                self.showLoading.accept(false)
                
                return Observable.just(newWeeklyWeather)
                
            case .failure(let error):
                self.showLoading.accept(false)
                
                return Observable.error(error)
            }
        }
        .bind(to: weeklyWeather)
        .disposed(by: disposeBag)
    }
    
    private func mapWeeklyDataToViewModel(_ weeklyForecastEntity: WeeklyForecastEntity) -> WeeklyWeather {
        let hourlyWeatherList = weeklyForecastEntity.hourlyWeather.map { HourlyWeather(from: $0 as! HourlyWeatherEntity) }
        let dailyWeatherList = weeklyForecastEntity.dailyWeather.map { DailyWeather(from: $0 as! DailyWeatherEntity ) }
        var newWeeklyWeather = WeeklyWeather(city: self.currentWeather.city, dailyWeatherList: dailyWeatherList, hourlyWeatherList: hourlyWeatherList)
        
        newWeeklyWeather.dailyWeatherList.sort { $0.dateTime < $1.dateTime }
        newWeeklyWeather.hourlyWeatherList.sort { $0.dateTime < $1.dateTime }
        
        return newWeeklyWeather
    }
    
}

