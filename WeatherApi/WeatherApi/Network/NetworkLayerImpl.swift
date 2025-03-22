//
//  NetworkLayerImpl.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 3/21/25.
//

import Foundation
import Combine

/// Sends requests to the live API site and gets back live data.
class NetworkLayerImpl: NetworkLayer {

    /// Data publisher to perform network request and decode JSON for any Decodable object type.
    /// - Parameters:
    ///   - request: URL request configured with endpoint and any needed headers.
    ///   - type: Type of Decodable object we are to decode.
    /// - Returns: A publisher from which to sink successful type object or Error result from.
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
