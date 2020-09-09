//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherListViewModel {
    
    private let coordinator: Coordinator
    private let dataRepository: DataRepository
    private let disposeBag = DisposeBag()
    let currentWeatherList: BehaviorRelay<[CurrentWeather]> = BehaviorRelay(value: [])
    
    init(coordinator: Coordinator, dataRepository: DataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        
        getCurrentWeather()
    }
    
    func getCurrentWeather() {
        dataRepository.getCurrentWeatherData().subscribe(
            onNext: { [weak self] (currentWeatherEntities) in
                guard let self = self else { return }
                
                let curentWeatherList = currentWeatherEntities.map { CurrentWeather(from: $0 )}
                self.currentWeatherList.accept(curentWeatherList)
        }).disposed(by: disposeBag)
    }
    
    func getCurrentWeather(for city: String) {
        dataRepository.getCurrentCityWeather(for: city).subscribe(
            onNext: { [weak self] (currentWeatherEntities) in
                guard let self = self else { return }
                
                let curentWeatherList = currentWeatherEntities.map { CurrentWeather(from: $0 )}
                self.currentWeatherList.accept(curentWeatherList)
        }).disposed(by: disposeBag)
    }
    
    func pushToDetailView(with selectedCity: CurrentWeather) {
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
