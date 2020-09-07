//
//  CityEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 07/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class CityEntity: NSManagedObject {

    class func createFrom(_ name: String,_ id: Double, context: NSManagedObjectContext) -> CityEntity {
        let cityEntity = CityEntity(context: context)
        cityEntity.name = name
        cityEntity.id = id
        return cityEntity
    }
}
