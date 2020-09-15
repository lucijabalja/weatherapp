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
    let refreshData = PublishSubject<Void>()
    let modelSelected = PublishSubject<CurrentWeather>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    
    var currentWeatherList: Observable<[CurrentWeather]> {
        return refreshData
            .asObservable()
            .flatMap{ _ -> Observable<Result<CurrentForecastEntity, PersistanceError>> in
                self.showLoading.accept(true)
                return self.dataRepository.getCurrentWeatherData()
        }
        .flatMap { (result) -> Observable<[CurrentWeather]> in
            switch result {
            case .success(let currentForecastEntity):
                let curentWeatherItems = currentForecastEntity.currentWeather
                    .map { CurrentWeather(from: $0 as! CurrentWeatherEntity )}
                self.showLoading.accept(false)
                
                return Observable.just(curentWeatherItems)
                
            case .failure(let error):
                self.showLoading.accept(false)
                
                return Observable.error(error)
            }
        }
    }
    
    init(coordinator: Coordinator, dataRepository: DataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        
        bindModelSelected()
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
    
    func pushToDetailView(with selectedCity: CurrentWeather) {
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
