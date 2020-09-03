//
//  HourlyForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension HourlyForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HourlyForecastEntity> {
        return NSFetchRequest<HourlyForecastEntity>(entityName: "HourlyForecastEntity")
    }

    @NSManaged public var city: String
    @NSManaged public var hourlyWeather: NSSet

}

// MARK: Generated accessors for hourlyWeather
extension HourlyForecastEntity {

    @objc(addHourlyWeatherObject:)
    @NSManaged public func addToHourlyWeather(_ value: HourlyWeatherEntity)

    @objc(removeHourlyWeatherObject:)
    @NSManaged public func removeFromHourlyWeather(_ value: HourlyWeatherEntity)

    @objc(addHourlyWeather:)
    @NSManaged public func addToHourlyWeather(_ values: NSSet)

    @objc(removeHourlyWeather:)
    @NSManaged public func removeFromHourlyWeather(_ values: NSSet)

}
