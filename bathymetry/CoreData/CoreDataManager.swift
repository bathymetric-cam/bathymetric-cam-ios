import CoreData

// MARK: - CoreDataManager
class CoreDataManager {
  // MARK: static constant
  // static let sharedInstance = CoreDataManager()

  // MARK: property
  let persistentContainer: NSPersistentContainer
  var managedObjectContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  // MARK: initialization
  init() {
    persistentContainer = NSPersistentContainer(name: "CoreData")
    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }

}
