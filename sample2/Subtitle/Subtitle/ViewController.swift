//
//  ViewController.swift
//  Subtitle
//
//  Created by MonkeySolution on 10/31/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var txtTop: UITextView!
    
    @IBAction func btnStart(_ sender: UIButton) {
        
        UIView.animate(withDuration: 2) {
            self.txtTop.frame.size.width = self.txtOrig.frame.size.width
        }
        
    }
    @IBOutlet weak var txtOrig: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

