//
//  DataRepository.swift
//  WeatherApp
//
//  Created by Lucija Balja on 18/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class CoreDataService {
    
    let coreDataManager: CoreDataManager
    let mainObjectContext: NSManagedObjectContext
    let privateObjectContext: NSManagedObjectContext
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.mainObjectContext = coreDataManager.mainManagedObjectContext
        self.privateObjectContext = coreDataManager.privateChildManagedObjectContext()
    }
    
    func saveCurrentWeatherData(_ currentWeatherResponse: CurrentWeatherResponse) {
        currentWeatherResponse.currentForecastList.forEach { CurrentWeatherEntity.createFrom($0, context: privateObjectContext) }
        saveChanges()
    }
    
    func saveCurrentForecastData(_ currentForecast: CurrentForecast) {
        CurrentWeatherEntity.createFrom(currentForecast, context: privateObjectContext)
        saveChanges()
    }

    func loadCurrentForecastData() -> [CurrentWeatherEntity] {
        CurrentWeatherEntity.loadCurrentWeatherData(context: mainObjectContext)
    }
    
    func saveWeeklyForecast(_ weeklyWeatherResponse: WeeklyWeatherResponse) {
        WeeklyForecastEntity.createFrom(weeklyWeatherResponse, context: privateObjectContext)
        saveChanges()
    }
    
    func loadWeeklyForecast(withCoordinates latitude: Double, _ longitude: Double) -> WeeklyForecastEntity? {
        WeeklyForecastEntity.loadWeeklyForecast(with: latitude, longitude, context: mainObjectContext)
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
