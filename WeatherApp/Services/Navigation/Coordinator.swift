//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class Coordinator {
    
    private var appDependencies: AppDependencies
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.appDependencies = AppDependencies()
    }
    
    func setRootViewController() {
        let viewModel = WeatherListViewModel(coordinator: self,
                                             dataRepository: appDependencies.dataRepository,
                                             locationService: appDependencies.locationService)
        let rootViewController = WeatherListViewController(with: viewModel)
        rootViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(rootViewController, animated: true)
    }
    
    func presentDetailViewController(with selectedCity: CurrentWeather) {
        let viewModel = WeatherDetailViewModel(appDependencies: appDependencies, currentWeather: selectedCity, coordinator: self)
        let weatherDetailViewController = WeatherDetailViewController(with: viewModel)
        weatherDetailViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(weatherDetailViewController, animated: true)
    }
    
    func presentAlert(with error: ErrorHandler) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: error.message.0, message: error.message.1, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            if !(self.navigationController?.visibleViewController?.isKind(of: UIAlertController.self))! {
                self.navigationController?.viewControllers.first?.present(alert, animated: true)
            }
        }
    }
}
