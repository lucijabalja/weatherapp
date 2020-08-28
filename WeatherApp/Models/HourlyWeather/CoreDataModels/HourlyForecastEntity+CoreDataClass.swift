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
    
    class func createFrom(_ hourlyWeatherResponse: HourlyWeatherResponse,_ city: String, context: NSManagedObjectContext) {
        guard let hourlyForecastEntity = loadHourlyForecast(for: city, context: context) else {
            let newHourlyForecastEntity = HourlyForecastEntity(context: context)
            newHourlyForecastEntity.city = city
            createNewEntity(hourlyWeatherResponse, for: newHourlyForecastEntity, context: context)
            return
        }
        
        let hourlyWeatherEntities = hourlyForecastEntity.hourlyWeather
        hourlyForecastEntity.removeFromHourlyWeather(hourlyWeatherEntities)
        createNewEntity(hourlyWeatherResponse, for: hourlyForecastEntity, context: context)
    }
    
    class func createNewEntity(_ hourlyWeatherResponse: HourlyWeatherResponse, for hourlyForecastEntity: HourlyForecastEntity, context: NSManagedObjectContext) {
        for hourlyForecast in hourlyWeatherResponse.hourlyForecast {
            let hourlyWeatherEntity = HourlyWeatherEntity.createFrom(hourlyForecast, context: context)
            hourlyWeatherEntity.hourlyForecast = hourlyForecastEntity
            hourlyForecastEntity.addToHourlyWeather(hourlyWeatherEntity)
        }
    }
    
    class func loadHourlyForecast(for city: String, context: NSManagedObjectContext) -> HourlyForecastEntity? {
        let request: NSFetchRequest<HourlyForecastEntity> = HourlyForecastEntity.fetchRequest()
        let cityPredicate = NSPredicate(format: "city = %@", city)
        request.predicate = cityPredicate

        do {
            let hourlyForecast = try context.fetch(request)
            return hourlyForecast.first
        } catch {
            print("\(error)")
            return nil
        }
    }
    
}
