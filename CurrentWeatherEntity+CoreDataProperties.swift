//
//  CurrentWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeatherEntity> {
        return NSFetchRequest<CurrentWeatherEntity>(entityName: "CurrentWeatherEntity")
    }

    @NSManaged public var city: String
    @NSManaged public var currentForecast: CurrentForecastEntity
    @NSManaged public var parameters: TemperatureParametersEntity
    @NSManaged public var weatherDescription: WeatherDescriptionEntity

}
