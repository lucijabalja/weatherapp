//
//  DailyWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWeatherEntity> {
        return NSFetchRequest<DailyWeatherEntity>(entityName: "DailyWeatherEntity")
    }

    @NSManaged public var icon: String
    @NSManaged public var weekDay: String
    @NSManaged public var dailyForecast: DailyForecastEntity
    @NSManaged public var temperature: TemperatureEntity

}
