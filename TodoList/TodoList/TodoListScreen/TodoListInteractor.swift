//
//  TodoListInteractor.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//

import Foundation
import TaskManagerPackage

/// Протокол презентера для отображения главного экрана.
protocol ITodoListInteractor {

	/// Экран готов для отображения информации.
	func fetchData()

	/// Пользователь выбрал строку  в таблице.
	/// - Parameter indexPath: Индекс выбранной строки.
	func didTaskSelected(request: TodoListModel.Request.TaskSelected)

	func createTask()
}

final class TodoListInteractor: ITodoListInteractor {
	// MARK: - Dependencies

	private var sectionManager: ISectionForTaskManagerAdapter
	private var presenter: ITodoListPresenter
	private var router: IRouterProtocol

	// MARK: - Initialization

	internal init(
		sectionManager: ISectionForTaskManagerAdapter,
		presenter: ITodoListPresenter,
		router: IRouterProtocol
	) {
		self.sectionManager = sectionManager
		self.presenter = presenter
		self.router = router
	}

	// MARK: - Public methods

	func fetchData() {
		var responseData = [TodoListModel.Response.SectionWithTasks]()

		for section in sectionManager.getSections() {
			let sectionWithTasks = TodoListModel.Response.SectionWithTasks(
				section: section,
				tasks: sectionManager.getTasksForSection(section: section)
			)
			responseData.append(sectionWithTasks)
		}

		let response = TodoListModel.Response(data: responseData)
		presenter.present(response: response)
	}

	func didTaskSelected(request: TodoListModel.Request.TaskSelected) {
		let section = sectionManager.getSection(forIndex: request.indexPath.section)
		let task = sectionManager.getTasksForSection(section: section)[request.indexPath.row]
		task.completed.toggle()
		fetchData()
	}

	func createTask() {
		router.showNewTask()
	}
}
