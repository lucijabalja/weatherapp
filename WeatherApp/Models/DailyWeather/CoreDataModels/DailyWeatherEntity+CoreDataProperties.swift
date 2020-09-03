//
//  DailyWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 27/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherEntity> {
        return NSFetchRequest<DailyWeatherEntity>(entityName: "DailyWeatherEntity")
    }

    @NSManaged public var conditionID: Int64
    @NSManaged public var dateTime: Int64
    @NSManaged public var weeklyForecast: WeeklyForecastEntity
    @NSManaged public var temperature: TemperatureEntity
    
}
