//
//  HelpService.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import UIKit

class HelpService {
    
    static let shared = HelpService()
    private init() {}
    
    func setError(viewController: UIViewController, titelError: String? = StringResource.error, messageError : String? = StringResource.error) {
        let alert = UIAlertController(title: titelError, message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringResource.okString, style: .default) { (_) in })
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func dowloadImageAndSetIt(stringUrl : String, completion : @escaping (UIImage?) -> ()) {
        guard
            let url = URL(string: stringUrl),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data)
            else { return }
        completion(image)
    }
    
}
