//
//  PersistanceError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum PersistanceError: Error, WeatherErrorHandler {
    
    case loadingError, savingError, noEntitiesFound
    
    func resolveMessage() -> (String, String) {
        switch self {
        case .loadingError:
            return (ErrorMessage.loadingError, ErrorMessage.tryAgain)
        case .noEntitiesFound:
            return (ErrorMessage.noInternetConnection, ErrorMessage.turnInternetConnection)
        case .savingError:
            return (ErrorMessage.savingError, ErrorMessage.tryAgain)
        }
    }
}
