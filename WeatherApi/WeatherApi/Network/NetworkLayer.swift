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

/// Sends requests to the live API site and gets back live data.
class NetworkLayerImpl: NetworkLayer {

    func fetchJsonDataPublisher<T: Decodable>(request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> {
#if DEBUG
        print(request.url?.absoluteString ?? "")
#endif
        return URLSession.shared.dataTaskPublisher(for: request)
            .retry(1)
            .tryMap { (data, _) -> Data in
#if DEBUG
                if let responseObject = try? JSONSerialization.jsonObject(
                    with: data,
                    options: .allowFragments
                ) {
                    if let jsonData = try? JSONSerialization.data(
                        withJSONObject: responseObject,
                        options: .prettyPrinted
                    ), let strData = String(data: jsonData, encoding: .utf8) {
                        print("RESPONSE (JSON): \(strData)")
                    } else {
                        print("RESPONSE (OBJECT): ", responseObject)
                    }
                } else  if let strData = String(data: data, encoding: .utf8) {
                    print("RESPONSE (OTHER): \(strData)")
                } else {
                    print("RESPONSE: None")
                }
#endif
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
