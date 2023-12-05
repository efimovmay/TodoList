//
//  NewTaskModels.swift
//  TodoList
//
//  Created by Aleksey Efimov on 01.12.2023.
//

import Foundation
import TaskManagerPackage

enum NewTaskModel {
	// MARK: Use cases

	enum Request {
		/// Данные для создания обычной задачи
		struct DataRegularTask {
			let title: String
		}

		/// Данные для создания  задачи с приоритетом
		struct DataImportantTask {
			let title: String
			let priority: ImportantTask.TaskPriority
		}
	}

	struct Response {
		let priority: [ImportantTask.TaskPriority]
	}

	struct ViewModel {
		let priority: [ImportantTask.TaskPriority]
	}
}
