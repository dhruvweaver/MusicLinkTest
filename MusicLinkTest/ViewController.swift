//
//  ViewController.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver, Grant Kilgard on 7/13/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var outputTextField: UITextField!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var song = Song(link: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadingIndicator.hidesWhenStopped = true
    }
    // Sample link: https://music.youtube.com/watch?v=r2CaT3stL7U&feature=share
    @IBAction func translateButtonPressed(_ sender: Any) {
        if let input = inputTextField.text {
            song.link = input
        } else {
            song.link = ""
        }
        
//        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        song.getData { json in
            DispatchQueue.main.async {
                self.outputTextField.text = json.linksByPlatform.spotify.url
                self.loadingIndicator.stopAnimating()
            }
        }
    }
    
}

