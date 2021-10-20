//
//  ViewController.swift
//  MusicLinkTest
//
//  Created by Dhruv Weaver, Grant Kilgard on 7/13/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedPlatform = pickerData[row]
        platformLabel.text = "\(selectedPlatform) link output:"
    }
    
    
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var platformPickerView: UIPickerView!
    @IBOutlet var platformLabel: UILabel!
    @IBOutlet var outputTextField: UITextField!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    var pickerData: [String] = [String]()
    let platformPickerValues = ["Spotify", "YouTube Music", "Apple Music"]
    var selectedPlatform: String = String()
    
    var song = Song(link: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadingIndicator.hidesWhenStopped = true
        
//        platformPickerView = UIPickerView()
        platformPickerView.dataSource = self
        platformPickerView.delegate = self
        
        pickerData = platformPickerValues
        selectedPlatform = pickerData[0]
        
        // allows user to tap outside of keyboard to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // continuously checks text field for changes
        inputTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        song.setDataIsSetBool(isSet: false)
    }
    
    @IBAction func clearInputButtonPressed(_ sender: Any) {
        inputTextField.text = ""
        song.setDataIsSetBool(isSet: false)
    }
    
    @IBAction func translateButtonPressed(_ sender: Any) {
        dismissKeyboard()
        print(song.dataIsSet)
        if let input = inputTextField.text {
            song.linkIn = input
        } else {
            song.linkIn = ""
        }
        
        loadingIndicator.startAnimating()
        Task.init {
            if let link = try await song.getLink(platform: selectedPlatform) {
                print(song.dataIsSet)
                self.outputTextField.text = link
            } else {
                self.outputTextField.text = "Error: no link data found"
            }
            self.loadingIndicator.stopAnimating()
        }
        
    }
    
}

