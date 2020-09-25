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
    
    let coreDataManager: CoreDataManager
    let mainObjectContext: NSManagedObjectContext
    let privateObjectContext: NSManagedObjectContext
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.mainObjectContext = coreDataManager.mainManagedObjectContext
        self.privateObjectContext = coreDataManager.privateChildManagedObjectContext()
    }
    
    func saveCurrentWeatherData(_ currentForecastList: [CurrentForecast]) {
        currentForecastList.forEach { CurrentWeatherEntity.createFrom($0, context: privateObjectContext) }
        saveChanges()
    }
    
    func loadCurrentWeatherData() -> [CurrentWeatherEntity] {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
       // request.predicate = NSPredicate(format: "city.name = %@", city)
        request.returnsObjectsAsFaults = false
        
        return CurrentWeatherEntity.loadCurrentWeatherData(request: request, context: mainObjectContext)
    }
    
    func loadCurrentWeatherData(forCity city: String) -> CurrentWeatherEntity? {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city.name = %@", city)
        request.returnsObjectsAsFaults = false
        let entities = CurrentWeatherEntity.loadCurrentWeatherData(request: request, context: mainObjectContext)
       
        return entities.first
    }
    
    func saveWeeklyForecast(_ weeklyWeatherResponse: WeeklyWeatherResponse) {
        WeeklyForecastEntity.createFrom(weeklyWeatherResponse, context: privateObjectContext)
        saveChanges()
    }
    
    func loadWeeklyForecast(withCoordinates latitude: Double, _ longitude: Double) -> WeeklyForecastEntity? {
        WeeklyForecastEntity.loadWeeklyForecast(with: latitude, longitude, context: mainObjectContext)
    }
    
    func loadCityEntites() -> [CityEntity] {
        CityEntity.loadCities(context: mainObjectContext) 
    }

    func saveChanges() {
        privateObjectContext.performAndWait {
            do {
                if privateObjectContext.hasChanges {
                    try privateObjectContext.save()
                }
            } catch {
                print("Unable to Save Changes of Managed Object Context")
                print("\(error), \(error.localizedDescription)")
            }
        }
        coreDataManager.saveChanges()
    }
    
}
