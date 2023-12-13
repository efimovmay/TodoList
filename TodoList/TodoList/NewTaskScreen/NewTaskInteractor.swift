//
//  NewTaskInteractor.swift
//  TodoList
//
//  Created by Aleksey Efimov on 01.12.2023.
//

import Foundation
import TaskManagerPackage

/// Протокол презентера для отображения экрана новой задачи.
protocol INewTaskInteractor {
	/// Экран готов для отображения информации.
	func fetchData()

	/// Сборка обычной звдвчи .
	func createRegularTask(request: NewTaskModel.Request.DataRegularTask)

	/// Сборка задачи с приоритетом
	func createImportantTask(request: NewTaskModel.Request.DataImportantTask)

	/// Сохранение задачи в менеджер задач
	func saveTask(task: Task)
}

final class NewTaskInteractor: INewTaskInteractor {

	// MARK: - Private properties
	private var presenter: INewTaskPresenters! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Dependencies
	private var router: IRouterProtocol
	private var taskManager: ITaskManager

	// MARK: - Initialization

	internal init(presenter: INewTaskPresenters, router: IRouterProtocol, taskManager: ITaskManager) {
		self.presenter = presenter
		self.router = router
		self.taskManager = taskManager
	}

	// MARK: - Public methods
	func fetchData() {
		let response = NewTaskModel.Response(priority: [.low, .medium, .high])
		presenter.present(responce: response)
	}

	func createRegularTask(request: NewTaskModel.Request.DataRegularTask) {
		let task = RegularTask(title: request.title)
		saveTask(task: task)
	}

	func createImportantTask(request: NewTaskModel.Request.DataImportantTask) {
		let task = ImportantTask(title: request.title, taskPriority: request.priority)
		saveTask(task: task)
	}

	func saveTask(task: Task) {
		taskManager.addTask(task: task)
		router.returnToTodoList()
	}
}
