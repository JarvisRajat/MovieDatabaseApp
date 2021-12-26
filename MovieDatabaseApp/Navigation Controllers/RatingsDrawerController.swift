//
//  RatingsDrawerController.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 26/12/21.
//

import UIKit

protocol RatingDataFetch {
    func dataPass(ratingData: [Ratings])
}

class RatingsDrawerController: UIViewController {

    @IBOutlet private weak var ratingSourceTableView: UITableView!
    var ratingsSources = [Ratings]()
    var ratings = [Ratings]()
    var delegate: RatingDataFetch?
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightButtonItem = UIBarButtonItem.init(
              title: "Done",
              style: .done,
              target: self,
              action: #selector(rightButtonAction(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
        cellRegister()
    }
    @objc func rightButtonAction(sender: UIBarButtonItem) {
        ratings.removeAll()
        if let selectedRows = ratingSourceTableView.indexPathsForSelectedRows {
            for iPath in selectedRows {
                ratings.append(ratingsSources[iPath.row])
            }
        }
        if !ratings.isEmpty {
        delegate?.dataPass(ratingData: ratings)
        navigationController?.popViewController(animated: true)
        }
    }
    private func cellRegister() {
        ratingSourceTableView.register(UINib(nibName: "MovieRatingCell", bundle: Bundle.main), forCellReuseIdentifier: "MovieRatingCell")
    }
}
extension RatingsDrawerController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ratingsSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieRatingCell", for: indexPath) as? MovieRatingCell
        else { return UITableViewCell() }
        cell.datasource = ratingsSources[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ratingSourceTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        ratingSourceTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
