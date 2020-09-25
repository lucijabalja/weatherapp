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
import CoreLocation

class WeatherListViewModel {
    
    private let locationService: LocationService
    private let coordinator: Coordinator
    private let dataRepository: MainWeatherDataRepository
    private let disposeBag = DisposeBag()
    let refreshData = PublishSubject<Void>()
    let modelSelected = PublishSubject<CurrentWeather>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    let searchText = BehaviorRelay<String>(value: "")
    let currentLocation: BehaviorRelay<String>
    
    var currentWeatherData: Observable<[SectionOfCurrentWeather]> {
        return refreshData
            .asObservable()
            .flatMap{ [weak self] (_) -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> in
                guard let self = self else { return Observable.just(.failure(.loadingError)) }
                
                self.showLoading.accept(true)
                return self.dataRepository.getCurrentWeatherData()
        }
        .flatMap { [weak self] (result) -> Observable<[SectionOfCurrentWeather]> in
            guard let self = self else { return Observable.just([]) }
            
            switch result {
            case .success(let currentWeatherList):
                let currentWeatherItems = currentWeatherList
                    .map { CurrentWeather(from: $0) }
                    .map{ SectionOfCurrentWeather(items: [$0]) }
                self.showLoading.accept(false)
                
                return Observable.just(currentWeatherItems)
                
            case .failure(let error):
                self.showLoading.accept(false)
                self.coordinator.presentAlert(with: error)
                
                return Observable.just([])
            }
        }
    }
    
    init(coordinator: Coordinator, dataRepository: MainWeatherDataRepository, locationService: LocationService) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.locationService = locationService
        self.currentLocation = BehaviorRelay(value: "")
        
        bindCurrentLocation()
        bindModelSelected()
        bindSearchCity()
        getCurrentLocationWeather()
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
                
                self.dataRepository.getCurrentCityWeather(for: city)
                self.refreshData.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func pushToDetailView(with selectedCity: CurrentWeather) {
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
    func bindCurrentLocation() {
       locationService
            .currentCoordinates
            .map({ (coordinates) in
                return self.locationService.getLocationName(coordinates: coordinates)
            })
            .bind(to: currentLocation)
            .disposed(by: disposeBag)
    
    }
    
    func getCurrentLocationWeather() {
        currentLocation
            .asObservable()
            .map { (location) in
                self.dataRepository.getCurrentCityWeather(for: location)
            }
           
    }
    
}
