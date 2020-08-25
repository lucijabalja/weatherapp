//
//  DailyWeatherEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class DailyWeatherEntity: NSManagedObject {
    
    class func createfrom(_ dateTime: Int, _ conditionID: Int, context: NSManagedObjectContext) -> DailyWeatherEntity {
        let date = Date(timeIntervalSince1970: TimeInterval(dateTime))
        let dailyWeather = DailyWeatherEntity(context: context)
        
        dailyWeather.weekDay = Utils.getWeekDay(with: date)
        dailyWeather.icon = Utils.resolveWeatherIcon(conditionID)
        
        return dailyWeather
    }
    
    class func loadDailyWeather(with weekDay: String,_ dailyForecastEntity: DailyForecastEntity, context: NSManagedObjectContext) -> DailyWeatherEntity? {         
         let request: NSFetchRequest<DailyWeatherEntity> = DailyWeatherEntity.fetchRequest()
         let dailyForecastPredicate = NSPredicate(format: "weekDay = %@ AND dailyForecast = %@", weekDay, dailyForecastEntity)
         request.predicate = dailyForecastPredicate
         
         do {
             let dailyWeather = try context.fetch(request)
             if let first = dailyWeather.first {
                 return first
             }
         } catch {
             print("\(error)")
         }
         return nil
     }
    
    func update(with dailyForecast: DailyForecast) {
        self.temperature.max = dailyForecast.temperature.max
        self.temperature.min = dailyForecast.temperature.min
        self.icon = Utils.resolveWeatherIcon(dailyForecast.weather[0].conditionID)
    }
}
