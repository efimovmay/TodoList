//
//  NewTaskViewController.swift
//  TodoList
//
//  Created by Aleksey Efimov on 01.12.2023.
//

import UIKit

protocol INewTaskViewController: AnyObject {

	/// Уведомление, что задание создано.
	func taskCreated()

	/// Метод отрисовки информации на экране.
	/// - Parameter viewData: данные для отрисовки на экране.
	func render(viewData: NewTaskModel.ViewModel)
}

final class NewTaskViewController: UIViewController {

	// MARK: - Dependencies
	var router: IRouterProtocol?
	var interactor: INewTaskInteractor?

	// MARK: - Private properties

	private lazy var buttonSave: UIButton = makeButtonSave()
	private lazy var textFieldTitleTask: UITextField = makeTextFieldTitleTask()
	private lazy var segmentTypeTask: UISegmentedControl = makeSegmentTypeTask()
	private lazy var labelOnlyImportant: UILabel = makeLabelOnlyImportant()
	private lazy var sliderpriority: UISlider = makesliderpriority()

	private var constraints = [NSLayoutConstraint]()
	private let priority = ["Обычное", "Важное"]

	private var viewModel = NewTaskModel.ViewModel(priority: [])

	// MARK: - Initialization

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		interactor?.fetchData()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		layout()
	}
}
// MARK: - Actions

private extension NewTaskViewController {
	@objc
	func createTask() {
		if segmentTypeTask.selectedSegmentIndex == 0 {
			interactor?.createRegularTask(request: NewTaskModel.Request.DataRegularTask(title: textFieldTitleTask.text ?? ""))
		} else {
			let priority = viewModel.priority[Int(sliderpriority.value)]
			interactor?.createImportantTask(
				request: NewTaskModel.Request.DataImportantTask(title: textFieldTitleTask.text ?? "", priority: priority)
			)
		}
	}

	@objc
	func changeType(_ sender: UISegmentedControl) {
		if sender.selectedSegmentIndex == 0 {
			labelOnlyImportant.isHidden = true
			sliderpriority.isHidden = true
		} else {
			labelOnlyImportant.isHidden = false
			sliderpriority.isHidden = false
		}
	}

	@objc
	func changeSlider(_ sender: UISlider) {
		let stepSliderPriority = 1
		let newValue = (sender.value / Float(stepSliderPriority)).rounded() * Float(stepSliderPriority)
		sender.setValue(Float(newValue), animated: false)
	}
}

// MARK: - Setup UI

private extension NewTaskViewController {

	func  makeTextFieldTitleTask() -> UITextField {
		let textField = UITextField()

		textField.backgroundColor = .white
		textField.textColor = .black
		textField.layer.borderWidth = Sizes.borderWidth
		textField.layer.cornerRadius = Sizes.cornerRadius
		textField.layer.borderColor = UIColor.lightGray.cgColor
		textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Sizes.Padding.half, height: textField.frame.height))
		textField.leftViewMode = .always

		textField.translatesAutoresizingMaskIntoConstraints = false

		return textField
	}

	func makeSegmentTypeTask() -> UISegmentedControl {
		let segmentControl = UISegmentedControl(items: priority)
		segmentControl.selectedSegmentIndex = 0
		segmentControl.addTarget(self, action: #selector(changeType), for: .valueChanged)

		segmentControl.translatesAutoresizingMaskIntoConstraints = false

		return segmentControl
	}

	func makeLabelOnlyImportant() -> UILabel {
		let label = UILabel()
		label.text = "Приоритет (только для важных заданий):"
		label.isHidden = true

		label.translatesAutoresizingMaskIntoConstraints = false

		return label
	}

	func makesliderpriority() -> UISlider {
		let slider = UISlider()
		slider.isHidden = true
		slider.addTarget(self, action: #selector(changeSlider), for: .valueChanged)

		slider.translatesAutoresizingMaskIntoConstraints = false

		return slider
	}

	func makeButtonSave() -> UIButton {
		let button = UIButton()

		button.configuration = .filled()
		button.configuration?.cornerStyle = .medium
		button.configuration?.baseBackgroundColor = .red
		button.configuration?.title = "Создать задание"
		button.addTarget(self, action: #selector(createTask), for: .touchUpInside)

		button.translatesAutoresizingMaskIntoConstraints = false

		return button
	}

	func setup() {
		view.backgroundColor = .white
		title = "Создание Задания"
		navigationController?.navigationBar.prefersLargeTitles = true

		textFieldTitleTask.placeholder = "Введите название задания"

		view.addSubview(textFieldTitleTask)
		view.addSubview(segmentTypeTask)
		view.addSubview(labelOnlyImportant)
		view.addSubview(sliderpriority)
		view.addSubview(buttonSave)
	}
}

// MARK: - Layout UI

private extension NewTaskViewController {

	func layout() {
		NSLayoutConstraint.deactivate(constraints)

		let newConstraints = [
			textFieldTitleTask.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			textFieldTitleTask.topAnchor.constraint(equalTo: view.topAnchor, constant: fourthOfTheScreen),
			textFieldTitleTask.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.L.widthMultiplier),
			textFieldTitleTask.heightAnchor.constraint(equalToConstant: Sizes.M.height),

			segmentTypeTask.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			segmentTypeTask.topAnchor.constraint(equalTo: textFieldTitleTask.bottomAnchor, constant: Sizes.Padding.normal),
			segmentTypeTask.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
			segmentTypeTask.heightAnchor.constraint(equalToConstant: Sizes.S.height),

			labelOnlyImportant.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			labelOnlyImportant.topAnchor.constraint(equalTo: segmentTypeTask.bottomAnchor, constant: Sizes.Padding.normal),
			labelOnlyImportant.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.L.widthMultiplier),
			labelOnlyImportant.heightAnchor.constraint(equalToConstant: Sizes.S.height),

			sliderpriority.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			sliderpriority.topAnchor.constraint(equalTo: labelOnlyImportant.bottomAnchor, constant: Sizes.Padding.half),
			sliderpriority.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.L.widthMultiplier),
			sliderpriority.heightAnchor.constraint(equalToConstant: Sizes.M.height),

			buttonSave.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			buttonSave.topAnchor.constraint(equalTo: sliderpriority.bottomAnchor, constant: Sizes.Padding.double),
			buttonSave.widthAnchor.constraint(equalToConstant: Sizes.L.width),
			buttonSave.heightAnchor.constraint(equalToConstant: Sizes.M.height)
		]

		NSLayoutConstraint.activate(newConstraints)

		constraints = newConstraints
	}

	var fourthOfTheScreen: Double {
		return view.bounds.size.height / 4.0
	}
}

// MARK: - INewTaskViewController

extension NewTaskViewController: INewTaskViewController {
	func render(viewData: NewTaskModel.ViewModel) {
		self.viewModel = viewData
		sliderpriority.maximumValue = Float(viewData.priority.count) - 1
	}

	func taskCreated() {
		router?.returnToTodoList()
	}
}
