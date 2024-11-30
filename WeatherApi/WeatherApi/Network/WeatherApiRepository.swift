//
//  WeatherApiRepository.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 10/23/24.
//

import Foundation
import Combine

protocol WeatherApiRepository {
    var currentPublisher: CurrentValueSubject<LoadingState<[ApiModel]>, Never> { get }
    func loadCurrent() async
}
