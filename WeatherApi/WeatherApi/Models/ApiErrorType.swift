//
//  ApiErrorType.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/12/24.
//

import Foundation

enum ApiErrorType: Error {
    case noMatch
    case emptySearch
    case genericError
}

extension ApiErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noMatch:
            return NSLocalizedString("error-no-match", comment: "")
        case .emptySearch:
            return NSLocalizedString("error-empty-search", comment: "")
        case .genericError:
            return NSLocalizedString("error-unknown", comment: "")
        }
    }
}
