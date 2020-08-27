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
    
    class func createFrom(_ dailyForecast: DailyForecast, _ index: Int, context: NSManagedObjectContext) -> DailyWeatherEntity {
        let dailyWeatherEntity = DailyWeatherEntity(context: context)
        dailyWeatherEntity.id = Int64(index)
        dailyWeatherEntity.conditionID = Int64(dailyForecast.weather[0].conditionID)
        dailyWeatherEntity.dateTime = Int64(dailyForecast.dateTime)
        dailyWeatherEntity.temperature = TemperatureEntity.createFrom(temperature: dailyForecast.temperature, context: context)
        
        return dailyWeatherEntity
    }
    
    func update(with dailyForecast: DailyForecast, index: Int) {
        self.id = Int64(index)
        self.conditionID = Int64(dailyForecast.weather[0].conditionID)
        self.dateTime = Int64(dailyForecast.dateTime)
        self.temperature.update(with: dailyForecast.temperature)
    }
    
    class func loadDailyWeather(withParent weeklyForecastEntity: WeeklyForecastEntity, index: Int, context: NSManagedObjectContext) -> DailyWeatherEntity? {
        let request: NSFetchRequest<DailyWeatherEntity> = DailyWeatherEntity.fetchRequest()
        let dailyPredicate = NSPredicate(format: "weeklyForecast = %@ AND id = %d", weeklyForecastEntity, index)
        request.predicate = dailyPredicate
        
        do {
            let dailyWeather = try context.fetch(request)
            return dailyWeather.first
        } catch {
            print("\(error)")
            return nil
        }
    }
}
