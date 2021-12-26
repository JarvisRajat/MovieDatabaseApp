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
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        movieRatings.isUserInteractionEnabled = true
        movieRatings.addGestureRecognizer(tapGesture)
        movieDetailsSetup()
        // Do any additional setup after loading the view.
    }

    @objc private func handleTap() {
        let navController = RatingsDrawerController(nibName: "RatingsDrawerController", bundle: nil)
        navController.ratingsSources = movieData?.ratings ?? []
        navController.delegate = self
        navigationController?.pushViewController(navController, animated: true)
    }
    private func movieDetailsSetup() {
        if let imageUrl = movieData?.poster, !imageUrl.isEmpty {
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
        movieTitle.text = movieData?.title
        moviePlot.text = movieData?.plot
        if let actors = movieData?.actors,
           let director = movieData?.director,
           let writer = movieData?.writer {
            castAndCrew.text = "Actors: \(actors)\nDirector: \(director)\nWriter: \(writer)"
        }
        
        movieReleaseDate.text = movieData?.year
        movieGenre.text = movieData?.genre
    }

}
extension MovieDetailsController: RatingDataFetch {
    func dataPass(ratingData: [Ratings]) {
        var ratings = ""
        for data in ratingData {
            if let source = data.source,
               let ratingValue = data.value {
                ratings += "\(source): \(ratingValue)\n"
            }
        }
        movieRatings.text = ratings
    }
}
