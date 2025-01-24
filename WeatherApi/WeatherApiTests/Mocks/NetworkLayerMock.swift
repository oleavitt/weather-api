//
//  NetworkLayerMock.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/12/24.
//


import Foundation
import Combine
@testable import WeatherApi

/// Returns mock response data for unit tests.
class NetworkLayerMock: NetworkLayer {
    private let data: Data

    init(jsonData: Data) {
        self.data = jsonData
    }
    
    func fetchJsonDataPublisher<T: Decodable>(request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> {
        return Just(data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
