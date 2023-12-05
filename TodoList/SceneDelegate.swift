//
//  SceneDelegate.swift

import UIKit
import TaskManagerPackage

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let scene = (scene as? UIWindowScene) else { return }
		let window = UIWindow(windowScene: scene)

		let navigationController = UINavigationController()
		let assemblyBuilder = AssemblyBuilder()
		let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
		router.showLogin()

		window.rootViewController = navigationController
		window.makeKeyAndVisible()

		self.window = window
	}
}
