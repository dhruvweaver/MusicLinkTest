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
    
    // structure for decoding JSON tree
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
    
    private func getJSONData() async throws {
        if let data = try await getData(link: link) {
            if let json = try? JSONDecoder().decode(JSONData.self, from: data) {
                print("assigned json data")
                print(json.linksByPlatform.spotify.url)
                print(json)
                self.json = json
            } else {
                print("could not assign json data")
            }
        }
    }
    
    /**
     Uses completion handler to get data from API.
     - Parameter link: Link to be encoded and used for GET request
     */
    private func getData(link: String) async throws -> Data? {
        // encode link
        let encodedLink = link.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let songData: Data?
        if let encodedLink = encodedLink {
            guard let url = URL(string: "https://api.song.link/v1-alpha.1/links?url=\(encodedLink)") else {
                return nil
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // need to write proper errors using throw
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Error: could not get response")
                return nil
            }
            
            songData = data
            print("assigned data")
        } else {
            print("could not parse link")
            songData = nil
        }
        
        return songData
    }
    
    /**
     Sets the json parameter of a Song object to the JSON data gathered from the song.link API and returns a requested link
     */
    func getLink(platform: String) async throws -> String? {
        var linkOut: String? = nil
        try await getJSONData()
        if let processedJSON = json {
            linkOut = platform + ": " + processedJSON.linksByPlatform.spotify.url
        }
        return linkOut
    }
}

