//
//  CurrentForecastEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class CurrentForecastEntity: NSManagedObject {
    
    typealias CurrentForecastRequest = NSFetchRequest<CurrentForecastEntity>

    class func createOrUpdate(_ currentForecast: CurrentForecast, context: NSManagedObjectContext) {
        let currentWeatherEntity = CurrentWeatherEntity.createOrUpdate(currentForecast, context: context)
         
        let request: CurrentForecastRequest = CurrentForecastEntity.fetchRequest()
        guard let currentForecastEntity = load(with: request, context: context) else {
            let currentForecast = CurrentForecastEntity(context: context)
            currentForecast.addToCurrentWeatherEntities(currentWeatherEntity)
            return
        }
        currentForecastEntity.addToCurrentWeatherEntities(currentWeatherEntity)
    }
    
    class func reorder(_ currentWeatherEntity: CurrentWeatherEntity,_ sourceIndex: Int,_ destinationIndex: Int, context: NSManagedObjectContext) {
        let request: CurrentForecastRequest = CurrentForecastEntity.fetchRequest()
        guard let currentForecastEntity = load(with: request, context: context) else {
            return
        }
        currentForecastEntity.removeFromCurrentWeatherEntities(at: sourceIndex)
        currentForecastEntity.insertIntoCurrentWeatherEntities(currentWeatherEntity, at: destinationIndex)
    }

    class func load(with request: CurrentForecastRequest, context: NSManagedObjectContext) -> CurrentForecastEntity? {
        do {
            return try context.fetch(request).first
        } catch {
            print("\(error)")
            return nil
        }
    }
}
