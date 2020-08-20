//
//  CityWeatherEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 19/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import CoreData
import UIKit

public class CityWeatherEntity: NSManagedObject {
    
    
    class func checkIfExiists() {
        
        
        
    }
    
    class func firstOrCreate(_ city: String,_ currentWeather: String) -> Bool {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()
        let cityPredicate = NSPredicate(format: "city == %@", city)
        let temperaturePredicate = NSPredicate(format: "parameters.current == %@", currentWeather)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [cityPredicate, temperaturePredicate])
        request.predicate = andPredicate
        
        do {
            let count = try context.count(for: request)
            if count > 0 {
                return true
            }
        } catch {
            print("\(error)")
            return false
        }
        return false
    }
    
    class func updateData( ) {
        
    }
}
