//
//  Constants.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation

struct LayoutConstants {
    static let inset = 20.0
}

struct NetworkingConstants {
    static let baseURL = "https://apjoqdqpi3.execute-api.us-west-2.amazonaws.com/dmc"
    static let contentKey = "Content-Type"
    static let contentValue = "application/json"
    // NOTE: In a real app I would expect this API key to be stored in a secret repo
    static let authHeaderValue = "Deputy af972891213a6a0818331a004f2cba5a7f194c2d"
    static let authHeaderKey = "Authorization"
}

struct DateFormats {
    static var iso8601: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmssZ"
        return dateFormatter
    }()

    static var humanReadable: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd-MM-yyyy"
        return dateFormatter
    }()
}
