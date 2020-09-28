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
    
    private let locationService: LocationService
    private let coordinator: Coordinator
    private let dataRepository: WeatherListDataRepository
    private let disposeBag = DisposeBag()
    let refreshData = PublishSubject<Void>()
    let modelSelected = PublishSubject<CurrentWeather>()
    let showLoading = BehaviorRelay<Bool>(value: true)
    let searchText = BehaviorRelay<String>(value: "")
    private var currentLocation: BehaviorRelay<Coordinates>
    
    var currentWeatherData: Observable<[CurrentWeather]> {
        return refreshData
            .asObservable()
            .flatMap{ [weak self] (_) -> Observable<Result<[CurrentWeatherEntity], PersistanceError>> in
                guard let self = self else { return Observable.just(.failure(.loadingError)) }
                
                self.showLoading.accept(true)
                return self.dataRepository.getCurrentWeatherData()
            }
            .flatMap { [weak self] (result) -> Observable<[CurrentWeather]> in
                guard let self = self else { return Observable.just([]) }
                
                switch result {
                case .success(let currentWeatherList):
                    let currentWeatherItems = currentWeatherList
                        .map { CurrentWeather(from: $0) }
                    self.showLoading.accept(false)
                    
                    return Observable.just(currentWeatherItems)
                    
                case .failure(let error):
                    self.showLoading.accept(false)
                    self.coordinator.presentAlert(with: error)
                    
                    return Observable.just([])
                }
            }
    }
    
    init(coordinator: Coordinator, dataRepository: WeatherListDataRepository, locationService: LocationService) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
        self.locationService = locationService
        self.currentLocation = BehaviorRelay<Coordinates>(value: Coordinates(latitude: 0, longitude: 0))
        
        bindCurrentLocationWeather()
        bindModelSelected()
        bindSearchCity()
        getCurrentLocationWeather()
        refreshData.onNext(())
    }
    
    func bindCurrentLocationWeather() {
        locationService
            .location
            .bind(to: currentLocation)
            .disposed(by: disposeBag)
    }
    
    func getCurrentLocationWeather() {
        currentLocation
            .asObservable()
            .skip(1)
            .flatMap { coordinates -> Observable<Result<String, NetworkError>> in
                return self.locationService.getLocationName(with: coordinates)
            }
            .flatMap { (result) -> Observable<Result<CurrentForecast, NetworkError>> in
                switch result {
                case .success(let location):
                    return self.dataRepository.getCurrentWeatherData(for: location)
                case .failure(let error):
                    return .just(.failure(error))
                }
            }
            .subscribe(onNext: { result in
                if case let .failure(error) = result {
                    self.coordinator.presentAlert(with: error)
                }
            }).disposed(by: disposeBag)

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
            .skip(1)
            .flatMap { city -> Observable<Result<CurrentForecast, NetworkError>> in
                if city.isEmpty {
                    self.coordinator.presentAlert(with: SearchError.emptyInput)
                }
                return self.dataRepository.getCurrentWeatherData(for: city)
            }
            .subscribe(onNext: { result in
                if case .failure(_) = result {
                    self.coordinator.presentAlert(with: SearchError.termNotFound)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func removeCurrentWeather(with city: String) {
        dataRepository.removeCurrentWeather(for: city)
    }
    
    func reorderCurrentWeatherList(_ sourceIndex: Int,_ destinationIndex: Int) {
        dataRepository
            .getCurrentWeatherData()
            .take(1)
            .subscribe(onNext: { result in
                if case let .success(data) = result {
                    guard let currentWeather = data[safeIndex: sourceIndex] else {
                        return
                    }
                    self.dataRepository.reorderCurrentWeatherList(currentWeather, sourceIndex, destinationIndex)
                }
            }).disposed(by: disposeBag)
    }
    
    func pushToDetailView(with selectedCity: CurrentWeather) {
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
}
