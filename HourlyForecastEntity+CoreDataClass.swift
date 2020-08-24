//
//  HourlyForecastEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class HourlyForecastEntity: NSManagedObject {
    
    class func createFrom(_ hourlyWeatherResponse: HourlyWeatherResponse, _ city: String) {
        let context = DataController.shared.persistentContainer.viewContext
        guard let hourlyForecastEntity = loadHourlyForecast(for: city) else {
            let newHourlyForecastEntity = HourlyForecastEntity(context: context)
            newHourlyForecastEntity.city = city
            createNewEntity(hourlyWeatherResponse, for: newHourlyForecastEntity)
            return
        }
        
        let hourlyWeatherEntities = hourlyForecastEntity.hourlyWeather
        hourlyForecastEntity.removeFromHourlyWeather(hourlyWeatherEntities)
        createNewEntity(hourlyWeatherResponse, for: hourlyForecastEntity)
        
    }
    
    class func createNewEntity(_ hourlyWeatherResponse: HourlyWeatherResponse, for hourlyForecastEntity: HourlyForecastEntity) {
        for hourlyForecast in hourlyWeatherResponse.hourlyForecast {
            let hourlyWeatherEntity = HourlyWeatherEntity.createFrom(hourlyForecast)
            hourlyWeatherEntity.hourlyForecast = hourlyForecastEntity
            hourlyForecastEntity.addToHourlyWeather(hourlyWeatherEntity)
        }
        
        DataController.shared.saveContext()
    }
    
    class func loadHourlyForecast(for city: String) -> HourlyForecastEntity? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<HourlyForecastEntity> = HourlyForecastEntity.fetchRequest()
        let cityPredicate = NSPredicate(format: "city = %@", city)
        request.predicate = cityPredicate

        do {
            let hourlyForecast = try context.fetch(request)
            if let first = hourlyForecast.first {
                return first
            }
        } catch {
            print("\(error)")
        }
        return nil
    }
    
}
