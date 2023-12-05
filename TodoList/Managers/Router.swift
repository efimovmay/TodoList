//
//  Router.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//

import UIKit
import TaskManagerPackage

protocol IRouterMain {
	var navigationController: UINavigationController? { get set }
	var assemblyBuilder: IAssemblyBuilder? { get set }
}

protocol IRouterProtocol: IRouterMain {
	func showLogin()
	func showTodoList()
	func showTodoList(taskManager: ITaskManager)
	func showNewTask(taskManager: ITaskManager)
}

class Router: IRouterProtocol {

	// MARK: - Dependencies
	var navigationController: UINavigationController?
	var assemblyBuilder: IAssemblyBuilder?

	// MARK: - Initialization
	init(navigationController: UINavigationController, assemblyBuilder: IAssemblyBuilder) {
		self.navigationController = navigationController
		self.assemblyBuilder = assemblyBuilder
	}

	// MARK: - Public methods
	func showLogin() {
		if let navigationController = navigationController {
			guard let loginViewController = assemblyBuilder?.assemblyLogin(router: self) else { return }
			navigationController.viewControllers = [loginViewController]
		}
	}

	func showTodoList() {
		if let navigationController = navigationController {
			guard let todoListController = assemblyBuilder?.assemblyTodoList(router: self) else { return }
			navigationController.pushViewController(todoListController, animated: true)
		}
	}

	func showTodoList(taskManager: ITaskManager) {
		if let navigationController = navigationController {
			guard let todoListController = assemblyBuilder?.assemblyTodoList(
				router: self,
				taskManager: taskManager
			) else { return }
			navigationController.pushViewController(todoListController, animated: true)
		}
	}

	func showNewTask(taskManager: ITaskManager) {
		if let navigationController = navigationController {
			guard let newTaskController = assemblyBuilder?.assemblyNewTask(
				router: self,
				taskManager: taskManager
			) else { return }
			navigationController.pushViewController(newTaskController, animated: true)
		}
	}
}
