//
//  LoginInteractor.swift
//  TodoList
//
//  Created by Aleksey Efimov on 30.11.2023.
//

import Foundation
import UIKit

/// Протокол презентера для отображения экрана ввода пароля .
protocol ILoginInteractor {

	/// Экран готов для отображения информации.
	func fetchData()

	/// Пользователь нажал кнопку авторизации
	func didLogin(request: LoginModel.Request)
}

final class LoginInteractor: ILoginInteractor {

	// MARK: - Private properties

	private var presenter: ILoginPresenters! // swiftlint:disable:this implicitly_unwrapped_optional

	// MARK: - Dependencies

	private var router: IRouterProtocol

	// MARK: - Initialization

	internal init(presenter: ILoginPresenters, router: IRouterProtocol) {
		self.presenter = presenter
		self.router = router
	}

	// MARK: - Public methods
	func fetchData() {
		presenter.present()
	}

	func didLogin(request: LoginModel.Request) {
		if request.login == "1" && request.password == "" {
			router.showTodoList()
		} else {
			presenter.showAlert()
		}
	}
}
