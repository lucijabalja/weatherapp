//
//  TemperatureParametersEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension TemperatureParametersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemperatureParametersEntity> {
        return NSFetchRequest<TemperatureParametersEntity>(entityName: "TemperatureParametersEntity")
    }

    @NSManaged public var current: Double
    @NSManaged public var max: Double
    @NSManaged public var min: Double
    @NSManaged public var currentWeather: CurrentWeatherEntity

}
