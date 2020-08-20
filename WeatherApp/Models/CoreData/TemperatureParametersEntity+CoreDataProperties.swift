//
//  TemperatureParametersEntity+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Lucija Balja on 19/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


extension TemperatureParametersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TemperatureParametersEntity> {
        return NSFetchRequest<TemperatureParametersEntity>(entityName: "TemperatureParametersEntity")
    }

    @NSManaged public var current: String?
    @NSManaged public var max: String?
    @NSManaged public var min: String?
    @NSManaged public var cityWeather: CityWeatherEntity?

    
    func update(with temperatureParams: CurrentTemperature) {
        self.current = temperatureParams.current
        self.max = temperatureParams.max
        self.min = temperatureParams.min
         
    }
}
