//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Lucija Balja on 03/08/2020.
//  Copyright © 2020 Lucija Balja. All rights reserved.
//

import Foundation
import RxSwift

class WeatherApiService {
    
    func fetchData<T: Decodable>(urlString: String) -> Observable<T> {
        return Observable<T>.create { observer in
            
            guard let url = URL(string: urlString) else { return Disposables.create()}
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                do {
                    let values = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(values)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create()
        }
    }
    
}
