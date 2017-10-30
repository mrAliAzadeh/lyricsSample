//
//  ViewController.swift
//  Sample
//
//  Created by MonkeySolution on 10/30/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var bottomText: UITextView!
    
    @IBAction func btnRestetClicked(_ sender: UIButton) {
        self.topText.text = ""
    }
    @IBAction func btnShowClicked(_ sender: UIButton) {
         let content = "سلام بر تو حالت چه طوره اوضاع احوال خوبه ؟"
        self.topText.animate(newText: content, characterDelay: 0.1)
        
       
        
    }
    @IBOutlet weak var topText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UITextView {
    
    func animate(newText: String, characterDelay: TimeInterval) {
        
        DispatchQueue.main.async {
            
            self.text = ""
            
            for (index, character) in newText.characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    
}
