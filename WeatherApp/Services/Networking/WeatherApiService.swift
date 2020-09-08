//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherApiService {
    
    private let baseURL = "https://api.openweathermap.org/data/2.5"
    private let apiKey = "appid=56151fef235e6cebb33750525932d021"
    private let units = "units=metric"
    private let exclusions = "exclude=minutely"
    private let parsingService: ParsingService
    
    init(parsingService: ParsingService) {
        self.parsingService = parsingService
    }
    
    func fetchData<T: Decodable>(urlString: String) -> Observable<Result<T, NetworkError>> {
        guard let url = URL(string: urlString) else {
            return Observable.just(.failure(.invalidURLError))
        }
        
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.response(request: request).flatMap { (response, data) -> Observable<Result<T, NetworkError>> in
            if response.statusCode != 200 {
                return Observable.just(.failure(.URLSessionError))
            }
            do {
                let values = try JSONDecoder().decode(T.self, from: data)
                return Observable.just(.success(values))
            } catch {
                return Observable.just(.failure(.decodingError))
            }
        }.catchError { (_) -> Observable<Result<T, NetworkError>> in
            return Observable.just(.failure(.URLSessionError))
        }
    }
    
    private func performRequest(with urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURLError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let _ = error {
                completion(.failure(.URLSessionError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unwrappingError))
                return
            }
            
            completion(.success(data))
        })
        task.resume()
    }
    
}

extension WeatherApiService: WeatherDetailServiceProtocol {
    
    func fetchWeeklyWeather(with latitude: Double,_ longitude: Double, completion: @escaping (Result<WeeklyWeatherResponse, NetworkError>) -> Void) {
        
        let urlString = "\(baseURL)/onecall?\(apiKey)&\(units)&lat=\(latitude)&lon=\(longitude)&\(exclusions)"
        
        performRequest(with: urlString) { [weak self] (result) in
            
            switch result {
            case .success(let data):
                let parsedResponse = self?.parsingService.parseWeeklyWeather(data)
                
                guard let weeklyWeather = parsedResponse else {
                    completion(.failure(.decodingError))
                    return
                }
                
                completion(.success(weeklyWeather))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
