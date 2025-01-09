//
//  LoadingState.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/1/24.
//

import Foundation

/// Used to update view during the loading progress of an async API call.
public enum LoadingState<T> {
    case startup
    case empty
    case loading
    case success(T)
    case failure(Error)
}
