//
//  Song.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver on 7/23/21.
//

import Foundation

class Song {
    var link: String
    var json: JSONData? = nil
    
    struct JSONData: Decodable {
        let linksByPlatform: Links
    }
    
    struct Links: Decodable {
        let amazonMusic: MusicURL
        let amazonStore: MusicURL
        let deezer: MusicURL
        let appleMusic: MusicURL
        let itunes: MusicURL
        let napster: MusicURL
        let pandora: MusicURL
        let soundcloud: MusicURL
        let spotify: MusicURL
        let tidal: MusicURL
        let yandex: MusicURL
        let youtube: MusicURL
        let youtubeMusic: MusicURL
    }
    
    struct MusicURL: Decodable {
        let url: String
    }
    
    init(link: String) {
        self.link = link
    }
    
    private func getSongData(link: String, completion: @escaping (Data) -> Void) {
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
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }
            
            task.resume()
            
        }
    }
    
    func getData(completion: @escaping (JSONData) -> Void) {
        getSongData(link: link) { data in
            DispatchQueue.main.async {
                if let json = try? JSONDecoder().decode(JSONData.self, from: data) {
                    self.json = json
                    completion(json)
                }
            }
        }
    }
}
