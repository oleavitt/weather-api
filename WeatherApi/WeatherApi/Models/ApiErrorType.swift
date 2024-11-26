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
    case networkError
    case genericError
    
    static func fromErrorCode(code: Int) -> ApiErrorType {
        switch code {
        case 1003: return .emptySearch
        case 1006: return .noMatch
        default: return .genericError
        }
    }
}

extension ApiErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noMatch:
            return NSLocalizedString("error-no-match", comment: "")
        case .emptySearch:
            return NSLocalizedString("error-empty-search", comment: "")
        case .networkError:
            return NSLocalizedString("error-network", comment: "")
        case .genericError:
            return NSLocalizedString("error-unknown", comment: "")
        }
    }
}
