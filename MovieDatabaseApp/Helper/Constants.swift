//
//  Constants.swift
//  MovieDatabaseApp
//
//  Created by Rajat Raj on 25/12/21.
//

import Foundation
import UIKit

enum Categories: String {
case year       = "Year"
case genre      = "Genre"
case directors  = "Directors"
case actors     = "Actors"
}

class CategoryDataModel {
    var headerName: Categories?
    var subData: [String]?
    var isExpandable: Bool = false
    
    init(headerName: Categories, subData: [String], isExpandable: Bool) {
        self.headerName = headerName
        self.subData = subData
        self.isExpandable = isExpandable
    }
}

class Constants {
    static let shared = Constants()
    func loadImage(imageView: UIImageView, imageUrl: String) {
        imageView.loadImage(from: imageUrl) { (image) in
            DispatchQueue.main.async {
                if let downloadedImage = image {
                    imageView.image = downloadedImage
                } else {
                    imageView.backgroundColor = UIColor.lightGray
                }
            }
        }
    }
    func textStylingForCastAndCrew(actors: String, director: String, writer: String) -> NSMutableAttributedString {
        let mainString = "Actors: \(actors)\nDirector: \(director)\nWriter: \(writer)"
        let actorTile = "Actors:"
        let directorTile = "Director:"
        let writerTile = "Writer:"
        let actorRange = (mainString as NSString).range(of: actorTile)
        let directorRange = (mainString as NSString).range(of: directorTile)
        let writerRange = (mainString as NSString).range(of: writerTile)
        let mutableAttributedString = NSMutableAttributedString.init(string: mainString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: actorRange)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: directorRange)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemPink, range: writerRange)
        return mutableAttributedString
    }
}
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
extension UIImageView {
    func loadImage(from urlString: String?, complition: @escaping (UIImage?) -> Void) {
        let encodedUrlString = urlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlString = encodedUrlString,
              let imageURL = URL(string: urlString) else {
                  DispatchQueue.main.async {
                      complition(nil)
                  }
                  return
              }
        
        let cache =  URLCache.shared
        let request = URLRequest(url: imageURL)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    complition(image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            complition(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            complition(nil)
                        }
                    }
                }).resume()
            }
        }
    }
    func makeRounded(_ removeBorder: Bool? = nil, _ backgroundColor: UIColor? = nil, _ isRounded: Bool? = nil) {
           removeBorder == nil ? self.layer.borderWidth = 1 : nil
           if let backgroundColor = backgroundColor {
               self.image = self.image?.withRenderingMode(.alwaysTemplate)
               self.tintColor = backgroundColor
           }
           self.contentMode = isRounded ?? false ? UIView.ContentMode.scaleAspectFill : UIView.ContentMode.scaleAspectFit
           self.layer.masksToBounds = false
           self.layer.borderColor = UIColor.black.cgColor
           self.layer.cornerRadius = self.frame.height / 2
           self.clipsToBounds = true
       }
}
