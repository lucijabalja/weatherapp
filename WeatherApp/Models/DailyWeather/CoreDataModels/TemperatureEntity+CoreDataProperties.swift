//
//  TemperatureEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension TemperatureEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemperatureEntity> {
        return NSFetchRequest<TemperatureEntity>(entityName: "TemperatureEntity")
    }

    @NSManaged public var max: Double
    @NSManaged public var min: Double
    @NSManaged public var weather: DailyWeatherEntity

}
