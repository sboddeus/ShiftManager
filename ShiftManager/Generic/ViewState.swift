//
//  ViewState.swift
//  ShiftManager
//
//  Created by Sye Boddeus
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation

struct ViewState<T> {
    enum State {
        case loading
        case error(Error)
        case success(T)
    }

    let state: State
}
