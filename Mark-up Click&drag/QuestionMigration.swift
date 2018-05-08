import CoreData

class QuestionMigration: NSEntityMigrationPolicy {
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        let questionInstance: NSManagedObject!
        
        let entity = NSEntityDescription.entity(forEntityName: "Question", in: manager.destinationContext)!
        questionInstance = NSManagedObject(entity: entity, insertInto: manager.destinationContext)
        
        let destResults = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
        if let destinationQuestion = destResults.last {
            destinationQuestion.setValue(questionInstance, forKey: "questions")
        }
        
        
    }
}
