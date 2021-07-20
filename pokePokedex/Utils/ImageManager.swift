//
//  ImageManager.swift
//  pokePokedex
//
//  Created by Pabel Saldivar on 20/07/21.
//

import Foundation
import UIKit

class ImageManager {
    private static let _shared = ImageManager()
    
    static var shared:ImageManager {
        return _shared
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    init() {
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?,_ oncache:Bool) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil, true)
        } else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.contains("image"),
                    let data = data,
                    let image = UIImage(data: data)
                    else { return }
                if let error = error {
                    completion(nil, error, false)
                } else {
                    self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                    completion(image,nil, false)
                }
            }.resume()
        }
    }
    
    func removeAllCacheObjs() {
        imageCache.removeAllObjects()
    }
}
