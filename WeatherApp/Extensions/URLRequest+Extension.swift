//
//  URLRequest+Extension.swift
//  WeatherApp
//
//  Created by William Tomas on 01/10/2019.
//  Copyright © 2019 William Tomas. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    static func load<T: Decodable>(resource: Resource<T>) -> Observable<T> {
        return Observable.from([resource.url])
            .flatMap { url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
        }.asObservable()
    }
}
