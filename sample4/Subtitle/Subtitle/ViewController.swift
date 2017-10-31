//
//  ViewController.swift
//  Subtitle
//
//  Created by MonkeySolution on 10/31/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var lblBelow: UILabel!
    
    @IBAction func btnShowClicked(_ sender: UIButton) {
        
        UIView.animate(withDuration: 3) {
            self.lblAbove.frame.size.width = 250
        }
    }
    @IBOutlet weak var lblAbove: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myShadow = NSShadow()
//        myShadow.shadowBlurRadius = 3
//        myShadow.shadowOffset = CGSize(width: 0, height: lblAbove.text!.count)
//        myShadow.shadowColor = UIColor.gray
//
//        let myAttribute = [ NSAttributedStringKey.shadow: myShadow ]
//
//        let att = NSMutableAttributedString.init(string: lblAbove.text!)
//        att.addAttributes(myAttribute, range: NSRange.init(location: 0, length: self.lblAbove.text!.count))
//
//        self.lblAbove.attributedText = att
// *****
        
        
        let plainString = "salam bar to halet chetore ?"
        let attributedString = NSMutableAttributedString.init(string: plainString)
        
        let colorAttribute = [ NSAttributedStringKey.foregroundColor: UIColor.yellow ]
        
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 3
        myShadow.shadowOffset = CGSize(width: 3, height: 3)
        myShadow.shadowColor = UIColor.gray
        let myAttribute = [ NSAttributedStringKey.shadow: myShadow ]
//        attributedString.addAttributes(colorAttribute, range: NSRange(location: 1, length: 3))
        attributedString.addAttributes(myAttribute, range: NSRange(location: 0, length: self.lblAbove.text!.characters.count))
        
        
        self.lblAbove.attributedText = attributedString
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

