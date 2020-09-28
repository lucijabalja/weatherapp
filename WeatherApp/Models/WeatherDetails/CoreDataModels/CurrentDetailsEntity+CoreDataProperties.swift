//
//  CurrentDetailsEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 28/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension CurrentDetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentDetailsEntity> {
        return NSFetchRequest<CurrentDetailsEntity>(entityName: "CurrentDetailsEntity")
    }

    @NSManaged public var sunrise: Int64
    @NSManaged public var sunset: Int64
    @NSManaged public var feelsLike: Double
    @NSManaged public var humidity: Int64
    @NSManaged public var pressure: Int64
    @NSManaged public var visibility: Int64
    @NSManaged public var weeklyForecast: WeeklyForecastEntity?

}

extension CurrentDetailsEntity : Identifiable {

}
