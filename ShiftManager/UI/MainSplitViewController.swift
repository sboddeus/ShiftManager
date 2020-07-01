//
//  MainSplitViewController.swift
//  ShiftManager
//
//  Created by Sye Boddeus
//  Copyright © 2020 Deputy. All rights reserved.
//

import UIKit

final class MainSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    // MARK: - Views

    lazy var shiftListViewController: UINavigationController = {
        return UINavigationController(rootViewController: ShiftListViewController())
    }()

    lazy var shiftDetailViewController: UINavigationController = {
        return  UINavigationController(rootViewController: ShiftDetailViewController())
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredDisplayMode = .allVisible
        delegate = self
        viewControllers = [shiftListViewController, shiftDetailViewController]
    }

    func primaryViewController(forCollapsing splitViewController: UISplitViewController) -> UIViewController? {
        return shiftListViewController
    }

    // MARK: - View Model

    private var viewModel: MainSplitViewModel?
    func configure(withViewModel vm: MainSplitViewModel) {
        viewModel = vm
        viewModel?.delegate = self

        (shiftListViewController.viewControllers.first as? ShiftListViewController)?.configure(withViewModelProvider: vm.shiftListViewModelProvider)
    }

    // MARK: Split View Delegate
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        true
    }
}

extension MainSplitViewController: MainSplitViewModelDelegate {
    func showDetail() {
        showDetailViewController(shiftDetailViewController, sender: self)
    }

    func udpated(shiftDetailViewModel vm: ShiftDetailViewModel?) {
        (shiftDetailViewController.viewControllers.first as? ShiftDetailViewController)?.configure(withViewModel: vm)
    }

    func showMaster() {
        shiftDetailViewController.navigationController?.popViewController(animated: true)
    }
}
