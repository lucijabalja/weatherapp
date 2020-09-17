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
        guard let currentWeather = CurrentWeatherEntity.firstOrCreate(withCity: currentForecast.city, context: context)
            else {
                let currentWeatherEntity = CurrentWeatherEntity(context: context)
                currentWeatherEntity.city = CityEntity.createFrom(currentForecast.city, currentForecast.id, context: context)
                currentWeatherEntity.parameters = TemperatureParametersEntity.createFrom(currentForecast.temperatureParameters, context: context)
                currentWeatherEntity.weatherDescription = WeatherDescriptionEntity.createFrom(currentForecast.weatherDescription[0], context: context)
                return
        }
        
        currentWeather.city.update(with: currentForecast.city, currentForecast.id)
        currentWeather.parameters.update(with: currentForecast.temperatureParameters)
        currentWeather.weatherDescription.update(with: currentForecast.weatherDescription[0])
    }
    
    class func firstOrCreate(withCity city: String, context: NSManagedObjectContext) -> CurrentWeatherEntity? {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city.name = %@", city)
        request.returnsObjectsAsFaults = false
        
        do {
            let currentWeatherEntity = try context.fetch(request)
            if let currentWeather = currentWeatherEntity.first {
                return currentWeather
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    class func delete(_ entity: CurrentWeatherEntity, context: NSManagedObjectContext) {
        context.delete(entity)
    }
    
    class func loadCurrentWeatherData(with request: NSFetchRequest<CurrentWeatherEntity>, context: NSManagedObjectContext) -> [CurrentWeatherEntity] {
        
        do {
            let currentWeatherEntity = try context.fetch(request)
            return currentWeatherEntity
        } catch {
            print("\(error)")
            return []
        }
    }
    
}
