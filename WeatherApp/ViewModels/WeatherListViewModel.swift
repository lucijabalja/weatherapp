//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class WeatherListViewModel {
    
    private let coordinator: Coordinator
    private let dataRepository: DataRepository
    private let cities = City.allCases
    var currentWeatherList = [CurrentWeather]()
    
    init(coordinator: Coordinator, dataRepository: DataRepository) {
        self.coordinator = coordinator
        self.dataRepository = dataRepository
    }
    
    func getCurrentWeather(completionHandler: @escaping (Result<Bool,Error>) -> Void) {
        dataRepository.getCurrentWeatherData() { [weak self] (result) in
            switch result {
            case .success(let currentForecastEntity):
                self?.saveCurrentWeather(from: currentForecastEntity)
                completionHandler(.success(true))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func pushToDetailView(at index: Int) {
        guard let selectedCity = currentWeatherList[safeIndex: index] else { return }
        
        coordinator.pushDetailViewController(with: selectedCity)
    }
    
    func saveCurrentWeather(from currentForecastEntity: CurrentForecastEntity) {
        for currentWeatherEntity in currentForecastEntity.currentWeather {
            let currentWeather = currentWeatherEntity as! CurrentWeatherEntity
            let condition = convertToCondition(currentWeather.weatherDescription)
            let temperature = convertToTemperature(currentWeather.parameters)
            
            let current = CurrentWeather(city: currentWeather.city, parameters: temperature, condition: condition)
            self.currentWeatherList.append(current)
        }
    }
    
    func convertToCondition(_ weatherDescription: WeatherDescriptionEntity) -> Condition {
        Condition(icon:  Utils.resolveWeatherIcon(Int(weatherDescription.conditionID)),
                  conditionDescription: weatherDescription.conditionDescription)
    }
    
    func convertToTemperature(_ temperatureParameters: TemperatureParametersEntity) -> CurrentTemperature {
        return CurrentTemperature(now: Utils.getFormattedTemperature(temperatureParameters.current),
                                  min: Utils.getFormattedTemperature(temperatureParameters.min),
                                  max: Utils.getFormattedTemperature(temperatureParameters.max))
    }
    
}
