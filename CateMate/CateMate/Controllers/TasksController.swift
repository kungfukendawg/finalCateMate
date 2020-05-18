
import UIKit

class TasksController: UITableViewController {
    
    var taskManager: TaskManager! {
        didSet {
            taskManager.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
            
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    // Adding a new task.
    override func viewDidLoad() {
        super.viewDidLoad();
        
        tableView.tableFooterView = UIView()
    }
    
    // Button to add task.
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        // Add the new task after tying it out.
        let addAction = UIAlertAction(title: "Add", style: .default) {_ in
            // When "Add" is pressed, save the textfield as "name".
            guard let name = alertController.textFields?.first?.text else { return }
            // Set the new task name.
            let newTask = Task(name: name)
            // Add the task to the top of the to-do list.
            self.taskManager.addTask(newTask, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        addAction.isEnabled = false
        // Cancel adding the new task.
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        alertController.addAction(addAction);
        alertController.addAction(cancelAction);
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
              else { return }
        
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

// MARK: - DataSource
// Formatting the "To-do" and "Done" sections.
extension TasksController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "To-do" : "Done"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskManager.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.tasks[section].count
    }
    // Show the name of the task in the cell.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskManager.tasks[indexPath.section][indexPath.row].name
        
        return cell
    }
    
}

// MARK: - Delegate
extension TasksController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    // Function to delete a task.
    // Swipe from right to left...
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {(action, sourceView, completionHandler) in
            
            guard let isDone = self.taskManager.tasks[indexPath.section][indexPath.row].isDone else { return }
            
            self.taskManager.removeTask(at: indexPath.row, isDone: isDone)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8784313725, green: 0.4901960784, blue: 0.4823529412, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // Function to move a task from the "To-do" section to the "Done" section.
    // Swipe from left to right...
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) {(action, sourceView, completionHandler) in
            
            self.taskManager.tasks[0][indexPath.row].isDone = true
            
            let doneTask = self.taskManager.removeTask(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.taskManager.addTask(doneTask, at: 0, isDone: true)
            
            let indexPath = IndexPath(row: 0, section: 1)
            tableView.insertRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.7411764706, blue: 0.6509803922, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
}
