//
//  SceneDelegate.swift
//  ShiftManager
//
//  Created by Sye Boddeus.
//  Copyright © 2020 Deputy. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: scene)

        let viewController = MainSplitViewController()
        let vm = MainSplitViewModel(repo: ModelRepo(), storage: UserDefaults.standard)
        viewController.configure(withViewModel: vm)

        window.rootViewController = viewController

        self.window = window
        window.makeKeyAndVisible()
    }
}

