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
	func assemblyTodoList(router: IRouterProtocol, taskManager: ITaskManager) -> UIViewController
	func assemblyNewTask(router: IRouterProtocol, taskManager: ITaskManager) -> UIViewController
}

class AssemblyBuilder: IAssemblyBuilder {
	func assemblyLogin(router: IRouterProtocol) -> UIViewController {
		let viewController = LoginViewController()
		let presenter = LoginPresenters(view: viewController)
		let interactor = LoginInteractor(presenter: presenter, router: router)
		viewController.interactor = interactor
		return viewController
	}

	func assemblyTodoList(router: IRouterProtocol, taskManager: ITaskManager) -> UIViewController {
		let viewController = TodoListViewController()
		let sectionForTaskManagerAdapter = SectionForTaskManagerAdapter(taskManager: taskManager)
		let presenter = TodoListPresenter(viewController: viewController)
		let interactor = TodoListInteractor(
			sectionManager: sectionForTaskManagerAdapter,
			presenter: presenter,
			router: router
		)
		viewController.interctor = interactor
		return viewController
	}

	func assemblyNewTask(router: IRouterProtocol, taskManager: ITaskManager) -> UIViewController {
		let viewController = NewTaskViewController()
		let presenter = NewTaskPresenters(view: viewController)
		let interactor = NewTaskInteractor(presenter: presenter, router: router, taskManager: taskManager)
		viewController.interactor = interactor
		return viewController
	}
}
