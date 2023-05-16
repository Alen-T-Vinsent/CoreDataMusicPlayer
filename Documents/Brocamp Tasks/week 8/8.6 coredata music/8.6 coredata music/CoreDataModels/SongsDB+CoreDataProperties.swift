import Foundation
import CoreData


extension SongsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SongsDB> {
        return NSFetchRequest<SongsDB>(entityName: "SongsDB")
    }

    @NSManaged public var idDB: UUID?
    @NSManaged public var nameDB: String?
    @NSManaged public var isfav: Bool

    var songsNameManual:String{
        nameDB ?? "UNKNOWN nameDB"
    }
    
}


extension SongsDB : Identifiable {

}
