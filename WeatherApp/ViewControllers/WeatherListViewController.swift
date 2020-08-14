//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherListViewController: UIViewController {
    
    private let weatherView = WeatherListView()
    private var weatherViewModel: WeatherListViewModel! {
        didSet {
            fillTableView()
        }
    }
    weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupTableView()
        setupUI()
        setupConstraints()
    }
    
    private func setupViewModel() {
        self.weatherViewModel = coordinator?.createWeatherViewModel()
    }
    
    private func setupTableView() {
        weatherView.tableView.dataSource = self
        weatherView.tableView.delegate = self
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func fillTableView() {
        weatherViewModel.fetchCityWeather() { (apiResponseMessage) in
            switch apiResponseMessage {
                case .SUCCESSFUL: self.updateUI()
                case .FAILED: self.weatherView.setErrorLabel()
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.weatherView.tableView.reloadData()
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

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weatherViewModel.weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        
        if weatherViewModel.checkCount(with: indexPath.row) {
            cell.setup(weatherViewModel.weatherData[indexPath.row])
        } else {
            weatherView.setErrorLabel()
        }
        
        return cell
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard weatherViewModel.checkCount(with: indexPath.row) else {
            weatherView.setErrorLabel()
            return
        }
        coordinator?.pushDetailViewController(weatherViewModel.weatherData[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
