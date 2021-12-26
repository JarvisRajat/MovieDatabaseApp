//
//  MovieDetailsCell.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import UIKit
import Foundation

class MovieDetailsCell: BaseTableViewCell<MovieData> {

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var releasedYear: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var datasource: MovieData! {
            didSet {
                cellSetup()
            }
    }
    
    private func cellSetup() {
        movieTitle.text = datasource.title
        movieLanguage.text = datasource.language
        if let imageUrl = datasource.poster, !imageUrl.isEmpty {
            moviePoster.loadImage(from: imageUrl) { [weak self] (image) in
                DispatchQueue.main.async {
                    if let downloadedImage = image {
                        self?.moviePoster.image = downloadedImage
                    } else {
                        self?.moviePoster.backgroundColor = UIColor.lightGray
                    }
                }
            }
        }
        moviePoster.makeRounded(true, .clear, true)
        releasedYear.text = datasource.year
    }
}
