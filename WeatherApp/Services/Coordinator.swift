//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class Coordinator {
    
    private let appDependencies: AppDependencies
    private let navigationController = UINavigationController()
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
        self.appDependencies = AppDependencies()
    }
    
    func setRootViewController() {
        let viewModel = WeatherListViewModel(coordinator: self, dataRepository: appDependencies.dataRepository)
        let rootViewController = WeatherListViewController(with: viewModel)
        rootViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(rootViewController, animated: true)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func pushDetailViewController(with selectedCity: CurrentWeather) {
        let viewModel = WeatherDetailViewModel(appDependencies: appDependencies, currentWeather: selectedCity, coordinator: self)
        let weatherDetailViewController = WeatherDetailViewController(with: viewModel)
        weatherDetailViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(weatherDetailViewController, animated: true)
    }
    
}
