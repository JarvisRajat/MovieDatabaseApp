//
//  MovieRatingCell.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 26/12/21.
//

import UIKit

class MovieRatingCell: BaseTableViewCell<Ratings> {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var ratingSource: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var datasource: Ratings! {
        didSet {
            ratingSource.text = datasource.source
        }
    }
}
