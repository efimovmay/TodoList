//
//  TodoListTableViewController.swift

import UIKit
import TaskManagerPackage

/// Протокол для главного экрана приложения.
protocol ITodoListViewController: AnyObject {

	/// Метод отрисовки информации на экране.
	/// - Parameter viewData: данные для отрисовки на экране.
	func render(viewModel: TodoListModel.ViewModel)
}

/// Главный экран приложения.
final class TodoListViewController: UITableViewController {

	// MARK: - Dependencies
	var interctor: ITodoListInteractor?

	// MARK: - Private properties
	private var viewModel = TodoListModel.ViewModel(tasksBySections: [])

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
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		interctor?.fetchData()
	}
}

private extension TodoListViewController {
	@objc
	func createTask() {
		interctor?.createTask()
	}
}

// MARK: - UITableView

extension TodoListViewController {

	override func numberOfSections(in tableView: UITableView) -> Int {
		viewModel.tasksBySections.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		viewModel.tasksBySections[section].title
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let section = viewModel.tasksBySections[section]
		return section.tasks.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let task = getTaskForIndex(indexPath)
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		configureCell(cell, with: task)
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		interctor?.didTaskSelected(request: TodoListModel.Request.TaskSelected(indexPath: indexPath))
	}
}

// MARK: - UI setup

private extension TodoListViewController {

	private func setup() {
		title = "TodoList"
		navigationItem.setHidesBackButton(true, animated: true)
		self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

		let buttonNewTask = UIBarButtonItem(
			barButtonSystemItem: .add,
			target: self,
			action: #selector(createTask)
		)
		navigationItem.rightBarButtonItem = buttonNewTask
	}

	func getTaskForIndex(_ indexPath: IndexPath) -> TodoListModel.ViewModel.Task {
		let tasks = viewModel.tasksBySections[indexPath.section].tasks
		let task = tasks[indexPath.row]
		return task
	}

	func configureCell(_ cell: UITableViewCell, with task: TodoListModel.ViewModel.Task) {
		var contentConfiguration = cell.defaultContentConfiguration()

		cell.tintColor = .red
		cell.selectionStyle = .none

		switch task {
		case .importantTask(let task):
			let redText = [NSAttributedString.Key.foregroundColor: UIColor.red]
			let taskText = NSMutableAttributedString(string: task.priority + " ", attributes: redText )
			taskText.append(NSAttributedString(string: task.title))

			contentConfiguration.attributedText = taskText
			contentConfiguration.secondaryText = task.deadLine
			cell.accessoryType = task.completed ? .checkmark : .none
		case .regularTask(let task):
			contentConfiguration.text = task.title
			cell.accessoryType = task.completed ? .checkmark : .none
		}

		cell.contentConfiguration = contentConfiguration
	}
}

// MARK: - IMainViewController

extension TodoListViewController: ITodoListViewController {
	func render(viewModel: TodoListModel.ViewModel) {
		self.viewModel = viewModel
		tableView.reloadData()
	}
}
