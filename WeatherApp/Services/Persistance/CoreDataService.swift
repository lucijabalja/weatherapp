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
    
    private let context = DataController.shared.persistentContainer.viewContext
    private var cityWeatherArray = [CityWeatherEntity]()
    
    func saveCurrentWeatherData(weatherResponse: CurrentWeatherResponse) {
        let currentTemperature = Utils.getFormattedTemperature(weatherResponse.weatherParameters.currentTemperature)
        
        if !CityWeatherEntity.firstOrCreate(weatherResponse.city, currentTemperature) {
            let cityWeatherEntity = CityWeatherEntity(context: context)
            let temperatureParams = TemperatureParametersEntity(context: context)
            
            cityWeatherEntity.city = weatherResponse.city
            cityWeatherEntity.icon = Utils.resolveWeatherIcon(weatherResponse.weatherDescription[0].conditionID)
            cityWeatherEntity.weatherDescription = weatherResponse.weatherDescription[0].weatherDescription
            
            temperatureParams.current = Utils.getFormattedTemperature(weatherResponse.weatherParameters.currentTemperature)
            temperatureParams.max = Utils.getFormattedTemperature(weatherResponse.weatherParameters.maxTemperature)
            temperatureParams.min = Utils.getFormattedTemperature(weatherResponse.weatherParameters.minTemperature)
            cityWeatherEntity.parameters = temperatureParams
        }
      

    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context! \(error)")
        }
    }
    
    func loadCurrentWeatherData() -> [CityWeatherEntity] {
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()
        do {
            cityWeatherArray = try context.fetch(request)
            //print(cityWeatherArray)
        } catch {
            print("Error fetching data from context \(error)")
        }
        return cityWeatherArray
    }
    
}
