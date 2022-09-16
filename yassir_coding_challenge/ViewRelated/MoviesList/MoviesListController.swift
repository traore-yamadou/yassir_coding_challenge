//
//  ViewController.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import UIKit
import CoreData

class MoviesListController: UITableViewController, StoryboardInitializable {

    var isLoading = false
    var viewModel: MoviesListViewModel?

    // MARK: - IBOUtlets
    @IBOutlet weak var activitIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = NSLocalizedString("MOVIES", comment: "")
        viewModel?.fetchedResultsController?.delegate = self
        loadMovies()
    }

    private func loadMovies(completion: @escaping (() ->()) = {}) {
        isLoading = true
        activitIndicator.startAnimating()
        viewModel?.loadMovies { [weak self] error in
            self?.isLoading = false
            self?.executeInMainThread { self?.activitIndicator.stopAnimating() }

            if let _ = error {
                self?.displayError(completion: completion)
                return
            }

            completion()
        }
    }

    private func displayError(completion: @escaping (() ->()) = {}) {
        showErrorAlert(title:  NSLocalizedString("ERROR", comment: ""),
                       message: NSLocalizedString("LOAD_MOVIES_ERROR", comment: "")) {
            completion()
        }
    }

    private func showInfiniteScrollLoadingSpinner() {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = .init(x: 0, y: 0, width: tableView.bounds.width, height: 44)

        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }

    private func hideInfiniteScrollLoadingSpinner() {
        executeInMainThread { self.tableView.tableFooterView?.isHidden = true }
    }
}

// MARK: - UITableViewDataSource
extension MoviesListController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsIn(section: section) ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieCell else {
            fatalError("The dequeued cell is not an instance of MovieCell.")
        }
        if let movie = viewModel?.findMovie(at: indexPath) {
            cell.movie = movie
            cell.thumbnailUrl = viewModel?.getThumbnailUrl(of: movie)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - UITableViewDelegate
extension MoviesListController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailController = MovieDetailController.instantiate()
        
        if let movie = viewModel?.findMovie(at: indexPath) {
            movieDetailController.movie = movie
            movieDetailController.thumbnailUrl = viewModel?.getThumbnailUrl(of: movie)
        }
        navigationController?.show(movieDetailController, sender: self)
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(viewModel?.shouldLoadMoreMovies(lastMovieIndexPath: indexPath) ?? false && !isLoading) {
            showInfiniteScrollLoadingSpinner()
            loadMovies { [weak self] in self?.hideInfiniteScrollLoadingSpinner() }
        }
    }
}

// MARK: - Fetched Results Delegate
extension MoviesListController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
