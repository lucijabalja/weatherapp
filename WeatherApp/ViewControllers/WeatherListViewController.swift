//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import PureLayout

class WeatherListViewController: UIViewController {
    
    private let weatherListView = WeatherListView()
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    private func setupEvents() {
        errorView.refreshButton.addTarget(self, action: #selector(refreshButtonPressed), for: .touchUpInside)
    }
    
    @objc func refreshButtonPressed() {
        fillTableView()
    }
    
    private func setupTableView() {
        weatherListView.tableView.dataSource = self
        weatherListView.tableView.delegate = self
        weatherListView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func fillTableView() {
        weatherViewModel.getCurrentWeather() { [weak self] (result) in
            switch result {
            case .success(_): self?.updateUI()
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.setErrorView(with: error)
                }
            }
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.errorView.isHidden = true
            self.weatherListView.tableView.isHidden = false
            self.weatherListView.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        weatherListView.isHidden = false
        errorView.isHidden = true
    }
    
    private func setupConstraints() {
        view.addSubview(weatherListView)
        weatherListView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }
    
    private func setErrorView(with error: Error) {
        errorView.setErrorLabel(with: error)
        weatherListView.tableView.isHidden = true
        errorView.isHidden = false
        
        view.addSubview(errorView)
        errorView.autoPinEdgesToSuperviewEdges()
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
        tableView.deselectRow(at: indexPath, animated: false)
        return weatherViewModel.pushToDetailView(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
}
