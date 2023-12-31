//
//  TodoListPresenter.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation
import TaskManagerPackage

protocol ITodoListPresenter {

	/// Отображение экрана со списком заданий.
	/// - Parameter response: Подготовленные к отображению данные.
	func present(response: TodoListModel.Response)

	/// Создание нового задания.
	func createTask()
}

final class TodoListPresenter: ITodoListPresenter {

	// MARK: - Private properties

	private weak var viewController: ITodoListViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Initialization

	internal init(viewController: ITodoListViewController) {
		self.viewController = viewController
	}

	// MARK: - Public methods

	func present(response: TodoListModel.Response) {
		var sections = [TodoListModel.ViewModel.Section]()
		for sectionWithTasks in response.data {
			let sectionData = TodoListModel.ViewModel.Section(
				title: sectionWithTasks.section.title,
				tasks: mapTasksData(tasks: sectionWithTasks.tasks)
			)
			sections.append(sectionData)
		}
		viewController.render(viewModel: TodoListModel.ViewModel(tasksBySections: sections))
	}

	func createTask() {
		viewController.createTask()
	}

	// MARK: - Private methods

	private func mapTasksData(tasks: [Task]) -> [TodoListModel.ViewModel.Task] {
		tasks.map { mapTaskData(task: $0) }
	}

	/// Мапинг одной задачи из бизнес-модели в задачу для отображения
	/// - Parameter task: Задача для преобразования.
	/// - Returns: Преобразованный результат.
	private func mapTaskData(task: Task) -> TodoListModel.ViewModel.Task {
		if let task = task as? ImportantTask {
			let result = TodoListModel.ViewModel.ImportantTask(
				title: task.title,
				completed: task.completed,
				deadLine: "Deadline: \(task.deadLine)",
				priority: "\(task.taskPriority)"
			)
			return .importantTask(result)
		} else {
			return .regularTask(
				TodoListModel.ViewModel.RegularTask(
					title: task.title,
					completed: task.completed
				)
			)
		}
	}
}
