
import Foundation

class TasksUtility {
    
    private static let key = "tasks"
    
    // Function to archive tasks.
    private static func archive(_ tasks: [[Task]]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
    }
    
    // Function to save tasks.
    static func save(_ tasks: [[Task]]) {
        
        // Archive.
        let archivedTasks = archive(tasks)
        
        // Set object for key.
        UserDefaults.standard.set(archivedTasks, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    // Function to fetch tasks from archive.
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedData) as? [[Task]]
    }
    
}
