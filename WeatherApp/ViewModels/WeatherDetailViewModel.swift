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
    var dailyWeather: BehaviorRelay<[DailyWeather]> = BehaviorRelay(value: [])
    var hourlyWeather: BehaviorRelay<[SectionOfHourlyWeather]> = BehaviorRelay(value: [])
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
        
        locationService.getLocationCoordinates(location: currentWeather.city)
        getWeeklyWeather()
    }
    
    func getWeeklyWeather() {
        dataRepository.getWeeklyWeather(latitude: locationService.coordinates.value.latitude,
                                        longitude: locationService.coordinates.value.longitude)
            .subscribe(onNext: { [weak self] (weeklyForecastEntity) in
                guard let self = self else { return }
                
                let hourlyWeatherList = weeklyForecastEntity.hourlyWeather
                    .map { HourlyWeather(from: $0 as! HourlyWeatherEntity) }
                    .sorted { $0.dateTime < $1.dateTime }
                    .map( {SectionOfHourlyWeather(items: [$0]) } )

                let dailyWeatherList = weeklyForecastEntity.dailyWeather
                    .map { DailyWeather(from: $0 as! DailyWeatherEntity ) }
                    .sorted { $0.dateTime < $1.dateTime }

  
                self.hourlyWeather.accept(hourlyWeatherList)
                self.dailyWeather.accept(dailyWeatherList)
                }, onError: { (error) in
                    print(error)
            }).disposed(by: self.disposeBag)
    }
    
}

