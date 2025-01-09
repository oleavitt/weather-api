//
//  ApiErrorType.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 11/12/24.
//

import Foundation

/// Enum for mapping API error codes to message text.
enum ApiErrorType: Error {
    case noMatch
    case emptySearch
    case networkError
    case genericError
    case noApiKey
    case invalidApiKey

    static func fromErrorCode(code: Int) -> ApiErrorType {
        switch code {
        case 1003: return .emptySearch
        case 1006: return .noMatch
        case 2000..<3000: return .invalidApiKey
        default: return .genericError
        }
    }
}

extension ApiErrorType: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noMatch:
            return String(localized: "error-no-match")
        case .emptySearch:
            return String(localized: "error-empty-search")
        case .networkError:
            return String(localized: "error-network")
        case .genericError:
            return String(localized: "error-unknown")
        case .noApiKey:
            return String(localized: "error-no-api-key")
        case .invalidApiKey:
            return String(localized: "error-invalid-api-key")
        }
    }
}
