//
//  SearchError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 27/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum SearchError: Error, WeatherErrorHandler {
    case emptyInput, termNotFound, locationUnavailable
    
    func resolveMessage() -> (String, String) {
        switch self {
        case .emptyInput:
            return(ErrorMessage.emptyInput, ErrorMessage.searchBarInput)
        case .termNotFound:
            return (ErrorMessage.noLocationFound, ErrorMessage.tryAgain)
        case .locationUnavailable:
            return (ErrorMessage.locationUnavailable, ErrorMessage.tryAgain)
        @unknown default:
            return (ErrorMessage.searchError, ErrorMessage.tryAgain)
        }
    }
}
