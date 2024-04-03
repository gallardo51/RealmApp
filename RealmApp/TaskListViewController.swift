//
//  ViewController.swift
//  RealmApp
//
//  Created by Александр Соболев on 02.04.2024.
//

import UIKit
import RealmSwift

class TaskListViewController: UITableViewController {
    
    private var taskLists: Results<TaskList>!
    private let cellID = "TaskListCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        createTempData()
        setNavBar()
        taskLists = StorageManager.shared.realm.objects(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - TableView Data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let taskList = taskLists[indexPath.row]
        cell.configure(with: taskList)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskVC = TaskViewController()
        let taskList = taskLists[indexPath.row]
        taskVC.taskList = taskList
        show(taskVC, sender: taskList)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let taskList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(taskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, isDone in
            self.showAlert(with: taskList) {
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            isDone(true)
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, isDone in
            StorageManager.shared.done(taskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            isDone(true)
        }
        
        editAction.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        doneAction.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return UISwipeActionsConfiguration(actions: [doneAction, editAction, deleteAction])
    }
    
    private func setNavBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        
        navBarAppearance.backgroundColor = UIColor(
            red: 120/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let addBarItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonPressed))
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationItem.rightBarButtonItems = [addBarItem, editButtonItem]
        
        //MARK: - Segmental Control
        
//        let items = ["DATE", "A-Z"]
//        let segmentedControl = UISegmentedControl(items: items)
//        segmentedControl.frame = CGRect(x: 0, y: 0, width: 393, height: 32)
//        segmentedControl.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
//        segmentedControl.selectedSegmentIndex = 0
//        view.addSubview(segmentedControl)
    }
    
//    @objc func segmentAction(_ segmentedControl: UISegmentedControl) {
//        switch (segmentedControl.selectedSegmentIndex) {
//        case 0:
//            break // Uno
//        case 1:
//            break // Dos
//        default:
//            break
//        }
//    }
    
    @objc private func addButtonPressed() {
        showAlert()
    }
}

//MARK: - Private methods

extension TaskListViewController {
    private func showAlert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let title = taskList != nil ? "Edit List" : "New List"
        
        let alert = UIAlertController.createAlert(withTitle: title, andMessage: "Please, set title for new task list")
        
        alert.action(with: taskList) { newValue in
            if let taskList = taskList, let completion = completion {
                StorageManager.shared.rename(taskList, to: newValue)
                completion()
            } else {
                self.save(taskList: newValue)
            }
        }
        present(alert, animated: true)
    }
    
    private func save(taskList: String) {
        let taskList = TaskList(value: [taskList])
        StorageManager.shared.save(taskList)
        let rowIndex = IndexPath(row: taskLists.index(of: taskList) ?? 0, section: 0)
        tableView.insertRows(at: [rowIndex], with: .automatic)
    }
    
    private func createTempData() {
        DataManager.shared.createTempData {
            self.tableView.reloadData()
        }
    }
}
