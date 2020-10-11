//
//  SceneDelegate.swift
//  Blocky
//
//  Created by Max Chuquimia on 15/9/20.
//  Copyright © 2020 Chuquimian Productions. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let navigationStack = UINavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        navigationStack.viewControllers = [FilterList.ViewController()]
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = navigationStack
        window.makeKeyAndVisible()
        window.tintColor = Color.koamaru
        self.window = window
    }

}

