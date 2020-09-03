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
    private let errorView = ErrorView()
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
              
        setupEvents()
        setupTableView()
        setupUI()
        setupConstraints()
        fillTableView()
    }
    
    private func setupEvents() {
        errorView.refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
    }
    
    @objc func refreshButtonPressed() {
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
                    self.weatherView.tableView.isHidden = true
                    self.errorView.isHidden = false
                    self.errorView.setErrorLabel(with: error)
                }
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.weatherView.tableView.isHidden = false
            self.weatherView.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        weatherView.isHidden = false
        errorView.isHidden = true
        
        view.addSubview(weatherView)
        view.addSubview(errorView)
    }
    
    private func setupConstraints() {
        weatherView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        weatherView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        weatherView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        weatherView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        errorView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        errorView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        errorView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        errorView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
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
            return cell
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
