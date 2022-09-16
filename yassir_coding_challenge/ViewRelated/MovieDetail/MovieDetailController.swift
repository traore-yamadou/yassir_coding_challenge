//
//  MovieDetailController.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 16/09/2022.
//

import UIKit

class MovieDetailController: UIViewController, StoryboardInitializable {

    var movie: Movie?
    var thumbnailUrl: URL?

    // MARK: -IBOutlets
    @IBOutlet weak var overviewTextview: UITextView!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = movie?.title
        setupViews()
    }

    private func setupViews() {
        titleLabel.text = movie?.title
        releaseDateLabel.text = movie?.releaseDate.components(separatedBy: "-").first
        overviewTextview.text = movie?.overview
        guard let thumbnailUrl = thumbnailUrl else { return }
        thumbnail.kf.setImage(with: thumbnailUrl)
    }
}
