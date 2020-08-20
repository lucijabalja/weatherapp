//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import CoreData

class CoreDataService {
    
    private let context = DataController.shared.persistentContainer.viewContext
    private var cityWeatherArray = [CityWeatherEntity]()
    
    func saveCurrentWeatherData(weatherResponse: CurrentWeather) {        
        CityWeatherEntity.createFrom(weatherResponse: weatherResponse)

    }
    
    func loadCurrentWeatherData() -> [CityWeatherEntity] {
        let request: NSFetchRequest<CityWeatherEntity> = CityWeatherEntity.fetchRequest()
        do {
            cityWeatherArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        return cityWeatherArray
    }
    
}
