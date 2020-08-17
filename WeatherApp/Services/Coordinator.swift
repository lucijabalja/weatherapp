//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class Coordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let appDependencies: AppDependencies
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.appDependencies = AppDependencies()
    }
    
    func setRootViewController() {
        let viewModel = WeatherListViewModel(apiService: appDependencies.weatherApiService, coordinator: self)
        let rootViewController = WeatherListViewController(with: viewModel)
        rootViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(rootViewController, animated: true)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func pushDetailViewController(with selectedCity: CityWeather) {
        let viewModel = WeatherDetailViewModel(appDependencies: appDependencies, cityWeather: selectedCity, coordinator: self)
        let weatherDetailViewController = WeatherDetailViewController(with: viewModel)
        weatherDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(weatherDetailViewController, animated: true)
    }
    
}
