//
//  ShiftDetailViewModel.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation
import CoreLocation

protocol ShiftDetailViewModelDelegate {
    func end(shift: ShiftRequest)
}

struct ShiftDetailViewModel {

    let kind: ShiftType
    let delegate: ShiftDetailViewModelDelegate

    // MARK: - View Properties
    var title: String? {
        switch kind {
        case let .ongoing(shiftRequest):
            return shiftRequest.title
        case let .ended(shift):
            return shift.title
        }
    }

    var detail: String? {
        switch kind {
        case let .ongoing(shiftRequest):
            return shiftRequest.detail
        case let .ended(shift):
            return shift.detail
        }
    }

    var button: String? {
        switch kind {
        case .ongoing:
            return "End"
        case .ended:
            return nil
        }
    }

    var image: URL? {
        switch kind {
        case .ongoing:
            return nil
        case let .ended(shift):
            return shift.image
        }
    }

    var endLocation: CLLocationCoordinate2D? {
        switch kind {
        case .ongoing:
            return nil
        case let .ended(shift):
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(shift.endLatitude) ?? 0), longitude: CLLocationDegrees(Double(shift.endLongitude) ?? 0))
        }
    }

    var startLocation: CLLocationCoordinate2D? {
        switch kind {
        case let .ongoing(shiftRequest):
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(shiftRequest.latitude) ?? 0), longitude: CLLocationDegrees(Double(shiftRequest.longitude) ?? 0))
        case let .ended(shift):
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(Double(shift.startLatitude) ?? 0), longitude: CLLocationDegrees(Double(shift.startLongitude) ?? 0))
        }
    }

    func end() {
        switch kind {
        case let .ongoing(shift):
            delegate.end(shift: shift)
        case .ended:
            break
        }
    }
}

// MARK: - Formatting Helpers

extension ShiftRequest {
    var title: String {
        return "Current Shift"
    }

    var detail: String {
        return "Started: \(time.humanReadableDate ?? "")"
    }
}

extension Shift {
    var title: String {
        return "Started: \(start.humanReadableDate ?? "")"
    }

    var detail: String {
        return "Ended: \(end.humanReadableDate ?? "")"
    }
}

extension String {
    var humanReadableDate: String? {
        guard let date = DateFormats.iso8601.date(from: self) else { return nil }
        return DateFormats.humanReadable.string(from: date)
    }
}
