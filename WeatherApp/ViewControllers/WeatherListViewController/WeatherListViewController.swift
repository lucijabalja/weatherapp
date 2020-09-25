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

final class WeatherListViewController: UIViewController {
    
    private var weatherViewModel: WeatherListViewModel!
    private var disposeBag = DisposeBag()
    private var loadingDisposeBag = DisposeBag()
    private var timerDisposeBag = DisposeBag()
    private var timerPeriod = 600
    
    // UI variables
    var searchBar = UISearchBar()
    let refreshControl = UIRefreshControl()
    var spinner = UIActivityIndicatorView(style: .large)
    var editBarButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
    var searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
    let tableView = UITableView()
    
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
        search(shouldShow: false)
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
                insertAnimation: .fade,
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
            .observeOn(MainScheduler.instance)
            .map{ [CurrentWeatherSectionModel(model: "", items: $0) ]}
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
            })
            .disposed(by: disposeBag)
        
        tableView
            .rx
            .itemMoved
            .asDriver()
            .drive { [weak self] (sourceIndex, destinationIndex) in
                guard sourceIndex != destinationIndex else { return }
               
                guard let self = self else { return }

                self.weatherViewModel.reorderCurrentWeatherList(sourceIndex.row, destinationIndex.row)
            }.disposed(by: disposeBag)
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
            .observeOn(MainScheduler.instance)
            .bind(to: weatherViewModel.refreshData)
            .disposed(by: disposeBag)
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
