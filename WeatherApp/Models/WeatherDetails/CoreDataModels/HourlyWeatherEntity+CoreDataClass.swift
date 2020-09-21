//
//  HourlyWeatherEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class HourlyWeatherEntity: NSManagedObject {
    
    class func createFrom(_ hourlyForecast: HourlyForecast, _ index: Int, context: NSManagedObjectContext) -> HourlyWeatherEntity {
        let hourlyWeatherEntity = HourlyWeatherEntity(context: context)
        
        hourlyWeatherEntity.id = Int64(index)
        hourlyWeatherEntity.time = Int64(hourlyForecast.dateTime)
        hourlyWeatherEntity.temperature = hourlyForecast.temperature
        hourlyWeatherEntity.conditionID = Int64(hourlyForecast.weather[0].conditionID)
        return hourlyWeatherEntity
    }
    
    func update(with hourlyForecast: HourlyForecast, index: Int) {
        self.conditionID = Int64(hourlyForecast.weather[0].conditionID)
        self.temperature = hourlyForecast.temperature
        self.time = Int64(hourlyForecast.dateTime)
    }
    
    class func load(withParent weeklyForecastEntity: WeeklyForecastEntity, index: Int, context: NSManagedObjectContext) -> HourlyWeatherEntity? {
        let request: NSFetchRequest<HourlyWeatherEntity> = HourlyWeatherEntity.fetchRequest()
        let hourlyPredicate = NSPredicate(format: "weeklyForecast = %@ AND id = %d", weeklyForecastEntity, index)
        request.predicate = hourlyPredicate
        
        var hourlyWeather: HourlyWeatherEntity?
        context.performAndWait {
            do {
                hourlyWeather = try context.fetch(request).first
            } catch {
                print("\(error)")
            }
        }
        return hourlyWeather
    }

}
