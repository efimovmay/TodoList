//
//  LoginPresenter.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//

import Foundation

protocol ILoginPresenters {
	func present()
	func showAlert()
}

final class LoginPresenters: ILoginPresenters {

	// MARK: - Private properties

	private weak var view: ILoginViewController! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Initialization

	internal init(view: ILoginViewController?) {
		self.view = view
	}

	// MARK: - Public methods

	func present() {
		view.render(viewData: LoginModel.ViewModel(login: "", password: ""))
	}

	func showAlert() {
		view.showAlert()
	}
}
