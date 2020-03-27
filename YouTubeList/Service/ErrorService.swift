//
//  ErrorService.swift
//  YouTubeList
//
//  Created by Admin on 3/26/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation
import UIKit

class ErrorService {
    
    static let shared = ErrorService()
    private init() {}
    
    func setError(viewController: UIViewController, titelError: String? = StringResource.error, messageError : String? = StringResource.error) {
        let alert = UIAlertController(title: titelError, message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: StringResource.okString, style: .default) { (_) in })
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
