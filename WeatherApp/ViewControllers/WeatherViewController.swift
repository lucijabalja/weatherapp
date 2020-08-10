//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    private let weatherView = WeatherView()
    private var weatherViewModel: WeatherViewModel! {
        didSet {
            fillTableView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setViewModel()
        setupTableView()
        setupUI()
        setupConstraints()
    }
    
    private func setViewModel() {
        guard let navigationController = navigationController else { return }
        
        self.weatherViewModel = WeatherViewModel(coordinator: Coordinator(navigationController))
    }
    
    private func setupTableView() {
        weatherView.tableView.dataSource = self
        weatherView.tableView.delegate = self
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: Constants.weatherCell)
    }
    
    private func fillTableView() {
        weatherViewModel.fetchWeatherData() { (status) in
            DispatchQueue.main.async {
                self.weatherView.tableView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherView)
    }
    
    private func setupConstraints() {
        weatherView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        weatherView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        weatherView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weatherView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
}

extension WeatherViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherCell, for: indexPath) as! WeatherTableViewCell
        
        if weatherViewModel.checkCount(with: indexPath.row) {
            cell.setup(weatherViewModel.weatherData[indexPath.row])
        } else {
            weatherView.setErrorLabel()
        }
        
        return cell
    }
    
}

extension WeatherViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard weatherViewModel.checkCount(with: indexPath.row) else {
            weatherView.setErrorLabel()
            return
        }
        
        weatherViewModel.pushToDetailView(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
