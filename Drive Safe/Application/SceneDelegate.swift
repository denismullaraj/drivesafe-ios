//
//  SceneDelegate.swift
//  Drive Safe
//
//  Created by Denis Mullaraj on 29.8.22.
//  Copyright © 2022 dmullaraj. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private lazy var container = DependencyContainer()
    
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        self.window = UIWindow(windowScene: windowScene)

        window?.rootViewController = UINavigationController(rootViewController: container.makeHomeViewController())
        
        window?.makeKeyAndVisible()
    }
}

