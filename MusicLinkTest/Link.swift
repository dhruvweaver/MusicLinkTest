//
//  Link.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver on 7/13/21.
//

import Foundation

struct Link {
    var linkIn: String = ""
    var linkOut: String = ""
    
    init(linkIn: String, linkOut: String) {
        self.linkIn = linkIn
        self.linkOut = linkOut
    }
    
    mutating func translateLink() {
        linkOut = "out:\(linkIn)"
    }
}
