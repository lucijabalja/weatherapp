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
    
    typealias CurrentWeatherDataResult = Observable<Result<[CurrentWeatherEntity], PersistanceError>>
    typealias WeeklyWeatherDataResult = Observable<Result<[WeeklyForecastEntity], PersistanceError>>
    
    init(coreDataManager: CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
        self.mainObjectContext = coreDataManager.mainManagedObjectContext
        self.privateObjectContext = coreDataManager.privateChildManagedObjectContext()
    }

    func saveCurrentWeatherData(_ currentForecastList: [CurrentForecast]) {
        currentForecastList.forEach { CurrentForecastEntity.createOrUpdate($0, context: privateObjectContext) }
        saveChanges()
    }
    
    func loadCurrentWeatherData() -> CurrentWeatherDataResult {
        let request: NSFetchRequest<CurrentForecastEntity> = CurrentForecastEntity.fetchRequest()
        request.sortDescriptors = []
        
        return mainObjectContext
            .rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap{ loadedManagedObject -> CurrentWeatherDataResult in
                guard
                    let loadedCurrentWeather = loadedManagedObject as? [CurrentForecastEntity],
                    let entities = loadedCurrentWeather.first?.currentWeatherEntities?.array as? [CurrentWeatherEntity]
                else {
                    return .just(.failure(.noEntitiesFound))
                }
                
                guard entities.count > 0 else { return .just(.failure(.noEntitiesFound))}
          
                return .just(.success(entities))
            }
    }
    
    func deleteCurrentWeather(with city: String) {
        let request: NSFetchRequest<CurrentWeatherEntity> = CurrentWeatherEntity.fetchRequest()
        request.predicate = NSPredicate(format: "city.name = %@", city)
        guard let entity = CurrentWeatherEntity.load(with: request, context: mainObjectContext).first else {
            return
        }
        
        CurrentWeatherEntity.delete(entity, context: mainObjectContext)
        saveChanges()
    }
    
    func reorderCurrentWeatherList(_ currentWeatherEntity: CurrentWeatherEntity,_ sourceIndex: Int,_ destinationIndex: Int) {
        CurrentForecastEntity.reorder(currentWeatherEntity, sourceIndex, destinationIndex, context: mainObjectContext)
        saveChanges()
    }
    
    func saveWeeklyForecast(_ weeklyWeatherResponse: WeeklyWeatherResponse) {
        WeeklyForecastEntity.createOrUpdate(weeklyWeatherResponse, context: privateObjectContext)
        saveChanges()
    }
    
    func loadWeeklyForecast(withCoordinates latitude: Double, _ longitude: Double) -> WeeklyWeatherDataResult {
        let request: NSFetchRequest<WeeklyForecastEntity> = WeeklyForecastEntity.fetchRequest()
        let epsilon = 0.000001;
        let coordinatesPredicate = NSPredicate(format: "latitude > %lf AND latitude < %lf AND longitude > %lf AND longitude < %lf",
                                               latitude - epsilon,  latitude + epsilon, longitude - epsilon, longitude + epsilon)
        request.predicate = coordinatesPredicate
        request.sortDescriptors = []
        
        return mainObjectContext
            .rx_entities(request as! NSFetchRequest<NSFetchRequestResult>)
            .flatMap { (loadedManagedObject) -> WeeklyWeatherDataResult in
                guard let loadedWeeklyForecastEntity = loadedManagedObject as? [WeeklyForecastEntity] else {
                    return .just(.failure(.loadingError))
                }
                
                guard loadedWeeklyForecastEntity.count > 0 else { return .just(.failure(.noEntitiesFound))}

                return .just(.success(loadedWeeklyForecastEntity))
            }
    }
    
    func loadCityEntites() -> [CityEntity] {
        let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
        return CityEntity.load(with: request, context: mainObjectContext)
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
