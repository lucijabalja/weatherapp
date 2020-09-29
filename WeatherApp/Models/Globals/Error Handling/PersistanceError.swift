//
//  PersistanceError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum PersistanceError: Error, ErrorHandler {
    
    case loadingError, savingError, noEntitiesFound, noEntitesAndNoInternet

    var message: (String, String) {
        switch self {
        case .loadingError:
            return (ErrorMessage.loadingError, ErrorMessage.tryAgain)
        case .savingError:
            return (ErrorMessage.savingError, ErrorMessage.tryAgain)
        case .noEntitiesFound:
            return (ErrorMessage.noEntities, ErrorMessage.startSearching)
        case .noEntitesAndNoInternet:
            return (ErrorMessage.noInternetConnection, ErrorMessage.turnInternetConnection)
        }
    }
}
