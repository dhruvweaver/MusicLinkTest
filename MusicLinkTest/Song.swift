//
//  Song.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver on 7/23/21.
//

import Foundation

class Song {
    var linkIn: String
    var json: JSONData? = nil
    var dataIsSet: Bool = false
    
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
        
        func valueByPropertyName(name: String) -> MusicURL {
            switch name {
            case "spotify":
                return spotify
            case "youtubeMusic":
                return youtubeMusic
            case "appleMusic":
                return appleMusic
            default: fatalError("Wrong property name")
            }
        }
    }
    
    struct MusicURL: Decodable {
        let url: String
    }
    
    init(link: String) {
        self.linkIn = link
    }
    
    enum Platform: String {
        case spotify = "Spotify", youtubeMusic = "YouTube Music", appleMusic = "Apple Music"
        
        var propertyName: String {
            switch self {
            case .spotify:
                return "spotify"
            case .youtubeMusic:
                return "youtubeMusic"
            case .appleMusic:
                return "appleMusic"
            }
        }
    }
    
    func setDataIsSetBool(isSet: Bool) {
        self.dataIsSet = isSet
    }
    
    private func setJSONData() async throws {
        if let data = try await getData(link: linkIn) {
            if let json = try? JSONDecoder().decode(JSONData.self, from: data) {
                print("assigned json data")
                print(json.linksByPlatform.spotify.url)
                print(json)
                self.json = json
                self.dataIsSet = true
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
        let platformEnum = Platform(rawValue: platform)!
        if (!self.dataIsSet) {
            try await setJSONData()
        }
        if let processedJSON = json {
            let links = processedJSON.linksByPlatform
            linkOut = links.valueByPropertyName(name: platformEnum.propertyName).url
        }
        return linkOut
    }
}

