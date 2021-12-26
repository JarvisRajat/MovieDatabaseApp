//
//  MovieListViewController.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import UIKit

class MovieListViewController: UIViewController {

    @IBOutlet weak var movieListTableView: UITableView!
    var movieListData = [MovieData]()
    var calledFromPresentingController = false
    override func viewDidLoad() {
        super.viewDidLoad()
        cellRegister()
    }
    
    private func cellRegister() {
        movieListTableView.register(UINib(nibName: "MovieDetailsCell", bundle: Bundle.main), forCellReuseIdentifier: "MovieDetailsCell")
      }
}
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieListData.count
    }
}
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell", for: indexPath) as? MovieDetailsCell
        else { return UITableViewCell() }
        cell.datasource = movieListData[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetController = MovieDetailsController(nibName: "MovieDetailsController", bundle: nil)
        targetController.movieData = movieListData[indexPath.row]
        if calledFromPresentingController {
            presentingViewController?.navigationController?.pushViewController(targetController, animated: true)
        } else {
            navigationController?.pushViewController(targetController, animated: true)
        }
    }
}
