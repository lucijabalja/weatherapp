//
//  CoreDataManagerProtocol.swift
//  WeatherApp
//
//  Created by Lucija Balja on 21/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerProtocol {

    var mainManagedObjectContext: NSManagedObjectContext { get }

    func saveChanges()

    func privateChildManagedObjectContext() -> NSManagedObjectContext

}
