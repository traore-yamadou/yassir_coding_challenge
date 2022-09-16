//
//  MovieCellTableViewCell.swift
//  yassir_coding_challenge
//
//  Created by Yamadou Traore on 14/09/2022.
//

import UIKit
import Kingfisher


class MovieCell: UITableViewCell {

    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    var thumbnailUrl: URL? {
        didSet {
            guard let thumbnailUrl = thumbnailUrl else { return }
            thumbnail.kf.setImage(with: thumbnailUrl)
        }
    }

    var movie: Movie? {
        didSet {
            titleLabel.text = movie?.title
            releaseDateLabel.text = movie?.releaseDate.components(separatedBy: "-").first
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        thumbnail.kf.cancelDownloadTask() // cancel currenct download task
        thumbnail.kf.setImage(with: URL(string: "")) // prevent kingfisher from setting previous image
        thumbnail.image = nil
    }
}
