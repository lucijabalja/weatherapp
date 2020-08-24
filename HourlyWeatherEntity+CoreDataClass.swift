//
//  HourlyWeatherEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 23/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData

public class HourlyWeatherEntity: NSManagedObject {
    
    class func createFrom(_ hourlyForecast: HourlyForecast) -> HourlyWeatherEntity {
        let context = DataController.shared.persistentContainer.viewContext
        let hourlyWeatherEntity = HourlyWeatherEntity(context: context)
        
        hourlyWeatherEntity.time = Int64(hourlyForecast.dateTime)
        hourlyWeatherEntity.temperature = hourlyForecast.temperatureParameters.currentTemperature
        hourlyWeatherEntity.conditionID = Int64(hourlyForecast.weather[0].conditionID)
        return hourlyWeatherEntity
    }
    
    class func loadHourlyWeather(with city: String) -> [HourlyWeatherEntity] {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<HourlyWeatherEntity> = HourlyWeatherEntity.fetchRequest()
        let dailyForecastPredicate = NSPredicate(format: "hourlyForecast.city = %@", city)
        let timeSort = NSSortDescriptor(key: "time", ascending: true)
        
        request.predicate = dailyForecastPredicate
        request.sortDescriptors = [timeSort]
        
        do {
            let hourlyWeather = try context.fetch(request)
            return hourlyWeather
        } catch {
            print("\(error)")
        }
        return []
    }
    
    func update(with hourlyForecast: HourlyForecast) {
          self.time = Int64(hourlyForecast.dateTime)
          self.temperature = hourlyForecast.temperatureParameters.currentTemperature
          self.conditionID = Int64(hourlyForecast.weather[0].conditionID)
      }
      
}
