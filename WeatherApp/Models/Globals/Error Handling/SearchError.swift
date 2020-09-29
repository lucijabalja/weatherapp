//
//  SearchError.swift
//  WeatherApp
//
//  Created by Lucija Balja on 27/09/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

enum SearchError: String, Error, ErrorHandler {
    
    case emptyInput, locationUnavailable
    
    var message: (String, String) {
        switch self {
        case .emptyInput:
            return (ErrorMessage.emptyInput, ErrorMessage.searchBarInput)
        case .locationUnavailable:
            return (ErrorMessage.locationUnavailable, ErrorMessage.tryAnother)
        }
    }
}
