//
//  NetworkLayer.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/31/24.
//

import Foundation
import Combine

/// Abstracted networking layer interface
protocol NetworkLayer {
    func fetchJsonDataPublisher<T: Decodable>(request: URLRequest, type: T.Type) -> AnyPublisher<T, Error>
}
