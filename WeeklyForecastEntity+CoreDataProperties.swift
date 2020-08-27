//
//  WeeklyForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 27/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension WeeklyForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeeklyForecastEntity> {
        return NSFetchRequest<WeeklyForecastEntity>(entityName: "WeeklyForecastEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var dailyWeather: NSSet
    @NSManaged public var hourlyWeather: NSSet

}

// MARK: Generated accessors for dailyWeather
extension WeeklyForecastEntity {

    @objc(addDailyWeatherObject:)
    @NSManaged public func addToDailyWeather(_ value: DailyWeatherEntity)

    @objc(removeDailyWeatherObject:)
    @NSManaged public func removeFromDailyWeather(_ value: DailyWeatherEntity)

    @objc(addDailyWeather:)
    @NSManaged public func addToDailyWeather(_ values: NSSet)

    @objc(removeDailyWeather:)
    @NSManaged public func removeFromDailyWeather(_ values: NSSet)

}

// MARK: Generated accessors for hourlyWeather
extension WeeklyForecastEntity {

    @objc(addHourlyWeatherObject:)
    @NSManaged public func addToHourlyWeather(_ value: HourlyWeatherEntity)

    @objc(removeHourlyWeatherObject:)
    @NSManaged public func removeFromHourlyWeather(_ value: HourlyWeatherEntity)

    @objc(addHourlyWeather:)
    @NSManaged public func addToHourlyWeather(_ values: NSSet)

    @objc(removeHourlyWeather:)
    @NSManaged public func removeFromHourlyWeather(_ values: NSSet)

}
