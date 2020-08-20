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
    
    class func createFrom(_ currentWeather: CurrentWeather) {
        
        guard let cityWeatherEntity = loadCurrentWeather(currentWeather.city) else {
            creteNewEntity(with: currentWeather)
            return
        }
        cityWeatherEntity.parameters?.current = Utils.getFormattedTemperature(currentWeather.weatherParameters.currentTemperature)
        cityWeatherEntity.parameters?.max = Utils.getFormattedTemperature(currentWeather.weatherParameters.maxTemperature)
        cityWeatherEntity.parameters?.min = Utils.getFormattedTemperature(currentWeather.weatherParameters.minTemperature)
        
        DataController.shared.saveContext()
    }
    
    class func creteNewEntity(with currentWeather: CurrentWeather) {
        let context = DataController.shared.persistentContainer.viewContext
        let cityWeatherEntity = CityWeatherEntity(context: context)
        let temperatureParams = TemperatureParametersEntity(context: context)
        
        cityWeatherEntity.city = currentWeather.city
        cityWeatherEntity.icon = Utils.resolveWeatherIcon(currentWeather.weatherDescription[0].conditionID)
        cityWeatherEntity.weatherDescription = currentWeather.weatherDescription[0].weatherDescription
        
        temperatureParams.current = Utils.getFormattedTemperature(currentWeather.weatherParameters.currentTemperature)
        temperatureParams.max = Utils.getFormattedTemperature(currentWeather.weatherParameters.maxTemperature)
        temperatureParams.min = Utils.getFormattedTemperature(currentWeather.weatherParameters.minTemperature)
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
