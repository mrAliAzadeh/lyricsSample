//
//  ViewController.swift
//  subTitleSample
//
//  Created by MonkeySolution on 10/31/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func btnClicked(_ sender: UIButton) {
      
    let frame = self.lblTitle.boundingRectForCharacterRange(range: NSRange.init(location: 2, length: 5))
    
        let lbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
     // let lbl =   UILabel.init(frame: frame!)
        self.view.insertSubview(lbl, belowSubview: lblTitle)
        lbl.backgroundColor = UIColor.purple
        lbl.frame.origin.x = lblTitle.frame.origin.x + frame!.origin.x
        lbl.frame.origin.y = lblTitle.frame.origin.y
        lbl.frame.size.width = 0
        lbl.frame.size.height = self.lblTitle.bounds.height
        UIView.animate(withDuration: 2) {
            lbl.frame.size.width = frame!.size.width
        }
        
        
    }
    
    
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension UILabel {
    func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: bounds.size)
        textContainer.lineFragmentPadding = 0.0
        
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        
        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}
