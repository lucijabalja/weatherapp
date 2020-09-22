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
    
}
