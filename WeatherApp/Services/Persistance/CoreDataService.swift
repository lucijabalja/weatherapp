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
    
    func saveCurrentWeatherData(_ currentWeatherResponse: CurrentWeatherResponse) {
        CurrentForecastEntity.createFrom(currentWeatherResponse, context: privateObjectContext)
        saveChanges()
    }
    
    func loadCurrentForecastData() -> CurrentForecastEntity? {
        CurrentForecastEntity.loadCurrentForecast(context: mainObjectContext)
    }
    
    func saveDailyForecast(_ dailyWeatherResponse: DailyWeatherResponse) {
        DailyForecastEntity.createFrom(dailyWeatherResponse, context: privateObjectContext)
        saveChanges()
    }
    
    func loadDailyForecast(withCoordinates latitude: Double, _ longitude: Double) -> DailyForecastEntity? {
        DailyForecastEntity.loadDailyForecast(with: latitude, longitude, context: mainObjectContext)
    }
    
    func saveHourlyForecast(_ hourlyWeatherResponse: HourlyWeatherResponse,_ city: String) {
        HourlyForecastEntity.createFrom(hourlyWeatherResponse, city, context: privateObjectContext)
        saveChanges()
    }
    
    func loadHourlyForecast(forCity city: String) -> HourlyForecastEntity? {
        HourlyForecastEntity.loadHourlyForecast(for: city, context: mainObjectContext)
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
