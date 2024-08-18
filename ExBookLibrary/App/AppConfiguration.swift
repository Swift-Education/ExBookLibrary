//
//  AppConfiguration.swift
//  ExBookLibrary
//
//  Created by 강동영 on 8/19/24.
//

import Foundation

final class AppConfiguration {
    lazy var apiKey: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must not be empty in plist")
        }
        return apiKey
    }()
}
