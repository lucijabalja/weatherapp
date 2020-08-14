//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class Coordinator {
    
    private let navigationController: UINavigationController
    private let weatherApiService: WeatherApiService
    private let parsingService: ParsingService
    private let locationService: LocationService
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.weatherApiService = WeatherApiService()
        self.parsingService = ParsingService()
        self.locationService = LocationService()
    }
    
    func pushRootViewController() {
        let rootViewController = WeatherListViewController(coordinator: self)
        rootViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(rootViewController, animated: true)
    }
    
    func pushDetailViewController(_ selectedCity: CityWeather) {
        let weatherDetailViewController = WeatherDetailViewController(with: selectedCity, coordinator: self)
        weatherDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(weatherDetailViewController, animated: true)
    }
    
    func createWeatherViewModel() -> WeatherListViewModel {
        let viewModel = WeatherListViewModel(coordinator: self, apiService: weatherApiService, parsingService: parsingService)
        return viewModel
    }
    
    func createWeatherDetailViewModel(with cityWeather: CityWeather) -> WeatherDetailViewModel {
        let viewModel = WeatherDetailViewModel(coordinator: self, apiService: weatherApiService, parsingService: parsingService, locationService: locationService, cityWeather: cityWeather)
        return viewModel
    }
    
}
