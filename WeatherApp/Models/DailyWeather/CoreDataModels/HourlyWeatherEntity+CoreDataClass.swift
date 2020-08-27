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
    
    class func createFrom(_ hourlyForecast: HourlyForecast, context: NSManagedObjectContext) -> HourlyWeatherEntity {
        let hourlyWeatherEntity = HourlyWeatherEntity(context: context)
        hourlyWeatherEntity.time = Int64(hourlyForecast.dateTime)
        hourlyWeatherEntity.temperature = hourlyForecast.temperature
        hourlyWeatherEntity.conditionID = Int64(hourlyForecast.weather[0].conditionID)
        
        return hourlyWeatherEntity
    }

}
