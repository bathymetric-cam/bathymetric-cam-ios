import CoreData

// MARK: - StorageProvider
class StorageProvider {
  // MARK: static constant
  // static let sharedInstance = CoreDataManager()

  // MARK: property
  let persistentContainer: NSPersistentContainer
  var managedObjectContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }
  
  // MARK: initialization
  init(name: String, group: String) {
    persistentContainer = NSPersistentContainer(name: name)
    guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) else {
      fatalError("Could not find coredata group url.")
    }
    persistentContainer.persistentStoreDescriptions.first?.url = url.appendingPathComponent("\(name).sqlite")
    persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        fatalError("Core Data store failed to load with error: \(error)")
      }
    }
  }

}
