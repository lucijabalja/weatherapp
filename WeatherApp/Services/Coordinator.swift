//
//  Coordinator.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class Coordinator {
    
    private let weatherService = WeatherApiService()
    private let parsingService = ParsingService()
    private let navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func getCityWeather(_ city: String, completion: @escaping (CityWeather?) -> Void) {
        weatherService.fetchCurrentWeather(for: city) { (data) in
            let parsedResponse = self.parsingService.parseCityWeather(data, city: city)
            completion(parsedResponse)
        }
    }
    
    func getDailyWeather(_ city: String, completion: @escaping (DailyWeather?) -> Void) {
        weatherService.fetchDailyWeather(for: city) { (data) in
            let parsedResponse = self.parsingService.parseDailyWeather(data, city: city)
            completion(parsedResponse)
        }
    }
    
    func pushDetailViewController(_ selectedCity: CityWeather) {
        let nextViewController = WeatherDetailViewController(with: selectedCity)
        nextViewController.modalPresentationStyle = .fullScreen
        navigationController.pushViewController(nextViewController, animated: true)
    }
    
}
