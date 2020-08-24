//
//  TemperatureEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class TemperatureEntity: NSManagedObject {
    
    class func createFrom(temperature: Temperature) -> TemperatureEntity {
        let context = DataController.shared.persistentContainer.viewContext

        let temperatureEntity = TemperatureEntity(context: context)
        temperatureEntity.max = temperature.max
        temperatureEntity.min = temperature.min
        
        return temperatureEntity
    }
}
