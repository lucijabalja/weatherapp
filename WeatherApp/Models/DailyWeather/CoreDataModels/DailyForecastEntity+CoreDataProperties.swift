//
//  DailyForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension DailyForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyForecastEntity> {
        return NSFetchRequest<DailyForecastEntity>(entityName: "DailyForecastEntity")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var dailyWeather: NSSet

}

// MARK: Generated accessors for dailyWeather
extension DailyForecastEntity {

    @objc(addDailyWeatherObject:)
    @NSManaged public func addToDailyWeather(_ value: DailyWeatherEntity)

    @objc(removeDailyWeatherObject:)
    @NSManaged public func removeFromDailyWeather(_ value: DailyWeatherEntity)

    @objc(addDailyWeather:)
    @NSManaged public func addToDailyWeather(_ values: NSSet)

    @objc(removeDailyWeather:)
    @NSManaged public func removeFromDailyWeather(_ values: NSSet)

}
