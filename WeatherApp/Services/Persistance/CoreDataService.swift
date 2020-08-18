//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var cityWeatherArray = [CityWeatherEntity]()
    
    func saveData(cityWeather: CityWeather) {
        let cityWeatherEntity = CityWeatherEntity(context: context)
        let weatherParameters = WeatherParametersEntity(context: context)
        
        cityWeatherEntity.city = cityWeather.city
        cityWeatherEntity.icon = cityWeather.icon
        cityWeatherEntity.weatherDescription = cityWeather.description
        
        weatherParameters.currentTemperature = cityWeather.parameters.currentTemperature
        weatherParameters.maxTemperature = cityWeather.parameters.maxTemperature
        weatherParameters.minTemperature = cityWeather.parameters.minTemperature
        cityWeatherEntity.parameters = weatherParameters
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context! \(error)")
        }
    }
    
    func loadData() {
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()
        do {
            cityWeatherArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    private func convertData() {
        
    }
    
}
