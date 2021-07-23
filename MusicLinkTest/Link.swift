//
//  Link.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver on 7/13/21.
//

import Foundation

class Link {
    var link: String
    var data: String? = nil {
        didSet {
            print(data!)
        }
    }
    
    init(link: String) {
        self.link = link
    }
    
    private func getSongData(link: String, completion: @escaping (String) -> Void) {
        let encodedLink = link.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        if let encodedLink = encodedLink {
            guard let url = URL(string: "https://api.song.link/v1-alpha.1/links?url=\(encodedLink)") else {
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard error == nil else {
                    print("Error: error calling GET")
                    print(error!)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                    print("Error: HTTP request failed")
                    return
                }
                
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        DispatchQueue.main.async {
                            completion(jsonString)
                        }
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func getData(completion: @escaping (String) -> Void) {
        getSongData(link: link) { data in
            DispatchQueue.main.async {
                self.data = data
                completion(data)
            }
        }
    }
}
