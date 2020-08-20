//
//  CityWeatherEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 19/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension CityWeatherEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeatherEntity> {
        return NSFetchRequest<CityWeatherEntity>(entityName: "CityWeatherEntity")
    }

    @NSManaged public var city: String?
    @NSManaged public var icon: String?
    @NSManaged public var weatherDescription: String?
    @NSManaged public var parameters: TemperatureParametersEntity?
    
}
