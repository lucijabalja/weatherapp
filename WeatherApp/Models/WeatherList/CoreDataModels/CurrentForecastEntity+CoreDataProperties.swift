//
//  CurrentForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentForecastEntity> {
        return NSFetchRequest<CurrentForecastEntity>(entityName: "CurrentForecastEntity")
    }

    @NSManaged public var dateTime: Int64
    @NSManaged public var currentWeather: NSSet

}

// MARK: Generated accessors for currentWeather
extension CurrentForecastEntity {

    @objc(addCurrentWeatherObject:)
    @NSManaged public func addToCurrentWeather(_ value: CurrentWeatherEntity)

    @objc(removeCurrentWeatherObject:)
    @NSManaged public func removeFromCurrentWeather(_ value: CurrentWeatherEntity)

    @objc(addCurrentWeather:)
    @NSManaged public func addToCurrentWeather(_ values: NSSet)

    @objc(removeCurrentWeather:)
    @NSManaged public func removeFromCurrentWeather(_ values: NSSet)

}
