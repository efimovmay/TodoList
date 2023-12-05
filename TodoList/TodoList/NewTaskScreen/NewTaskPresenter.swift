//
//  NewTaskPresenter.swift
//  TodoList
//
//  Created by Aleksey Efimov on 01.12.2023.
//

import Foundation

protocol INewTaskPresenters {
	func present(responce: NewTaskModel.Response)
}

final class NewTaskPresenters: INewTaskPresenters {

	// MARK: - Private properties

	private weak var view: INewTaskViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Initialization

	internal init(view: INewTaskViewController) {
		self.view = view
	}

	// MARK: - Public methods

	func present(responce: NewTaskModel.Response) {
		view.render(viewData: NewTaskModel.ViewModel(priority: responce.priority))
	}
}
