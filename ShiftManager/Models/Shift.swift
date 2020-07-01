//
//  Shift.swift
//  ShiftManager
//
//  Created by Sye Boddeus
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation

enum ShiftType {
    case ongoing(ShiftRequest)
    case ended(Shift)
}

struct Shift: Codable {
    let id: Int
    let start: String
    let end: String
    let startLatitude: String
    let endLatitude: String
    let startLongitude: String
    let endLongitude: String
    let image: URL
}

struct ShiftRequest: Codable {
    let time: String
    let latitude: String
    let longitude: String
}
