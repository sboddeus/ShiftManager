//
//  MainSplitViewModel.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation
import CoreLocation

protocol MainSplitViewModelDelegate: class {
    func udpated(shiftDetailViewModel: ShiftDetailViewModel?)
    func showDetail()
    func showMaster()
}

final class MainSplitViewModel {

    var shiftListViewModelProvider: ShiftListViewModelProvider
    weak var delegate: MainSplitViewModelDelegate?

    private var repo: ModelRepo
    private var storage: CurrentShiftStorage
    private let locationManager: CLLocationManager

    init(repo: ModelRepo = ModelRepo(),
         storage: CurrentShiftStorage = UserDefaults.standard) {
        self.shiftListViewModelProvider = ShiftListViewModelProvider(modelRepo: repo)
        self.repo = repo
        self.storage = storage

        // Setup location manager
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Set subordinate delegate
        shiftListViewModelProvider.actionDelegate = self
    }

    func showDetail() {
        delegate?.showDetail()
    }

    func showMaster() {
        delegate?.showMaster()
    }
}

// MARK: - Delgates

extension MainSplitViewModel: ShiftListViewModelProviderActionDelegate {
    func startedNewShift() {
        let startDate =  DateFormats.iso8601.string(from: Date())
        var longitude = "0.0"
        var latitude = "0.0"
        if let location = locationManager.location?.coordinate {
            longitude = "\(location.longitude)"
            latitude = "\(location.latitude)"
        } else {
            // TODO: Surface error to user
        }
        let request = ShiftRequest(time: startDate, latitude: latitude, longitude: longitude)
        repo.start(shift: request) { [weak self] result in
            switch result {
            case .success:
                self?.storage.set(currentShift: request)
                self?.shiftListViewModelProvider.refresh()
            case .failure:
                // TODO: Surface error to user
                break
            }
        }
    }

    func selected(shift: ShiftType) {
        showDetail()
        delegate?.udpated(shiftDetailViewModel: ShiftDetailViewModel(kind: shift, delegate: self))
    }
}

extension MainSplitViewModel: ShiftDetailViewModelDelegate {
    func end(shift: ShiftRequest) {
        let startDate =  DateFormats.iso8601.string(from: Date())
        var longitude = "0.0"
        var latitude = "0.0"
        if let location = locationManager.location?.coordinate {
            longitude = "\(location.longitude)"
            latitude = "\(location.latitude)"
        } else {
            // TODO: Surface error to user
        }
        let request = ShiftRequest(time: startDate, latitude: latitude, longitude: longitude)

        repo.end(shift: request) { [weak self] result in
            switch result {
            case .success:
                self?.storage.set(currentShift: nil)
                self?.delegate?.udpated(shiftDetailViewModel: nil)
                self?.shiftListViewModelProvider.refresh()
                self?.showMaster()
            case .failure:
                // TODO: Surface error to user
                break
            }
        }
    }
}
