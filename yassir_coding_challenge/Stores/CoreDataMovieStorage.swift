//
//  CoredataMovieStorage.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import CoreData

class CoreDataPostStorage: MovieStorage {

    private let coreDataController: CoreDataController

    init(coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
    }

    internal lazy var fetchedResultsController: NSFetchedResultsController<MovieManagedObject> = {
        let fetchRequest = MovieManagedObject.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)

        do {
            try controller.performFetch()
        } catch {
            print("Failed to fetch entities: \(error)")
        }

        return controller
    }()

    private lazy var mainContext: NSManagedObjectContext = {
        return coreDataController.mainContext
    }()

    private lazy var backgroundContext: NSManagedObjectContext = {
        return coreDataController.backgroundContext
    }()

    // MARK: - PostStorage
    func save(movies: [Movie], completion: @escaping (() -> ())) {
        backgroundContext.perform { [weak self] in
            guard let self = self else {
                return
            }
            for movie in movies {
                let _ = MovieManagedObject.createMovieManagedObject(from: movie, context: self.backgroundContext)
            }

            self.coreDataController.save(context: self.backgroundContext)
            self.backgroundContext.reset()

            DispatchQueue.main.async {
                self.coreDataController.save(context: self.mainContext)
            }

            completion()
        }
    }

    func findMovie(at indexPath: IndexPath) -> Movie {
        let postManagedObject = fetchedResultsController.object(at: indexPath)
        return postManagedObject.toMovieObject()
    }

    func numberOfRowsIn(section: Int) -> Int {
        let section = fetchedResultsController.sections?[section]
        return section?.numberOfObjects ?? 0
    }
}
