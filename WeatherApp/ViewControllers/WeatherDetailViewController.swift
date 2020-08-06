//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 04/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    let weatherDetailView = WeatherDetailView()
    var weatherData: WeatherData?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    init(with weatherData: WeatherData) {
        super.init(nibName: nil, bundle: nil)
        weatherDetailView.weatherData = weatherData
    }
    
    func setupUI() {
        weatherDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherDetailView)
    }
    
    func setupConstraints() {
        weatherDetailView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        weatherDetailView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        weatherDetailView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weatherDetailView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
