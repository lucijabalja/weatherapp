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
    
    typealias CurrentWeatherRequest = NSFetchRequest<CurrentWeatherEntity>
    
    class func createOrUpdate(_ currentForecast: CurrentForecast, context: NSManagedObjectContext) -> CurrentWeatherEntity? {
        let request: CurrentWeatherRequest = CurrentWeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city.name = %@", currentForecast.city)
        request.returnsObjectsAsFaults = false
        
        guard let currentWeather = load(with: request, context: context).first else {
            print("not found")
            return createFrom(currentForecast, context: context)
        }
        print("found")
        update(entity: currentWeather, with: currentForecast)
        return nil
    }
    
    class func createFrom(_ currentForecast: CurrentForecast, context: NSManagedObjectContext) -> CurrentWeatherEntity {
        let currentWeatherEntity = CurrentWeatherEntity(context: context)
        currentWeatherEntity.city = CityEntity.createFrom(currentForecast.city, currentForecast.id, context: context)
        currentWeatherEntity.parameters = TemperatureParametersEntity.createFrom(currentForecast.temperatureParameters, context: context)
        currentWeatherEntity.weatherDescription = WeatherDescriptionEntity.createFrom(currentForecast.weatherDescription[0], context: context)
        return currentWeatherEntity
    }
    
    class func update(entity: CurrentWeatherEntity, with currentForecast: CurrentForecast) {
        entity.city.update(with: currentForecast.city, currentForecast.id)
        entity.parameters.update(with: currentForecast.temperatureParameters)
        entity.weatherDescription.update(with: currentForecast.weatherDescription[0])
    }
    
    class func delete(_ entity: CurrentWeatherEntity, context: NSManagedObjectContext) {
        context.delete(entity)
    }
    
    class func load(with request: CurrentWeatherRequest, context: NSManagedObjectContext) -> [CurrentWeatherEntity] {
        do {
            let currentWeatherEntity = try context.fetch(request)
            return currentWeatherEntity
        } catch {
            print("\(error)")
            return []
        }
    }
    
}
