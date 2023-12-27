//
//  ImageLoader.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 10.12.2023.
//

import UIKit

class ImageLoader {
    
    static func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }
        
        task.resume()
    }
    
    static func loadAndShowImage(from imageUrlString: String, to imageView: UIImageView) {
        loadImage(from: imageUrlString) { image in
            imageView.alpha = 0.5
            if let image = image {
                imageView.image = image
            }
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                imageView.alpha = 1.0
                }, completion: nil)
        }
    }
}
