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
    private let dataRepository: WeatherListDataRepository
    private let disposeBag = DisposeBag()
    let refreshData = PublishSubject<Void>()
    let modelSelected = PublishSubject<CurrentWeather>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    let searchText = BehaviorRelay<String>(value: "")
    
    var currentWeatherData: Observable<[CurrentWeather]> {
        return refreshData
            .asObservable()
            .flatMap{ [weak self] (_) -> Observable<[CurrentWeatherEntity]> in
                guard let self = self else { return Observable.just([]) }
                
                self.showLoading.accept(true)
                return self.dataRepository.getCurrentWeatherData()
            }
            .flatMap { [weak self] (currentWeatherList) -> Observable<[CurrentWeather]> in
                guard let self = self else { return Observable.just([]) }
                
                let currentWeatherItems = currentWeatherList.map { CurrentWeather(from: $0) }
                self.showLoading.accept(false)
                
                return Observable.just(currentWeatherItems)
            }
    }
    
    init(coordinator: Coordinator, dataRepository: WeatherListDataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        
        bindModelSelected()
        bindSearchCity()
        refreshData.onNext(())
    }
    
    func bindModelSelected() {
        modelSelected
            .asObserver()
            .subscribe(onNext: { [weak self] (currentWeather) in
                guard let self = self else { return }
                
                self.pushToDetailView(with: currentWeather)
            })
            .disposed(by: disposeBag)
    }
    
    func bindSearchCity() {
        searchText
            .subscribe(onNext: { [weak self] (city) in
                guard let self = self else { return }
                
                self.dataRepository.getCurrentWeatherData(for: city)
                self.refreshData.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func removeCurrentWeather(with city: String) {
        dataRepository.removeCurrentWeather(for: city)
    }
    
    func pushToDetailView(with selectedCity: CurrentWeather) {
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
