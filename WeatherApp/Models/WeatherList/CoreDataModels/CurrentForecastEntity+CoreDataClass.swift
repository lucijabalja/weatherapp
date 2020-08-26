//
//  CityForecastEntity+CoreDataClass.swift
//  WeatherApp
//
//  Created by Lucija Balja on 22/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//
//

import Foundation
import CoreData


public class CurrentForecastEntity: NSManagedObject {

    class func createFrom(_ currentWeatherResponse: CurrentWeatherResponse, context: NSManagedObjectContext) {
        guard loadCurrentForecast(context: context) != nil else {
            creteNewEntity(with: currentWeatherResponse, context: context)
            return
        }
        
        for currentForecast in currentWeatherResponse.currentForecastList {
            guard let currentWeatherEntity = CurrentWeatherEntity.loadCurrentWeather(forCity: currentForecast.city, context: context) else {
                return
            }
            
            currentWeatherEntity.weatherDescription.update(with: currentForecast.weatherDescription[0])
            currentWeatherEntity.parameters.update(with: currentForecast.temperatureParameters)
        }
    }
    
    class func creteNewEntity(with currentWeatherResponse: CurrentWeatherResponse, context: NSManagedObjectContext) {
        let cityForecastEntity = CurrentForecastEntity(context: context)
        cityForecastEntity.dateTime = Int64(Date().timeIntervalSince1970)
        
        for currentForecast in currentWeatherResponse.currentForecastList {
            let currentWeather = CurrentWeatherEntity.createFrom(currentForecast, context: context)
            currentWeather.parameters = TemperatureParametersEntity.createFrom(currentForecast.temperatureParameters, context: context)
            currentWeather.weatherDescription = WeatherDescriptionEntity.createFrom(currentForecast.weatherDescription[0], context: context)

            cityForecastEntity.addToCurrentWeather(currentWeather)
        }
    }
    
    class func loadCurrentForecast(context: NSManagedObjectContext) -> CurrentForecastEntity? {
        let request: NSFetchRequest<CurrentForecastEntity> = CurrentForecastEntity.fetchRequest()
        
        do {
            let currentForecast = try context.fetch(request)
            return currentForecast.first
        } catch {
            print("\(error)")
            return nil
        }
    }

}
