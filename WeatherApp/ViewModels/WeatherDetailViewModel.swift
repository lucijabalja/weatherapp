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
        
        getWeeklyWeather()
    }
    
    func getWeeklyWeather() {
        locationService.getLocationCoordinates(location: currentWeather.city) { (latitude, longitude ) in
            self.dataRepository.getWeeklyWeather(latitude: latitude, longitude: longitude)
                .subscribe(
                    onNext: { [weak self] (weeklyForecastEntity) in
                        guard let self = self else { return }
                        
                        let hourlyWeatherList = weeklyForecastEntity.hourlyWeather.map { HourlyWeather(from: $0 as! HourlyWeatherEntity) }
                        let dailyWeatherList = weeklyForecastEntity.dailyWeather.map { DailyWeather(from: $0 as! DailyWeatherEntity ) }
                        var newWeeklyWeather = WeeklyWeather(city: self.currentWeather.city, dailyWeatherList: dailyWeatherList, hourlyWeatherList: hourlyWeatherList)
                        
                        newWeeklyWeather.dailyWeatherList.sort { $0.dateTime < $1.dateTime }
                        newWeeklyWeather.hourlyWeatherList.sort { $0.dateTime < $1.dateTime }
                        self.weeklyWeather.accept(newWeeklyWeather)
                    },
                    onError: { (error) in
                        print(error)
                }).disposed(by: self.disposeBag)
        }
    }
    
}
