//
//  SceneDelegate.swift
//  AvitoInternship
//
//  Created by Владимир on 07.09.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        window.rootViewController = SearchViewController()
        self.window = window
        window.makeKeyAndVisible()
        
    }
    
}

