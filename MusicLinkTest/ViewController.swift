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
    
    @IBAction func clearInputButtonPressed(_ sender: Any) {
        inputTextField.text = ""
    }
    
    @IBAction func translateButtonPressed(_ sender: Any) {
        if let input = inputTextField.text {
            song.link = input
        } else {
            song.link = ""
        }
        
        loadingIndicator.startAnimating()
        Task.init {
            if let link = try await song.getLink() {
                self.outputTextField.text = link
            } else {
                self.outputTextField.text = "Error: no link data found"
            }
            self.loadingIndicator.stopAnimating()
        }
        
    }
    
}

