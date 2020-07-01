//
//  ShiftListViewModel.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import Foundation

protocol ShiftListViewModelProviderDelegate: class {
    func updated(viewState: ViewState<ShiftListViewModel>)
}

protocol ShiftListViewModelProviderActionDelegate: class {
    func startedNewShift()
    func selected(shift: ShiftType)
}

final class ShiftListViewModelProvider {
    weak var delegate: ShiftListViewModelProviderDelegate?
    weak var actionDelegate: ShiftListViewModelProviderActionDelegate?

    let currentShiftStorage: CurrentShiftStorage
    let modelRepo: ModelRepo

    init(currentShiftStorage: CurrentShiftStorage = UserDefaults.standard,
         modelRepo: ModelRepo) {
        self.modelRepo = modelRepo
        self.currentShiftStorage = currentShiftStorage
    }

    func refresh() {
        delegate?.updated(viewState: ViewState(state: .loading))
        modelRepo.getAllShifts { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case let .success(remoteShifts):
                var shifts = remoteShifts.map { ShiftType.ended($0) }
                if let local = self.currentShiftStorage.getCurrentShift() {
                    shifts = [ShiftType.ongoing(local)] + shifts
                }
                self.delegate?.updated(viewState: ViewState(state: .success(ShiftListViewModel(shifts: shifts, delegate: self))))
            case let .failure(error):
                self.delegate?.updated(viewState: ViewState(state: .error(error)))
            }
        }
    }
}

extension ShiftListViewModelProvider: ShiftListViewModelDelegate {
    func startedNewShift() {
        actionDelegate?.startedNewShift()
    }

    func selected(shift: ShiftType) {
        actionDelegate?.selected(shift: shift)
    }
}

protocol ShiftListViewModelDelegate: class {
    func startedNewShift()
    func selected(shift: ShiftType)
}

struct ShiftListViewModel {
    let shifts: [ShiftType]
    let delegate: ShiftListViewModelDelegate

    var startShiftDisabled: Bool {
        return shifts.contains { (type) -> Bool in
            switch type {
            case .ongoing: return true
            default: return false
            }
        }
    }

    func startedNewShift() {
        delegate.startedNewShift()
    }
    
    func selected(shift index: Int){
        delegate.selected(shift: shifts[index])
    }
}
