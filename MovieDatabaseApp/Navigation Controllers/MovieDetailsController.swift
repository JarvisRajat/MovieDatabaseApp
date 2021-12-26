//
//  MovieDetailsController.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 26/12/21.
//

import UIKit

class MovieDetailsController: UIViewController {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var moviePoster: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var moviePlot: UILabel!
    @IBOutlet private weak var castAndCrew: UILabel!
    @IBOutlet private weak var movieReleaseDate: UILabel!
    @IBOutlet private weak var movieGenre: UILabel!
    @IBOutlet private weak var movieRatings: UILabel!
    
    var movieData: MovieData?
    var selectedRatingData = [Ratings]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        movieRatings.isUserInteractionEnabled = true
        movieRatings.addGestureRecognizer(tapGesture)
        movieDetailsSetup()
    }

    @objc private func handleTap() {
        let navController = RatingsDrawerController(nibName: "RatingsDrawerController", bundle: nil)
        navController.ratingsSources = movieData?.ratings ?? []
        navController.ratings = selectedRatingData
        navController.delegate = self
        navigationController?.pushViewController(navController, animated: true)
    }
    private func movieDetailsSetup() {
        if let imageUrl = movieData?.poster, !imageUrl.isEmpty {
            Constants.shared.loadImage(imageView: moviePoster, imageUrl: imageUrl)
        }
        movieTitle.text = movieData?.title
        moviePlot.text = movieData?.plot
        if let actors = movieData?.actors,
           let director = movieData?.director,
           let writer = movieData?.writer {
            castAndCrew.attributedText = Constants.shared.textStylingForCastAndCrew(actors: actors, director: director, writer: writer)
        }
        movieReleaseDate.text = movieData?.year
        movieGenre.text = movieData?.genre
    }
}
extension MovieDetailsController: RatingDataFetch {
    func dataPass(ratingData: [Ratings]) {
        selectedRatingData = ratingData
        var ratings = !ratingData.isEmpty ? "" : "Ratings"
        for data in ratingData {
            if let source = data.source,
               let ratingValue = data.value {
                ratings += "\(source): \(ratingValue)\n"
            }
        }
        movieRatings.text = ratings
    }
}
