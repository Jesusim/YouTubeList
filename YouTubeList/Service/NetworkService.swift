//
//  NetworkService.swift
//  YouTubeList
//
//  Created by Admin on 3/25/20.
//  Copyright © 2020 BadJesus. All rights reserved.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://www.googleapis.com/youtube/v3/"
    private let apiKey = "AIzaSyAx45WrlyGIKUNpRFnxfHPD2ueJku2aBdU"//"AIzaSyAuh39-YurQ2O56RC2tCBg2oaoWXCdZrWQ"//"AIzaSyAx45WrlyGIKUNpRFnxfHPD2ueJku2aBdU"
    
    typealias GenericCompletion<T> = (T?, Error?) -> ()
    
    enum HttpReqwestType : String {
        case Get = "GET", Post = "POST"
    }
    
    func searchVideo(searchText : String = "", nextPageToken: String = "", _ completion : GenericCompletion<YouTubeList>?) {
        
        let linkUrl = "search"
        guard let encodingUrl = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        let parametrs = ["part" : "snippet",
                         "order" : "title",
                         "videoCaption" : "closedCaption",
                         "type" : "video",
                         "pageToken": nextPageToken,
                         "maxResults" : 20,
                         "q" : encodingUrl,
                         "key": apiKey] as [String : Any]
        
        requestt(url: linkUrl, parametrs: convertParametrs(parametrs)) { ( listVideo : YouTubeList?, error) in
            
            DispatchQueue.main.async {
                completion?(listVideo, error)
            }
            
        }
        
    }
    
    private func requestt<T: Decodable>(url : String, parametrs : String = "", type : HttpReqwestType = .Get, _ completion: GenericCompletion<T>?) {
        
        let stringToUrl = baseURL + url + parametrs
        guard let url = URL(string: stringToUrl) else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = type.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion?(nil, error)
            }
            
            do {
                
                let some = try JSONDecoder().decode(T.self, from: data!)
                completion?(some, nil)
                
            } catch let error {
                completion?(nil, error)
            }
            
        }.resume()
        
    }
    
    private func convertParametrs(_ paramets : [String : Any]) -> String {
        var components : String = "?"
        paramets.forEach { (item) in
            components += "&" + "\(item.key)=\(item.value)"
        }
        return components
    }
    
}
