//
//  MovieHeaderCell.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import UIKit
protocol HeaderDelegate {
    func callHeader(idx: Int)
}

class MovieHeaderCell: BaseHeaderFooterView<CategoryDataModel> {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var categoriesTitle: UILabel!
    @IBOutlet private weak var chevronButton: UIButton!
    
    var secIndex: Int?
    var delegate: HeaderDelegate?
        override var datasource: CategoryDataModel! {
            didSet {
                (datasource.isExpandable) ? setExpanded() : setCollapsed()
                categoriesTitle.text = datasource.headerName?.rawValue
            }
        }
        private func setExpanded() {
            chevronButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            chevronButton.tintColor = .systemGray
        }
        private func setCollapsed() {
            chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            chevronButton.tintColor = .systemGray
      }
    
    @IBAction func chevronButtonAction(_ sender: Any) {
        if let index = secIndex {
            delegate?.callHeader(idx: index)
        }
    }
    
}
