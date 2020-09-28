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
    private var dataRepository: DetailWeatherDataRepository
    var currentWeather: CurrentWeather
    var dailyWeather = BehaviorRelay<[DailyWeather]>(value: [])
    var currentWeatherDetails: PublishSubject<CurrentDetails>
    var refreshData = PublishSubject<Void>()
    var showLoading = BehaviorRelay<Bool>(value: true)
    let disposeBag = DisposeBag()
    
    var date: String {
        Utils.formatDate()
    }
    
    var time: String {
        Utils.formatTime()
    }
    
    var hourlyWeather: Observable<[SectionOfHourlyWeather]> {
        return refreshData
            .asObservable()
            .flatMap{ [weak self] (_) -> Observable<[WeeklyForecastEntity]> in
                guard let self = self else { return Observable.just([])}
                
                self.showLoading.accept(true)
                return self.dataRepository.getWeeklyWeather(latitude: self.locationService.coordinates.value.latitude,
                                                            longitude: self.locationService.coordinates.value.longitude)
            }
            .flatMap { [weak self] weeklyForecastEntities -> Observable<[SectionOfHourlyWeather]> in
                guard
                    let self = self,
                    let weeklyForecastEntity = weeklyForecastEntities.first
                else {
                    return Observable.just([])
                }
                
                let hourlyWeatherList = weeklyForecastEntity.hourlyWeather
                    .map { HourlyWeather(from: $0 as! HourlyWeatherEntity) }
                    .sorted { $0.dateTime < $1.dateTime }
                    .map( {SectionOfHourlyWeather(items: [$0]) } )
                
                let dailyWeatherList = weeklyForecastEntity.dailyWeather
                    .map { DailyWeather(from: $0 as! DailyWeatherEntity ) }
                    .sorted { $0.dateTime < $1.dateTime }
                
                self.currentWeatherDetails.onNext(CurrentDetails(from: weeklyForecastEntity.currentDetails))
                self.dailyWeather.accept(dailyWeatherList)
                self.showLoading.accept(false)
                
                return Observable.just(hourlyWeatherList)
            }
    }
    
    init(appDependencies: AppDependencies, currentWeather: CurrentWeather, coordinator: Coordinator) {
        self.currentWeather = currentWeather
        self.coordinator = coordinator
        self.locationService = appDependencies.locationService
        self.dataRepository = appDependencies.dataRepository
        self.currentWeatherDetails = PublishSubject()
        
        locationService.getLocationCoordinates(location: currentWeather.city)
        refreshData.onNext(())
    }
    
}

