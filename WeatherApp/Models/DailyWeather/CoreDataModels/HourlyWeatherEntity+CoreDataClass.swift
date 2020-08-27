//
//  HourlyWeatherEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData

public class HourlyWeatherEntity: NSManagedObject {
    
    class func createFrom(_ hourlyForecast: HourlyForecast, _ index: Int, context: NSManagedObjectContext) -> HourlyWeatherEntity {
        let hourlyWeatherEntity = HourlyWeatherEntity(context: context)
        hourlyWeatherEntity.time = Int64(hourlyForecast.dateTime)
        hourlyWeatherEntity.temperature = hourlyForecast.temperature
        hourlyWeatherEntity.conditionID = Int64(hourlyForecast.weather[0].conditionID)
        
        return hourlyWeatherEntity
    }
    
    func update(with hourlyForecast: HourlyForecast, index: Int) {
        self.id = Int64(index)
        self.conditionID = Int64(hourlyForecast.weather[0].conditionID)
        self.temperature = hourlyForecast.temperature
        self.time = Int64(hourlyForecast.dateTime)
    }
    
    class func loadHourlyWeather(withParent weeklyForecastEntity: WeeklyForecastEntity, index: Int, context: NSManagedObjectContext) -> HourlyWeatherEntity? {
        let request: NSFetchRequest<HourlyWeatherEntity> = HourlyWeatherEntity.fetchRequest()
        let hourlyPredicate = NSPredicate(format: "weeklyForecast = %@ AND id = %d", weeklyForecastEntity, index)
        request.predicate = hourlyPredicate
        
        do {
            let hourlyWeather = try context.fetch(request)
            return hourlyWeather.first
        } catch {
            print("\(error)")
            return nil
        }
    }
    
}
