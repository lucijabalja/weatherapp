//
//  WeatherDescriptionEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension WeatherDescriptionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WeatherDescriptionEntity> {
        return NSFetchRequest<WeatherDescriptionEntity>(entityName: "WeatherDescriptionEntity")
    }

    @NSManaged public var conditionDescription: String
    @NSManaged public var conditionID: Int64
    @NSManaged public var currentWeather: CurrentWeatherEntity

}
