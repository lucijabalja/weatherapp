//
//  CityEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 07/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData

extension CityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityEntity> {
        return NSFetchRequest<CityEntity>(entityName: "CityEntity")
    }

    @NSManaged public var name: String
    @NSManaged public var id: Int64
    @NSManaged public var currentWeather: CurrentWeatherEntity?

}
