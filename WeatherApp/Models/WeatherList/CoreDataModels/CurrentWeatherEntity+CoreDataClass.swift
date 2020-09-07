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

public class CurrentWeatherEntity: NSManagedObject {
    
    class func createFrom(_ currentForecast: CurrentForecast, context: NSManagedObjectContext) {
        if let currentWeather = CurrentWeatherEntity.firstOrCreate(withCity: currentForecast.city, context: context) {
            currentWeather.city = CityEntity.createFrom(currentForecast.city, currentForecast.id, context: context)
            currentWeather.parameters = TemperatureParametersEntity.createFrom(currentForecast.temperatureParameters, context: context)
            currentWeather.weatherDescription = WeatherDescriptionEntity.createFrom(currentForecast.weatherDescription[0], context: context)
        }
    }
    
    class func firstOrCreate(withCity city: String, context: NSManagedObjectContext) -> CurrentWeatherEntity? {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city = %@", city)
        request.returnsObjectsAsFaults = false
        
        do {
            let currentWeatherEntity = try context.fetch(request)
            if let currentWeather = currentWeatherEntity.first {
                return currentWeather
            } else {
                let newCurrentWeatherEntity = CurrentWeatherEntity(context: context)
                return newCurrentWeatherEntity
            }
        } catch {
            return nil
        }
    }

    class func loadCurrentWeatherData(context: NSManagedObjectContext) -> [CurrentWeatherEntity] {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        
        do {
            let cityWeatherEntity = try context.fetch(request)
            return cityWeatherEntity
        } catch {
            print("\(error)")
            return []
        }
    }
    
}
