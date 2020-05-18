
import Foundation

class TaskManager {
    
    // 2D array to store tasks
    var tasks = [[Task](), [Task]()]
    
    // Function to add a task.
    func addTask(_ task: Task, at index: Int, isDone: Bool = false) {
        let section = isDone ? 1 : 0
        
        tasks[section].insert(task, at: index)
    }
    
    // Function to remove a task.
    @discardableResult func removeTask(at index: Int, isDone: Bool = false) -> Task {
        let section = isDone ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
}
