//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    private let tableView = UITableView()
    private let errorLabel = UILabel()
    private let errorImage = UIImageView()
    private let weatherService = WeatherApiService()
    private let cities = ["Zagreb", "Split", "Osijek", "Rijeka"]
    private var weatherData: [CityWeather] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: Constants.weatherCell)
        setupUI()
        setupConstraints()
        fillTableView()
    }
    
    private func fillTableView() {
        cities.forEach { city in
            weatherService.fetchWeather(for: city, completion: { (weatherResult) in
                self.weatherData.append(weatherResult)
            })
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBlue
        view.addSubview(tableView)
        view.addSubview(errorImage)
        view.addSubview(errorLabel)
        
        errorImage.styleView()
        errorImage.image = UIImage(named: "error-icon")
        errorImage.isHidden = true
        errorImage.layer.cornerRadius = 0
        
        errorLabel.style(size: 25)
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
        tableView.backgroundColor = .systemBlue
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        errorImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        errorImage.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        errorImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        errorImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        errorLabel.topAnchor.constraint(equalTo: errorImage.bottomAnchor, constant: 20).isActive = true
        errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    
    private func setErrorLabel() {
        tableView.isHidden = true
        errorLabel.isHidden = false
        errorImage.isHidden = false
        errorLabel.text = "Error getting data! Please try again."
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.weatherCell, for: indexPath)
            as? WeatherTableViewCell else {
                let cell = WeatherTableViewCell(style: .default, reuseIdentifier: Constants.weatherCell)
                return cell
        }
        if weatherData.count > indexPath.row {
            cell.weather = weatherData[indexPath.row]
        } else {
            setErrorLabel()
        }
        return cell
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = weatherData[indexPath.row]
        let nextViewController = WeatherDetailViewController(with: selectedCity)
        nextViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
