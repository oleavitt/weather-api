//
//  URL+Ext.swift
//  WeatherApi
//
//  Created by Oren Leavitt on 12/1/24.
//

import Foundation

extension URL {
    
    /// Helper to build a URL by adding "https" scheme to a given scheme-less URL path and returning a URL if input is valid.
    static func httpsURL(_ from: String?) -> URL? {
        guard let path = from,
              var components = URLComponents(string: path) else {
            return nil
        }
        components.scheme = "https"
        return components.url
    }
}
