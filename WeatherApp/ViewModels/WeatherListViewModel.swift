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
    private let dataRepository: MainWeatherDataRepository
    private let disposeBag = DisposeBag()
    let refreshData = PublishSubject<Void>()
    let modelSelected = PublishSubject<CurrentWeather>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    let searchText = BehaviorRelay<String>(value: "")
    var currentWeatherList: [CurrentWeather] = []
    
    var currentWeatherData: Observable<[SectionOfCurrentWeather]> {
        return refreshData
            .asObservable()
            .flatMap{ _ -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> in
                self.showLoading.accept(true)
                return self.dataRepository.getCurrentWeatherData()
        }
        .flatMap { (result) -> Observable<[SectionOfCurrentWeather]> in
            switch result {
            case .success(let currentWeatherList):
                let currentWeatherItems = currentWeatherList.map { CurrentWeather(from: $0) }
                
                self.currentWeatherList.append(contentsOf: currentWeatherItems)
                let sectionOfCurrentWeatherList = currentWeatherItems.map( {SectionOfCurrentWeather(items: [$0]) } )

                self.showLoading.accept(false)
                
                return Observable.just(sectionOfCurrentWeatherList)
                
            case .failure(let error):
                self.showLoading.accept(false)
                
                self.coordinator.presentAlert(with: error)
                return Observable.just([])
            }
        }
    }
    
    init(coordinator: Coordinator, dataRepository: MainWeatherDataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        
        bindModelSelected()
        bindSearchCity()
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
        searchText.subscribe(onNext: { [weak self] (city) in
            guard let self = self else { return }
            
            self.dataRepository.getCurrentCityWeather(for: city)
            self.refreshData.onNext(())
        }).disposed(by: disposeBag)
    }
    
    func pushToDetailView(with selectedCity: CurrentWeather) {
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
