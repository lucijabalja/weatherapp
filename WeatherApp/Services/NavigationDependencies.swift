//
//  NavigationDependencies.swift
//  WeatherApp
//
//  Created by Lucija Balja on 10/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation

struct NavigationDependencies {
    let weatherApiService = WeatherApiService()
    let coordinator: Coordinator
}
