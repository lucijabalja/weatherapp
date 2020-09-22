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
        cityEntity.id = Int64(id)
        return cityEntity
    }
    
    func update(with city: String, _ id: Double){
        self.name = city
        self.id = Int64(id)
    }
    
    class func loadCities(context: NSManagedObjectContext) -> [CityEntity] {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        do {
            let cities = try context.fetch(request)
            return cities
        } catch {
            print("\(error)")
            return []
        }
    }
    
}
