//
//  CurrentWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 07/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherEntity> {
        return NSFetchRequest<CurrentWeatherEntity>(entityName: "CurrentWeatherEntity")
    }

    @NSManaged public var orderNumber: Int64
    @NSManaged public var city: CityEntity
    @NSManaged public var parameters: TemperatureParametersEntity
    @NSManaged public var weatherDescription: WeatherDescriptionEntity

}
