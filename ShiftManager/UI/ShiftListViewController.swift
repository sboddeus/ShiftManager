//
//  ViewController.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

final class ShiftListViewController: UIViewController, ShiftListViewModelProviderDelegate {

    static let tableViewCellReuseId = "TableViewCell"

    // MARK: - Properties and Views
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .plain)
    }()

    lazy var button: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(startShift(_:)))
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        buildViews()
        buildLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModelProvider?.refresh()
    }

    // MARK: - Building Views and Layout
    func buildViews() {
        // Navigation Bar
        navigationItem.rightBarButtonItem = button

        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: ShiftListViewController.tableViewCellReuseId)
        view.addSubview(tableView)
    }

    func buildLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: View Model
    var viewModel: ShiftListViewModel?
    var viewModelProvider: ShiftListViewModelProvider?
    func configure(withViewModelProvider vmp: ShiftListViewModelProvider) {
        self.viewModelProvider = vmp
        self.viewModelProvider?.delegate = self
        self.viewModelProvider?.refresh()
    }

    private func configure(withViewModel vm: ShiftListViewModel) {
        viewModel = vm
        button.isEnabled = !vm.startShiftDisabled
        tableView.reloadData()
    }

    // MARK: - View Model Provider Delegate
    func updated(viewState: ViewState<ShiftListViewModel>) {
        switch viewState.state {
        case let .success(vm):
            configure(withViewModel: vm)
        case .loading:
            // TODO show loading state
            break
        case .error:
            // TODO: Show error state
            break
        }
    }

    // MARK: - Actions
    @objc
    func startShift(_ sender: Any?) {
        viewModel?.startedNewShift()
    }
}

// MARK: - Table View Management

extension ShiftListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.shifts.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let shift = viewModel?.shifts[indexPath.row] else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: ShiftListViewController.tableViewCellReuseId, for: indexPath)

        cell.configure(withShift: shift)

        return cell
    }
}

extension ShiftListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selected(shift: indexPath.row)
    }
}

// MARK: Helpers

extension UITableViewCell {
    func configure(withShift shift: ShiftType) {
        switch shift {
        case let .ongoing(shift):
            textLabel?.text = shift.title
            detailTextLabel?.text = shift.detail
            imageView?.sd_setImage(with: nil)
        case let .ended(shift):
            textLabel?.text = shift.title
            detailTextLabel?.text = shift.detail
            imageView?.sd_setImage(with: shift.image)
        }
    }
}
