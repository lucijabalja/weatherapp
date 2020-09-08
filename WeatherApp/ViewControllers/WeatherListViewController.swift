//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class WeatherListViewController: UIViewController {
    
    private let weatherView = WeatherListView()
    private let errorView = ErrorView()
    private var searchBar = UISearchBar()
    private var weatherViewModel: WeatherListViewModel!
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    
    init(with weatherViewModel: WeatherListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherViewModel = weatherViewModel
        bindTableView()
        bindSearchBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        setupUI()
        setupConstraints()
        setupTableView()
        setupLocationAccessRights()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    private func setupTableView() {
        weatherView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        weatherView.tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func bindTableView() {
        weatherViewModel.currentWeatherList.bind(to: weatherView.tableView.rx.items(cellIdentifier: WeatherTableViewCell.identifier, cellType: WeatherTableViewCell.self)) { (row, currentWeather, cell) in
            cell.setup(currentWeather)
        }.disposed(by: disposeBag)
        
        weatherView.tableView.rx.modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherViewModel.pushToDetailView(with: currentWeather)
            }).disposed(by: disposeBag)
    }
    
    private func bindSearchBar() {
        searchBar.rx.cancelButtonClicked.subscribe(onNext: { [weak self] (_)  in
            guard let self = self else { return }

            self.search(shouldShow: false)
            self.searchBar.resignFirstResponder()
        }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] (_) in
            guard let self = self else { return }

            if let city = self.searchBar.text {
                self.weatherViewModel.getCurrentWeather(for: city)
            }
            self.searchBar.resignFirstResponder()
            self.searchBar.text = ""
        }).disposed(by: disposeBag)
    }
    
}

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
}

extension WeatherListViewController: CLLocationManagerDelegate {
    
    private func setupLocationAccessRights() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
}

// MARK:- UI Setup

extension WeatherListViewController {
    
    @objc func showSearchBar() {
        search(shouldShow: true)
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    private func search(shouldShow: Bool) {
        searchBar.isHidden = !shouldShow
        searchBar.showsCancelButton = shouldShow
        navigationItem.rightBarButtonItem = shouldShow ? nil : UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
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
