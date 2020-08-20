//
//  CityWeatherEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 19/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import CoreData
import UIKit

public class CityWeatherEntity: NSManagedObject {
    
    class func createFrom(weatherResponse: CurrentWeather) {
        
        guard let cityWeatherEntity = loadCurrentWeather(weatherResponse.city) else {
            creteNewEntity(with: weatherResponse)
            return
        }
        cityWeatherEntity.parameters?.current = Utils.getFormattedTemperature(weatherResponse.weatherParameters.currentTemperature)
        cityWeatherEntity.parameters?.max = Utils.getFormattedTemperature(weatherResponse.weatherParameters.maxTemperature)
        cityWeatherEntity.parameters?.min = Utils.getFormattedTemperature(weatherResponse.weatherParameters.minTemperature)
        
        DataController.shared.saveContext()
    }
    
    class func creteNewEntity(with weatherResponse: CurrentWeather) {
        let context = DataController.shared.persistentContainer.viewContext
        let cityWeatherEntity = CityWeatherEntity(context: context)
        let temperatureParams = TemperatureParametersEntity(context: context)
        
        cityWeatherEntity.city = weatherResponse.city
        cityWeatherEntity.icon = Utils.resolveWeatherIcon(weatherResponse.weatherDescription[0].conditionID)
        cityWeatherEntity.weatherDescription = weatherResponse.weatherDescription[0].weatherDescription
        
        temperatureParams.current = Utils.getFormattedTemperature(weatherResponse.weatherParameters.currentTemperature)
        temperatureParams.max = Utils.getFormattedTemperature(weatherResponse.weatherParameters.maxTemperature)
        temperatureParams.min = Utils.getFormattedTemperature(weatherResponse.weatherParameters.minTemperature)
        cityWeatherEntity.parameters = temperatureParams
        
        DataController.shared.saveContext()

    }

    class func loadCurrentWeather(_ city: String) -> CityWeatherEntity? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()
        let cityPredicate = NSPredicate(format: "city == %@", city)
        request.predicate = cityPredicate
        
        do {
            let cityWeatherEntity = try context.fetch(request)
            if let first = cityWeatherEntity.first {
                return first
            }
        } catch {
            print("\(error)")
        }
        return nil
    }
    
}
