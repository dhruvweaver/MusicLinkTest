//
//  ViewController.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver on 7/13/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var outputTextField: UITextField!
    
    var link = Link(linkIn: "", linkOut: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func translateButtonPressed(_ sender: Any) {
        if let input = inputTextField.text {
            link.linkIn = input
        } else {
            link.linkIn = ""
        }
        link.translateLink()
        outputTextField.text = link.linkOut
    }

}

