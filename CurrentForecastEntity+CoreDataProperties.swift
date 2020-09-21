//
//  CurrentForecastEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentForecastEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentForecastEntity> {
        return NSFetchRequest<CurrentForecastEntity>(entityName: "CurrentForecastEntity")
    }

    @NSManaged public var currentWeatherEntities: NSOrderedSet?

}

// MARK: Generated accessors for currentWeatherEntities
extension CurrentForecastEntity {

    @objc(insertObject:inCurrentWeatherEntitiesAtIndex:)
    @NSManaged public func insertIntoCurrentWeatherEntities(_ value: CurrentWeatherEntity, at idx: Int)

    @objc(removeObjectFromCurrentWeatherEntitiesAtIndex:)
    @NSManaged public func removeFromCurrentWeatherEntities(at idx: Int)

    @objc(insertCurrentWeatherEntities:atIndexes:)
    @NSManaged public func insertIntoCurrentWeatherEntities(_ values: [CurrentWeatherEntity], at indexes: NSIndexSet)

    @objc(removeCurrentWeatherEntitiesAtIndexes:)
    @NSManaged public func removeFromCurrentWeatherEntities(at indexes: NSIndexSet)

    @objc(replaceObjectInCurrentWeatherEntitiesAtIndex:withObject:)
    @NSManaged public func replaceCurrentWeatherEntities(at idx: Int, with value: CurrentWeatherEntity)

    @objc(replaceCurrentWeatherEntitiesAtIndexes:withCurrentWeatherEntities:)
    @NSManaged public func replaceCurrentWeatherEntities(at indexes: NSIndexSet, with values: [CurrentWeatherEntity])

    @objc(addCurrentWeatherEntitiesObject:)
    @NSManaged public func addToCurrentWeatherEntities(_ value: CurrentWeatherEntity)

    @objc(removeCurrentWeatherEntitiesObject:)
    @NSManaged public func removeFromCurrentWeatherEntities(_ value: CurrentWeatherEntity)

    @objc(addCurrentWeatherEntities:)
    @NSManaged public func addToCurrentWeatherEntities(_ values: NSOrderedSet)

    @objc(removeCurrentWeatherEntities:)
    @NSManaged public func removeFromCurrentWeatherEntities(_ values: NSOrderedSet)

}

extension CurrentForecastEntity : Identifiable {

}
