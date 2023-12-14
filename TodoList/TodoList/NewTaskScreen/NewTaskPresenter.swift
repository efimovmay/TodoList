//
//  NewTaskPresenter.swift
//  TodoList
//
//  Created by Aleksey Efimov on 01.12.2023.
//

import Foundation

protocol INewTaskPresenters {

	/// Уведомление, что задание создано.
	func taskCreated()
	func present(responce: NewTaskModel.Response)
}

final class NewTaskPresenters: INewTaskPresenters {

	// MARK: - Private properties

	private weak var viewController: INewTaskViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Initialization

	internal init(viewController: INewTaskViewController) {
		self.viewController = viewController
	}

	// MARK: - Public methods

	func taskCreated() {
		viewController.taskCreated()
	}

	func present(responce: NewTaskModel.Response) {
		viewController.render(viewData: NewTaskModel.ViewModel(priority: responce.priority))
	}
}
