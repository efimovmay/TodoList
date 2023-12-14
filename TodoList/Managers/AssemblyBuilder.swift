//
//  AssemblyBuilder.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//

import UIKit
import TaskManagerPackage

protocol IAssemblyBuilder {
	func assemblyLogin(router: IRouterProtocol) -> UIViewController
	func assemblyTodoList(taskManager: ITaskManager, router: IRouterProtocol) -> UIViewController
	func assemblyNewTask(router: IRouterProtocol, taskManager: ITaskManager) -> UIViewController
}

final class AssemblyBuilder: IAssemblyBuilder {
	func assemblyLogin(router: IRouterProtocol) -> UIViewController {
		let viewController = LoginViewController()
		let presenter = LoginPresenters(view: viewController)
		let interactor = LoginInteractor(presenter: presenter, router: router)
		viewController.interactor = interactor

		return viewController
	}

	func assemblyTodoList(taskManager: ITaskManager, router: IRouterProtocol) -> UIViewController {
		let viewController = TodoListViewController()
		let sectionForTaskManagerAdapter = SectionForTaskManagerAdapter(taskManager: taskManager)
		let presenter = TodoListPresenter(viewController: viewController)
		let interactor = TodoListInteractor(sectionManager: sectionForTaskManagerAdapter, presenter: presenter)
		viewController.interctor = interactor
		viewController.router = router

		return viewController
	}

	func assemblyNewTask(router: IRouterProtocol, taskManager: ITaskManager) -> UIViewController {
		let viewController = NewTaskViewController()
		let presenter = NewTaskPresenters(viewController: viewController)
		let interactor = NewTaskInteractor(presenter: presenter, taskManager: taskManager)
		viewController.interactor = interactor
		viewController.router = router

		return viewController
	}
}
