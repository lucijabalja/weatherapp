//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    private let weatherDetailView = WeatherDetailView()
    private var weatherData: CityWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    init(with weatherData: CityWeather) {
        super.init(nibName: nil, bundle: nil)
        weatherDetailView.weatherData = weatherData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        weatherDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherDetailView)
    }
    
    private func setupConstraints() {
        weatherDetailView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        weatherDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        weatherDetailView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weatherDetailView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
}
