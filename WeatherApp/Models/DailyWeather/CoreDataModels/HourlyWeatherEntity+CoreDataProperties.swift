//
//  HourlyWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension HourlyWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourlyWeatherEntity> {
        return NSFetchRequest<HourlyWeatherEntity>(entityName: "HourlyWeatherEntity")
    }

    @NSManaged public var conditionID: Int64
    @NSManaged public var temperature: Double
    @NSManaged public var time: Int64
    @NSManaged public var weeklyForecast: WeeklyForecastEntity?

}
