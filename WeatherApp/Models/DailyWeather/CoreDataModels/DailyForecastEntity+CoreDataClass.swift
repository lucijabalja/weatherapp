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


public class DailyForecastEntity: NSManagedObject {
    
    class func createFrom(_ dailyWeatherResponse: DailyWeatherResponse, context: NSManagedObjectContext) {
        guard let dailyForecastEntity = loadDailyForecast(with: dailyWeatherResponse.latitude, dailyWeatherResponse.longitude, context: context) else {
            creteNewEntity(with: dailyWeatherResponse, context: context)
            return
        }
        
        for dailyForecast in dailyWeatherResponse.dailyForecast {
            let date = Date(timeIntervalSince1970: TimeInterval(dailyForecast.dateTime))
            guard let dailyWeather = DailyWeatherEntity.loadDailyWeather(with: Utils.getWeekDay(with: date), dailyForecastEntity, context: context) else { return }
            
            dailyWeather.update(with: dailyForecast)
            
        }
    }
    
    class func creteNewEntity(with dailyWeatherResponse: DailyWeatherResponse, context: NSManagedObjectContext) {
        let dailyForecastEntity = DailyForecastEntity(context: context)
        dailyForecastEntity.latitude = dailyWeatherResponse.latitude
        dailyForecastEntity.longitude = dailyWeatherResponse.longitude
        
        for dailyForecast in dailyWeatherResponse.dailyForecast {
            let temperature = TemperatureEntity.createFrom(temperature: dailyForecast.temperature, context: context)
            let dailyWeather = DailyWeatherEntity.createfrom(dailyForecast.dateTime, dailyForecast.weather[0].conditionID, context: context)
            
            dailyWeather.temperature = temperature
            dailyForecastEntity.addToDailyWeather(dailyWeather)
        }
    }
    
    class func loadDailyForecast(with latitude: Double, _ longitude: Double, context: NSManagedObjectContext) -> DailyForecastEntity? {
        let request: NSFetchRequest<DailyForecastEntity> = DailyForecastEntity.fetchRequest()
        let epsilon = 0.000001;
        let coordinatesPredicate = NSPredicate(format: "latitude > %lf AND latitude < %lf AND longitude > %lf AND longitude < %lf",
                                        latitude - epsilon,  latitude + epsilon, longitude - epsilon, longitude + epsilon)
        request.predicate = coordinatesPredicate
        
        do {
            let dailyForecast = try context.fetch(request)
            if let first = dailyForecast.first {
                return first
            }
        } catch {
            print("\(error)")
        }
        return nil
    }
    
}
