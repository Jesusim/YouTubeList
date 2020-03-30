//
//  LoadImage.swift
//  YouTubeList
//
//  Created by Admin on 3/27/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import UIKit

protocol LoadImage {
    func getImageByURl(url : String, _ completion : @escaping (UIImage)->())
    func getDataByURL(url : String) -> Data
}

extension LoadImage {
    
    func getImageByURl(url : String, _ completion : @escaping (UIImage)->())  {
        DispatchQueue.global().async {
            if let image = UIImage(data: self.getDataByURL(url: url)) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
    
    func getDataByURL(url : String) -> Data {
        guard
            let url = URL(string: url),
            let data = try? Data(contentsOf: url)
            else { return Data() }
        return data
    }
    
}
