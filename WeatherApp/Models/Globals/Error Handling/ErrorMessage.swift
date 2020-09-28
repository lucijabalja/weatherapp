//
//  ErrorMessage.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class ErrorMessage {
    
    static let loadingError = "Could not load data succesfully."
    static let savingError = "Could not save data successfully."
    static let invalidURLError = "Invalid URL passed."
    static let urlSessionError = "URL session failed. Try again."
    static let unwrappingError = "Cannot unwrap data correctly."
    static let parsingError = "Cannot parse data correctly."
    static let noInternetConnection = "Internet connection is turned off"
    static let turnInternetConnection = "Turn on internet connection or Wi-Fi to access data."
    static let tryAgain = "Try again"
    static let noLocationFound = "Location not found"
    static let locationUnavailable = "Current location is temporaraly unavailable"
    static let emptyInput = "Input cannot be empty"
    static let searchBarInput = "Enter location name and try again"
    static let searchError = "Search bar error happened"
    
}
