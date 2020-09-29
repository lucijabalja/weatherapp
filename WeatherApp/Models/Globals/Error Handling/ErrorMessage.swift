//
//  ErrorMessage.swift
//  WeatherApp
//
//  Created by Lucija Balja on 25/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

class ErrorMessage {
    
    //default error messages
    static let defaultError = "Something went wrong"
    
    // Core data error messages
    static let loadingError = "Could not load data succesfully."
    static let savingError = "Could not save data successfully."
    static let noEntities = "Your database is empty."
    static let startSearching = "Start with searching for a city"
    
    // Api error mesages
    static let invalidURLError = "Invalid URL passed."
    static let urlSessionError = "Could not successfuly fetch data."
    static let unwrappingError = "Cannot unwrap data correctly."
    static let decodingError = "Cannot correctly decode data "
    static let parsingError = "Cannot parse data correctly."
    
    // Internet connection error messages
    static let noInternetConnection = "Internet connection is turned off"
    static let turnInternetConnection = "Turn on internet connection or Wi-Fi to access data."
    
    // Global error messages
    static let tryAgain = "Try again"
    static let tryAnother = "Try another location"
    
    // Location error messages
    static let cityNotFound = "No results found"
    static let locationUnavailable = "Current location is temporaraly unavailable"
    
    // Search input error messages
    static let emptyInput = "Input cannot be empty"
    static let searchBarInput = "Enter location name and try again"
    static let searchError = "Search bar error happened"
}
