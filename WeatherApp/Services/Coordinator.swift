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
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    
    func pushDetailViewController(_ selectedCity: CityWeather) {
        let nextViewController = WeatherDetailViewController(with: selectedCity)
        nextViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(nextViewController, animated: true)
    }
    
}
