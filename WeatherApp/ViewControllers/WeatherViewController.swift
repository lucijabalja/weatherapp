//
//  WeatherrViewController.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    let tableView = UITableView()
    let weatherService = WeatherApiService()
    let cities = ["Tunis", "Split", "Sidney", "Dublin"]
    var weatherData: [WeatherData] = []{
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
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        setupUI()
        setupConstraints()
        fillTableView()
    }
    
    func fillTableView() {
        cities.forEach { city in
            weatherService.fetchWeather(for: city, completion: { (weatherResult) in
                self.weatherData.append(weatherResult)
            })
        }
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBlue
        tableView.separatorColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! WeatherTableViewCell
        cell.weather = weatherData[indexPath.row]
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
}
