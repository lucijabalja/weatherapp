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
    
    class func createFrom(_ dailyForecast: DailyForecast, context: NSManagedObjectContext) -> DailyWeatherEntity {
        let dailyWeatherEntity = DailyWeatherEntity(context: context)
        dailyWeatherEntity.conditionID = Int64(dailyForecast.weather[0].conditionID)
        dailyWeatherEntity.dateTime = Int64(dailyForecast.dateTime)
        dailyWeatherEntity.temperature = TemperatureEntity.createFrom(temperature: dailyForecast.temperature, context: context)
        
        return dailyWeatherEntity
    }
    
}
