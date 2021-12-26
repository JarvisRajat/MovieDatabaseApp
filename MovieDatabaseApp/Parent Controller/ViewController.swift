//
//  ViewController.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating {
    let movieData = DataLoader().movieData
    var categoryData = [String: [String]]()
    var movieSections = [CategoryDataModel]()
    let searchController = UISearchController(searchResultsController: MovieListViewController())
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI() {
        cellRegister()
        searchController.searchResultsUpdater = self
        let placeholder = NSAttributedString(string: "Search Movies by title/actor/genre/director", attributes: [.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 16)!])
        searchController.searchBar.searchTextField.attributedPlaceholder = placeholder
        navigationItem.searchController = searchController
        setupData()
    }
    private func cellRegister() {
        tableView.register(UINib(nibName: "MovieHeaderCell", bundle: Bundle.main),
                           forHeaderFooterViewReuseIdentifier: "MovieHeaderCell")
        tableView.register(UINib(nibName: "SubDataTableCell", bundle: Bundle.main), forCellReuseIdentifier: "SubDataTableCell")
    }
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        let vc = searchController.searchResultsController as? MovieListViewController
        vc?.movieListData = movieData.filter({value in
            if let title = value.title?.lowercased(),
               let genre = value.genre?.lowercased(),
               let actors = value.actors?.lowercased(),
               let director = value.director?.lowercased() {
                return   (title.contains(text.lowercased()) || genre.contains(text.lowercased()) || actors.contains(text.lowercased())  || director.contains(text.lowercased()))
            }
            return false
        })
        vc?.calledFromPresentingController = true
        vc?.movieListTableView.reloadData()
    }
    private func setupData() {
        for values in movieData {
            if let year = values.year?.components(separatedBy: ", "),
               let genre = values.genre?.components(separatedBy: ", "),
               let director = values.director?.components(separatedBy: ", "),
               let actors = values.actors?.components(separatedBy: ", ") {
                categoryData[Categories.year.rawValue] = (categoryData[Categories.year.rawValue] ?? []) + year
                categoryData[Categories.genre.rawValue] = (categoryData[Categories.genre.rawValue] ?? []) + genre
                categoryData[Categories.directors.rawValue] = (categoryData[Categories.directors.rawValue] ?? []) + director
                categoryData[Categories.actors.rawValue] = (categoryData[Categories.actors.rawValue] ?? []) + actors
            }
        }
        categoryData[Categories.year.rawValue] = categoryData[Categories.year.rawValue]?.removingDuplicates().filter { $0 != "N/A" }
        categoryData[Categories.genre.rawValue] = categoryData[Categories.genre.rawValue]?.removingDuplicates().filter { $0 != "N/A" }.sorted(by: {$0 < $1})
        categoryData[Categories.directors.rawValue] = categoryData[Categories.directors.rawValue]?.removingDuplicates().filter { $0 != "N/A" }.sorted(by: {$0 < $1})
        categoryData[Categories.actors.rawValue] = categoryData[Categories.actors.rawValue]?.removingDuplicates().filter { $0 != "N/A" }.sorted(by: {$0 < $1})
        categoryData[Categories.year.rawValue] = (categoryData[Categories.year.rawValue] ?? []).sorted(by: { (Int($0) ?? 0) < (Int($1) ?? 0) })
        movieSections = [CategoryDataModel(headerName: .year, subData: (categoryData[Categories.year.rawValue] ?? []), isExpandable: false),
                         CategoryDataModel(headerName: .genre, subData: (categoryData[Categories.genre.rawValue] ?? []), isExpandable: false),
                         CategoryDataModel(headerName: .directors,
                                           subData: (categoryData[Categories.directors.rawValue] ?? []), isExpandable: false),
                         CategoryDataModel(headerName: .actors, subData: (categoryData[Categories.actors.rawValue] ?? []), isExpandable: false)]
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieSections.count
    }
}
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubDataTableCell", for: indexPath) as? SubDataTableCell
        else { return UITableViewCell() }
        cell.datasource = movieSections[indexPath.section].subData?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movieSections[section].isExpandable {
            return (movieSections[section].subData?.count ?? 0)
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MovieHeaderCell") as? MovieHeaderCell
        else { return UIView() }
        headerView.delegate = self
        headerView.secIndex = section
        headerView.datasource = movieSections[section]
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navController = MovieListViewController(nibName: "MovieListViewController", bundle: nil)
        var filteredData = [MovieData]()
        switch indexPath.section {
        case 0:
            filteredData = movieData.filter({value in
                if let year = value.year {
                    return   year.contains(categoryData[Categories.year.rawValue]?[indexPath.row] ?? "")
                }
                return false
            })
        case 1:
            filteredData = movieData.filter({value in
                if let genre = value.genre?.lowercased() {
                    return   genre.contains(categoryData[Categories.genre.rawValue]?[indexPath.row].lowercased() ?? "")
                }
                return false
            })
        case 2:
            filteredData = movieData.filter({value in
                if let director = value.director?.lowercased() {
                    return   director.contains(categoryData[Categories.directors.rawValue]?[indexPath.row].lowercased() ?? "")
                }
                return false
            })
        default:
            filteredData = movieData.filter({value in
                if let actors = value.actors?.lowercased() {
                    return   actors.contains(categoryData[Categories.actors.rawValue]?[indexPath.row].lowercased() ?? "")
                }
                return false
            })
        }
        navController.movieListData = filteredData
        navController.calledFromPresentingController = false
        navigationController?.pushViewController(navController, animated: true)
    }
}
extension ViewController: HeaderDelegate {
    func callHeader(idx: Int) {
        movieSections[idx].isExpandable = !movieSections[idx].isExpandable
        tableView.reloadSections([idx], with: .automatic)
    }
}
