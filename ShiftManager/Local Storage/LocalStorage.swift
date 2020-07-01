//
//  LocalStorage.swift
//  ShiftManager
//
//  Created by Sye Boddeus on 1/7/20.
//  Copyright © 2020 Deputy. All rights reserved.
//

import UIKit

protocol CurrentShiftStorage {
    func getCurrentShift() -> ShiftRequest?
    func set(currentShift: ShiftRequest?)
}

extension UserDefaults: CurrentShiftStorage {
    static let shiftKey = "com.deputy.currentshift"
    func getCurrentShift() -> ShiftRequest? {
        guard let data = value(forKey: UserDefaults.shiftKey) as? Data,
        let shift = try? JSONDecoder().decode(ShiftRequest.self, from: data) else {
            return nil
        }

        return shift
    }

    func set(currentShift: ShiftRequest?) {
        if let shift = currentShift {
            let data = try? JSONEncoder().encode(shift)
            set(data, forKey: UserDefaults.shiftKey)
        } else {
            set(nil, forKey: UserDefaults.shiftKey)
        }
    }
}
