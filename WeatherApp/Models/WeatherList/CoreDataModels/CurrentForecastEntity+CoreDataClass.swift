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

    class func createFrom(_ currentWeatherResponse: CurrentWeatherResponse) {
        guard let _ = loadCurrentForecast() else {
            creteNewEntity(with: currentWeatherResponse)
            return
        }
        
        for currentForecast in currentWeatherResponse.currentForecastList {
            guard let currentWeatherEntity = CurrentWeatherEntity.loadCurrentWeather(forCity: currentForecast.city) else {
                return
            }
            
            currentWeatherEntity.weatherDescription.update(with: currentForecast.weatherDescription[0])
            currentWeatherEntity.parameters.update(with: currentForecast.temperatureParameters)
        }

        DataController.shared.saveContext()
    }
    
    class func creteNewEntity(with currentWeatherResponse: CurrentWeatherResponse) {
        let context = DataController.shared.persistentContainer.viewContext

        let cityForecastEntity = CurrentForecastEntity(context: context)
        cityForecastEntity.dateTime = Int64(Date().timeIntervalSince1970)
        
        for currentForecast in currentWeatherResponse.currentForecastList {
            let currentWeather = CurrentWeatherEntity.createFrom(currentForecast)
            currentWeather.parameters = TemperatureParametersEntity.createFrom(currentForecast.temperatureParameters)
            currentWeather.weatherDescription = WeatherDescriptionEntity.createFrom(currentForecast.weatherDescription[0])

            cityForecastEntity.addToCurrentWeather(currentWeather)
        }
        
        DataController.shared.saveContext()
    }
    
    class func loadCurrentForecast() -> CurrentForecastEntity? {
        let context = DataController.shared.persistentContainer.viewContext
        
        let request: NSFetchRequest<CurrentForecastEntity> = CurrentForecastEntity.fetchRequest()
        
        do {
            let currentForecast = try context.fetch(request)
            guard let first = currentForecast.first else { return nil }
        
            return first
        } catch {
            print("\(error)")
        }
        return nil
    }
    
}
