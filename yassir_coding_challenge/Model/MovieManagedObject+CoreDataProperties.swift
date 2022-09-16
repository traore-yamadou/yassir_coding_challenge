//
//  MovieManagedObject+CoreDataProperties.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//
//

import Foundation
import CoreData


extension MovieManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieManagedObject> {
        return NSFetchRequest<MovieManagedObject>(entityName: "MovieManagedObject")
    }

    @NSManaged public var id: NSNumber
    @NSManaged public var title: String
    @NSManaged public var releaseDate: String
    @NSManaged public var posterPath: String
    @NSManaged public var overview: String

}

extension MovieManagedObject : Identifiable {

}
