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
	func showNewTask()
	func returnToTodoList()
}

class Router: IRouterProtocol {

	// MARK: - Dependencies
	var navigationController: UINavigationController?
	var assemblyBuilder: IAssemblyBuilder?
	var taskManager: ITaskManager

	// MARK: - Initialization
	init(navigationController: UINavigationController, assemblyBuilder: IAssemblyBuilder, taskManager: ITaskManager) {
		self.navigationController = navigationController
		self.assemblyBuilder = assemblyBuilder
		self.taskManager = taskManager
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
			guard let todoListController = assemblyBuilder?.assemblyTodoList(
				router: self,
				taskManager: taskManager
			) else { return }
			navigationController.pushViewController(todoListController, animated: true)
		}
	}

	func showNewTask() {
		if let navigationController = navigationController {
			guard let newTaskController = assemblyBuilder?.assemblyNewTask(
				router: self,
				taskManager: taskManager
			) else { return }
			navigationController.pushViewController(newTaskController, animated: true)
		}
	}

	func returnToTodoList() {
		navigationController?.popViewController(animated: true)
	}
}
