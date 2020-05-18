
import Foundation

class Task: NSObject, NSCoding {
    
    var name: String?
    var isDone: Bool?
    
    private let nameKey = "name"
    private let isDoneKey = "isDone"
    
    // To start a task.
    init(name: String, isDone: Bool = false) {
        self.name = name;
        self.isDone = isDone;
    }
    
    // To encode tasks for archiving.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: nameKey)
        aCoder.encode(isDone, forKey: isDoneKey)
    }
    
    // To show tasks from archive.
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: nameKey) as? String,
              let isDone = aDecoder.decodeObject(forKey: isDoneKey) as? Bool
              else { return }
        
        self.name = name
        self.isDone = isDone
    }
}
