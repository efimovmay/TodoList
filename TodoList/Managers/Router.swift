//
//  Router.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//

import UIKit
import TaskManagerPackage

protocol IRouterProtocol: AnyObject {

	/// Переход к экрану логина.
	func showLogin()

	/// Переход к списку задач.
	func showTodoList()

	/// Переход к созданию нового задания.
	func showNewTask()

	/// Возврат на список заданий.
	func returnToTodoList()
}

final class Router: IRouterProtocol {

	// MARK: - Dependencies
	private let navigationController: UINavigationController
	private let assemblyBuilder: IAssemblyBuilder
	private let taskManager: ITaskManager

	// MARK: - Initialization
	init(navigationController: UINavigationController, assemblyBuilder: IAssemblyBuilder, taskManager: ITaskManager) {
		self.navigationController = navigationController
		self.assemblyBuilder = assemblyBuilder
		self.taskManager = taskManager
	}

	// MARK: - Public methods
	func showLogin() {
		let loginViewController = assemblyBuilder.assemblyLogin(router: self)
		navigationController.viewControllers = [loginViewController]
	}

	func showTodoList() {
		let todoListController = assemblyBuilder.assemblyTodoList(taskManager: taskManager, router: self)
		navigationController.pushViewController(todoListController, animated: true)
	}

	func showNewTask() {
		let newTaskController = assemblyBuilder.assemblyNewTask(router: self, taskManager: taskManager)
		navigationController.pushViewController(newTaskController, animated: true)
	}

	func returnToTodoList() {
		navigationController.popViewController(animated: true)
	}
}
