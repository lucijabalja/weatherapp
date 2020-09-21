//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RxCocoa
import PureLayout

class WeatherListViewController: UIViewController {
    
    private var weatherViewModel: WeatherListViewModel!
    private var disposeBag = DisposeBag()
    private var loadingDisposeBag = DisposeBag()
    private var refreshDisposeBag = DisposeBag()
    private var timerDisposeBag = DisposeBag()
    private var timerPeriod = 600
    
    // UI variables
    private var searchBar = UISearchBar()
    private let refreshControl = UIRefreshControl()
    private var spinner = UIActivityIndicatorView(style: .large)
    private var editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
    private var searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    private let tableView = UITableView()
    
    // datasource
    typealias CurrentWeatherSectionModel = AnimatableSectionModel<String, CurrentWeather>
    private var dataSource: RxTableViewSectionedAnimatedDataSource<CurrentWeatherSectionModel>!
    
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
        setupTableView()
        
        createDataSource()
        createTimer()
        bindViewModel()
        
        weatherViewModel.refreshData.onNext(())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setupGradientBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.leftBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem = editBarButton
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    private func createTimer() {
        timerDisposeBag = DisposeBag()
        
        Observable<Int>
            .timer(.seconds(0), period: .seconds(timerPeriod), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.weatherViewModel.refreshData.onNext(())
            })
            .disposed(by: timerDisposeBag)
    }
    
}

// MARK:- Data source
extension WeatherListViewController {
    
    private func createDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<CurrentWeatherSectionModel>(
            animationConfiguration: AnimationConfiguration(
                insertAnimation: .right,
                reloadAnimation: .none,
                deleteAnimation: .left),
            configureCell: configureCell,
            canEditRowAtIndexPath: canEditRowAtIndexPath,
            canMoveRowAtIndexPath: canMoveRowAtIndexPath)
    }
    
    private var configureCell: RxTableViewSectionedAnimatedDataSource<CurrentWeatherSectionModel>.ConfigureCell {
        return { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.identifier, for: indexPath) as! WeatherTableViewCell
            cell.setup(item)
            self.refreshControl.endRefreshing()
            return cell
        }
    }
    
    private var canEditRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<CurrentWeatherSectionModel>.CanEditRowAtIndexPath {
        return { [unowned self] _, _ in
            if self.tableView.isEditing {
                return true
            } else {
                return false
            }
        }
    }
    
    private var canMoveRowAtIndexPath: RxTableViewSectionedAnimatedDataSource<CurrentWeatherSectionModel>.CanMoveRowAtIndexPath {
        return { _, _ in
            return true
        }
    }
}
// MARK:- Bindings

extension WeatherListViewController {
    
    func bindViewModel() {
        bindTableView()
        bindSearchBar()
        bindSpinnerIndicator()
        bindRefreshControl()
        bindEditButton()
        bindSearchButton()
    }
    
    private func bindTableView() {
        disposeBag = DisposeBag()
        
        weatherViewModel.currentWeatherData
            .map{ [CurrentWeatherSectionModel(model: "", items: $0) ]}
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .modelSelected(CurrentWeather.self)
            .subscribe(
                onNext: { [weak self] (currentWeather) in
                    guard let self = self else { return }
                    
                    self.weatherViewModel.modelSelected.onNext(currentWeather)
                    if let index = self.tableView.indexPathForSelectedRow {
                        self.tableView.deselectRow(at: index, animated: true)
                    }
            }).disposed(by: disposeBag)
        
        tableView
            .rx
            .modelDeleted(CurrentWeather.self)
            .asDriver()
            .drive(onNext: { (currentWeather) in
                self.weatherViewModel.removeCurrentWeather(with: currentWeather.city)
                self.weatherViewModel.refreshData.onNext(())
            })
            .disposed(by: disposeBag)
        
    }
    
    private func bindSearchBar() {
        searchBar
            .rx
            .cancelButtonClicked
            .subscribe(onNext: { [weak self] (_)  in
                guard let self = self else { return }
                
                self.search(shouldShow: false)
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        searchBar
            .rx
            .searchButtonClicked
            .subscribe(onNext: { [weak self] (_) in
                guard let self = self else { return }
                
                if let city = self.searchBar.text {
                    self.weatherViewModel.searchText.accept(city)
                }
                self.weatherViewModel.refreshData.onNext(())
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSpinnerIndicator() {
        weatherViewModel
            .showLoading
            .asObservable()
            .bind(to: spinner.rx.isAnimating)
            .disposed(by: loadingDisposeBag)
    }
    
    private func bindRefreshControl() {
        tableView.refreshControl = refreshControl

        refreshControl
            .rx
            .controlEvent(.valueChanged)
            .bind(to: weatherViewModel.refreshData)
            .disposed(by: refreshDisposeBag)
    }
    
    private func bindEditButton() {
        editBarButton
            .rx
            .tap
            .asDriver()
            .map { [unowned self] in self.tableView.isEditing }
            .drive(onNext: { [unowned self] result in
                self.tableView.setEditing(!result, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSearchButton() {
        searchBarButton
            .rx
            .tap
            .asDriver()
            .map { [unowned self] in self.tableView.isEditing }
            .drive(onNext: { [unowned self] result in
                self.showSearchBar()
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK:- UI Setup

extension WeatherListViewController {
    
    func showSearchBar() {
        search(shouldShow: true)
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    private func search(shouldShow: Bool) {
        searchBar.isHidden = !shouldShow
        searchBar.showsCancelButton = shouldShow
        navigationItem.leftBarButtonItem = shouldShow ? nil : searchBarButton
        navigationItem.rightBarButtonItem = shouldShow ? nil : editBarButton
    }
}

// MARK:- TableView setup

extension WeatherListViewController {
    
    private func setupTableView() {
        tableView.rowHeight = WeatherTableViewCell.height
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: WeatherTableViewCell.identifier)
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
    
}
