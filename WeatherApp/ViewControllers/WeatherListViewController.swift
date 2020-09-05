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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
            self.weatherView.tableView.isHidden = false
            self.weatherView.tableView.reloadData()
        }
    }
    
    private func setupUI() {
        weatherView.isHidden = false
        errorView.isHidden = true
        
        view.setupGradientBackground()
        view.addSubview(weatherView)
    }
    
    private func setupConstraints() {
        weatherView.autoPinEdge(.top, to: .top, of: self.view)
        weatherView.autoPinEdge(.bottom, to: .bottom, of: self.view)
        weatherView.autoPinEdge(.left, to: .left, of: self.view, withOffset: 10)
        weatherView.autoPinEdge(.right, to: .right, of: self.view, withOffset: -10)
    }
    
    private func setErrorView(with error: Error) {
        errorView.setErrorLabel(with: error)
        view.addSubview(errorView)
        weatherView.tableView.isHidden = true
        errorView.isHidden = false
        
        errorView.autoPinEdge(.top, to: .top, of: self.view)
        errorView.autoPinEdge(.bottom, to: .bottom, of: self.view)
        errorView.autoPinEdge(.left, to: .left, of: self.view)
        errorView.autoPinEdge(.right, to: .right, of: self.view)
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
