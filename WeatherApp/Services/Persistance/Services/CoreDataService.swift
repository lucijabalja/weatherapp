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
    
    let coreDataManager: CoreDataManagerProtocol
    let mainObjectContext: NSManagedObjectContext
    let privateObjectContext: NSManagedObjectContext
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.mainObjectContext = coreDataManager.mainManagedObjectContext
        self.privateObjectContext = coreDataManager.privateChildManagedObjectContext()
    }
    
    func saveCurrentWeatherData(_ currentForecastList: [CurrentForecast]) {
        currentForecastList.forEach { CurrentWeatherEntity.createFrom($0, context: privateObjectContext) }
        saveChanges()
    }
    
    func loadCurrentWeatherData() -> Observable<[CurrentWeatherEntity]> {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "city.name", ascending: true)]
        
        return mainObjectContext
            .rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap{ loadedManagedObject -> Observable<[CurrentWeatherEntity]> in
                guard let loadedCurrentWeather = loadedManagedObject as? [CurrentWeatherEntity] else {
                    return .just([])
                }
                return .just(loadedCurrentWeather)
            }
    }
    
    func deleteCurrentWeather(with city: String) {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city.name = %@", city)
        guard let entity = CurrentWeatherEntity.loadCurrentWeatherData(with: request, context: mainObjectContext).first else {
            return
        }
        CurrentWeatherEntity.delete(entity, context: mainObjectContext)
        saveChanges()
    }
    
    func saveWeeklyForecast(_ weeklyWeatherResponse: WeeklyWeatherResponse) {
        WeeklyForecastEntity.createFrom(weeklyWeatherResponse, context: privateObjectContext)
        saveChanges()
    }
    
    func loadWeeklyForecast(withCoordinates latitude: Double, _ longitude: Double) -> Observable<[WeeklyForecastEntity]> {
        let request: NSFetchRequest<WeeklyForecastEntity> = WeeklyForecastEntity.fetchRequest()
        let epsilon = 0.000001;
        let coordinatesPredicate = NSPredicate(format: "latitude > %lf AND latitude < %lf AND longitude > %lf AND longitude < %lf",
                                               latitude - epsilon,  latitude + epsilon, longitude - epsilon, longitude + epsilon)
        request.predicate = coordinatesPredicate
        request.sortDescriptors = []
        
        return mainObjectContext
            .rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { (loadedManagedObject) -> Observable<[WeeklyForecastEntity]> in
                guard let loadedWeeklyForecastEntity = loadedManagedObject as? [WeeklyForecastEntity] else {
                    return .just([])
                }
                return .just(loadedWeeklyForecastEntity)
                
            }
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
