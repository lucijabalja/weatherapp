//
//  WeatherDescriptionEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class WeatherDescriptionEntity: NSManagedObject {

    class func createFrom(_ weatherDescription: WeatherDescription, context: NSManagedObjectContext) -> WeatherDescriptionEntity {
        let weatherDescriptionEntity = WeatherDescriptionEntity(context: context)
        
        weatherDescriptionEntity.conditionID = Int64(weatherDescription.conditionID)
        weatherDescriptionEntity.conditionDescription = weatherDescription.conditionDescription
    
        return weatherDescriptionEntity
    }
    
    
    func update(with weatherDescription: WeatherDescription) {
        self.conditionID = Int64(weatherDescription.conditionID)
        self.conditionDescription = weatherDescription.conditionDescription
    }
}
