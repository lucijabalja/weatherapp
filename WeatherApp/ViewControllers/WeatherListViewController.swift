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
import PureLayout

class WeatherListViewController: UIViewController {
    
    private var searchBar = UISearchBar()
    private var weatherViewModel: WeatherListViewModel!
    private let disposeBag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private var spinner = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()
    
    init(with weatherViewModel: WeatherListViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.weatherViewModel = weatherViewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupRefreshControl()
        setupTableView()
        
        bindSpinnerIndicator()
        bindTableView()
        bindSearchBar()
        weatherViewModel.refreshData.onNext(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showSearchBar))
    }
    
    private func setupTableView() {
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
    }
    
    private func bindTableView() {
        weatherViewModel
            .currentWeatherList
            .bind(to: tableView.rx.items(cellIdentifier: WeatherTableViewCell.identifier, cellType: WeatherTableViewCell.self)) { [weak self] (row, currentWeather, cell) in
                guard let self = self else { return }
                
                self.endRefreshing()
                cell.setup(currentWeather)
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherViewModel.modelSelected.onNext(currentWeather)
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
                self.weatherViewModel.searchText.accept(city)
                self.weatherViewModel.refreshData.onNext(())
            }
            self.searchBar.resignFirstResponder()
            self.searchBar.text = ""
        }).disposed(by: disposeBag)
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
    
    private func bindSpinnerIndicator() {
        weatherViewModel
            .showLoading
            .asObservable()
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    private func endRefreshing() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
}

// MARK:- Refresh Control setup

extension WeatherListViewController {
    
    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
        
        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .bind(to: weatherViewModel.refreshData)
            .disposed(by: disposeBag)
    }
    
}

// MARK:- TableViewDelegate setup

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

// MARK:- Setup UI

extension WeatherListViewController {
    
    private func setupUI() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = false
        
        spinner.frame = view.frame
    }
    
    private func setupConstraints() {
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        
        view.addSubview(spinner)
        spinner.autoAlignAxis(toSuperviewAxis: .horizontal)
        spinner.autoAlignAxis(toSuperviewAxis: .vertical)
    }
    
    private func setAlert(with error: Error) {
        let alert = UIAlertController(title: ErrorMessage.noInternetConnection,
                                      message: ErrorMessage.turnInternetConnection, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
}
