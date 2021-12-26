//
//  DataLoader.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import Foundation
public class DataLoader {
    @Published var movieData = [MovieData]()
    
    init() {
        loadData()
    }
    
    private func loadData() {
        if let filePath = Bundle.main.url(forResource: "movies", withExtension: "json") {
            do {
                let data = try Data(contentsOf: filePath)
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([MovieData].self, from: data)
                self.movieData = dataFromJson
            } catch {
                print(error)
            }
        }
    }
}
