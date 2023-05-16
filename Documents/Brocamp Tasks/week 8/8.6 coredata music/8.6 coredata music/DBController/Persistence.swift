import CoreData
//import CloudKit

struct PersistenceController{
    static let shared = PersistenceController()
    
    let container:NSPersistentCloudKitContainer
    
    init(inMemory:Bool = false) {
        container = NSPersistentCloudKitContainer(name:"musicPlayerDB")
        
        if inMemory{
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores { NSPersistentStoreDescription, err in
            if let err = err{
                fatalError(err.localizedDescription)
            }
            
            
        }
        
        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    
    func save() throws{
        let context = container.viewContext
        if context.hasChanges{
            try context.save()
        }
    }
    
    
    func delete(_ object:NSManagedObject)throws{
        let context = container.viewContext
        context.delete(object)
        try save()
    }
    
    
    
}


