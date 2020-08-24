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
    
    class func createFrom(_ currentForecast: CurrentForecast) -> CurrentWeatherEntity {
        let context = DataController.shared.persistentContainer.viewContext
        let currentWeatherEntity = CurrentWeatherEntity(context: context)
        currentWeatherEntity.city = currentForecast.city

        return currentWeatherEntity
    }
    
    
    class func loadCurrentWeather(forCity city: String) -> CurrentWeatherEntity? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        let cityPredicate = NSPredicate(format: "city == %@", city)
        request.predicate = cityPredicate
        
        do {
            let cityWeatherEntity = try context.fetch(request)
            guard let first = cityWeatherEntity.first else { return nil }
            
            return first
        } catch {
            print("\(error)")
        }
        return nil
    }
    
}
