//
//  SubDataTableCell.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import UIKit

class SubDataTableCell: BaseTableViewCell<String> {

    @IBOutlet private weak var subDataLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var datasource: String! {
        didSet {
            subDataLabel.text = datasource
        }
    }
}
