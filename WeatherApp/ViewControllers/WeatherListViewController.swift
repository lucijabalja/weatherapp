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
    private var weatherViewModel: WeatherListViewModel!
    
    init(with weatherViewModel: WeatherListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherViewModel = weatherViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to locate sqlite file
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        
        setupTableView()
        setupUI()
        setupConstraints()
        fillTableView()
    }
    
    private func setupTableView() {
        weatherView.tableView.dataSource = self
        weatherView.tableView.delegate = self
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    

    private func fillTableView() {
        weatherViewModel.getCurrentWeather() { (result) in
            switch result {
            case .success(_): self.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self.weatherView.setErrorLabel(withText: "\(error)")
                }
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
        weatherViewModel.currentWeatherList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
        
        if let cityWeather = weatherViewModel.currentWeatherList[safeIndex: indexPath.row] {
            cell.setup(cityWeather)
        } else {
            weatherView.setErrorLabel(withText: "Index out of bounds.")
        }
        return cell
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weatherViewModel.pushToDetailView(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}
