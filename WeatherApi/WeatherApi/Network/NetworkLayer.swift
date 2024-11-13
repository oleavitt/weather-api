//
//  NetworkLayer.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/31/24.
//

import Foundation
import Combine

protocol NetworkLayer {
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T
}

class NetworkLayerImpl: NetworkLayer {
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) -> Future<T, Error> {
        Future<T, Error> { promise in
#if DEBUG
            print(request.url?.absoluteString ?? "")
#endif
            URLSession.shared.dataTaskPublisher(for: request)
                .retry(1)
                .tryMap { (data, response) -> Data in
#if DEBUG
                    if let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted),
                           let strData = String(data: jsonData, encoding: .utf8) {
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
                .sink {
                    if case let .failure(error) = $0 {
                        promise(.failure(error))
                    }
                } receiveValue: {
                    promise(.success($0))
                }
                .store(in: &self.cancellables)
        }
    }
    
    func fetchJsonData<T: Decodable>(request: URLRequest, type: T.Type) async throws -> T {
        let response = try await URLSession.shared.data(for: request)
        let data = response.0
        
#if DEBUG
        if let responseObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: responseObject, options: .prettyPrinted),
               let strData = String(data: jsonData, encoding: .utf8) {
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
        
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
}
