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
    
    class func createFrom(_ currentForecast: CurrentForecast, context: NSManagedObjectContext) -> CurrentWeatherEntity {
        let currentWeatherEntity = CurrentWeatherEntity(context: context)
        currentWeatherEntity.city = currentForecast.city
        
        return currentWeatherEntity
    }
    
    
    class func loadCurrentWeather(forCity city: String, context: NSManagedObjectContext) -> CurrentWeatherEntity? {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        let cityPredicate = NSPredicate(format: "city == %@", city)
        request.predicate = cityPredicate
        
        do {
            let cityWeatherEntity = try context.fetch(request)
            return cityWeatherEntity.first
        } catch {
            print("\(error)")
            return nil
        }
    }
    
}
