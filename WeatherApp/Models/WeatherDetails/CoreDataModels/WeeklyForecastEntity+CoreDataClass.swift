//
//  DailyForecast+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class WeeklyForecastEntity: NSManagedObject {
    
    class func createOrUpdate(_ weeklyWeatherResponse: WeeklyWeatherResponse, context: NSManagedObjectContext) {
        guard let weeklyForecastEntity = load(with: weeklyWeatherResponse.latitude, weeklyWeatherResponse.longitude, context: context) else {
            createFrom(weeklyWeatherResponse, context: context)
            return
        }
        
        update(entity: weeklyForecastEntity, with: weeklyWeatherResponse, context: context)
        
    }
    
    class func createFrom(_ weeklyWeatherResponse: WeeklyWeatherResponse, context: NSManagedObjectContext) {
        let weeklyForecastEntity = WeeklyForecastEntity(context: context)
        weeklyForecastEntity.latitude = weeklyWeatherResponse.latitude
        weeklyForecastEntity.longitude = weeklyWeatherResponse.longitude
        weeklyForecastEntity.currentDetails = CurrentDetailsEntity.createFrom(currentDetails: weeklyWeatherResponse.currentWeatherDetails, context: context)
        
        for (index, dailyForecast) in weeklyWeatherResponse.dailyForecast.enumerated() {
            let dailyWeatherEntity = DailyWeatherEntity.createFrom(dailyForecast, index, context: context)
            dailyWeatherEntity.weeklyForecast = weeklyForecastEntity
            weeklyForecastEntity.addToDailyWeather(dailyWeatherEntity)
        }
        
        for index in 0...23 {
            guard let hourlyForecast = weeklyWeatherResponse.hourlyForecast[safeIndex: index] else { return }
            let hourlyWeatherEntity = HourlyWeatherEntity.createFrom(hourlyForecast, index, context: context)
            hourlyWeatherEntity.weeklyForecast = weeklyForecastEntity
            weeklyForecastEntity.addToHourlyWeather(hourlyWeatherEntity)
        }
    }
    
    class func update(entity: WeeklyForecastEntity, with weeklyWeatherResponse: WeeklyWeatherResponse, context: NSManagedObjectContext) {
        for (index, dailyForecast) in weeklyWeatherResponse.dailyForecast.enumerated() {
            guard let dailyWeatherEntity = DailyWeatherEntity.load(withParent: entity, index: index, context: context) else {
                return
            }
            
            dailyWeatherEntity.update(with: dailyForecast, index: index)
        }
        
        for (index, hourlyForecast) in weeklyWeatherResponse.hourlyForecast.enumerated() {
            guard let hourlyWeatherEntity = HourlyWeatherEntity.load(withParent: entity, index: index, context: context) else {
                return
            }
            
            hourlyWeatherEntity.update(with: hourlyForecast, index: index)
        }
    }
    
    class func load(with latitude: Double, _ longitude: Double, context: NSManagedObjectContext) -> WeeklyForecastEntity? {
        let request: NSFetchRequest<WeeklyForecastEntity> = WeeklyForecastEntity.fetchRequest()
        let epsilon = 0.000001;
        let coordinatesPredicate = NSPredicate(format: "latitude > %lf AND latitude < %lf AND longitude > %lf AND longitude < %lf",
                                               latitude - epsilon,  latitude + epsilon, longitude - epsilon, longitude + epsilon)
        request.predicate = coordinatesPredicate
        
        var weeklyForecast: WeeklyForecastEntity?
        context.performAndWait {
            do {
                weeklyForecast = try context.fetch(request).first
            } catch {
                print("\(error)")
            }
        }
        return weeklyForecast
    }
    
}
