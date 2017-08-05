import CoreData

public class CoreDataManager {
    
    // MARK: - DECLARATIONS
    
    init (modelName: String) {
        self.modelName = modelName
    }
    
    private let modelName: String
    
    // MARK: - MANAGED OBJECT MODEL DEFINED
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        
        // Fetch Model URL
        guard let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd") else {
            return nil
        }
        
        // Initialize Managed Object Model
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        return managedObjectModel
    }()
    
    // MARK: - PERSISTENT STORE URL SET
    
    private var persistentStoreURL: NSURL {
        
        let storeName = "\(modelName).sqlite"
        let fileManager = FileManager.default
        
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        return documentsDirectoryURL.appendingPathComponent(storeName) as NSURL
    }
    
    // MARK: - PERSISTENT STORE COORDINATOR SETUP
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        guard let managedObjectModel = self.managedObjectModel else {
            return nil
        }
        
        // Helper
        let persistentStoreURL = self.persistentStoreURL
        
        // Initialize Persistent Store Coordinator
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistentStoreURL as URL, options: options)
            
        } catch {
            let addPersistentStoreError = error as NSError
            
            print("Unable to Add Persistent Store")
            print("\(addPersistentStoreError.localizedDescription)")
        }
        
        return persistentStoreCoordinator
    }()
    
    // MARK: - MANAGED OBJECT CONTEXT SET
    
    public private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        
        // Initialize Managed Object Context
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // Configure Managed Object Context
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObjectContext
    }()
}
