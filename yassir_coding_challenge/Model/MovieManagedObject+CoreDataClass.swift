//
//  MovieManagedObject+CoreDataClass.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//
//

import Foundation
import CoreData

@objc(MovieManagedObject)
public class MovieManagedObject: NSManagedObject {

    static func createMovieManagedObject(from movie: Movie, context: NSManagedObjectContext) -> MovieManagedObject {
        let managedObject = MovieManagedObject(context: context)
        managedObject.id = movie.id as NSNumber
        managedObject.title = movie.title
        managedObject.releaseDate = movie.releaseDate
        managedObject.posterPath = movie.posterPath
        managedObject.overview = movie.overview
        return managedObject
    }

    func toMovieObject() -> Movie {
        return Movie(id: Int(truncating: id),
                     title: title,
                     releaseDate: releaseDate,
                     overview: overview,
                     posterPath: posterPath)
    }
}
