//
//  Lyrics.swift
//  LyricsCompleteModel
//
//  Created by MonkeySolution on 11/1/17.
//  Copyright © 2017 MonkeySolution. All rights reserved.
//

import Foundation
import UIKit
class Lyrics {
    
    var mainTimer : Timer? // timer that execute
    var  counter: Double = -1 // timer counter per time called
    var configuration : LyricsConfig?
    var content : LyricsModel?
    var lastShowSentencInTop : Int = -1
    var lastShowSentencInBottom : Int = -1
    var lastShowSentenc : Int = -1
     var wordSubTitleViewArray = [Int: [UILabel]]() // key is sentec index value is a subtitle word view
    
    func setLyrics(from url : URL)  {
        let jsonData = try! Data.init(contentsOf: url)
        let jsonResult = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String : Any]]
        content =  LyricsParser.parse(input: jsonResult)
    }
  
    func startShowing(){
        mainTimer = Timer.scheduledTimer(withTimeInterval: self.configuration!.timerRateCheckingJSON, repeats: true, block: { (timer) in
            self.counter += 1
            self.timerLoop()
        })
    }
    
    //MARK:- get sentences that does not show yet
    func getSentenceDoesNotShowYet()->LyricsSubtitleModel?{
        
      //  var lastIndex = lastShowSentenc
        
     //   lastShowSentenc += 1
        
        if lastShowSentenc >= 0 {
            if lastShowSentenc == 0 {
                lastShowSentenc = 1
                 return self.content!.subTitleArray[lastShowSentenc]
            }else{
               
                //print(self.content!.subTitleArray[lastShowSentenc].endTime! / 1000)
                if self.content!.subTitleArray[lastShowSentenc].endTime! / 1000 <= counter * self.configuration!.timerRateCheckingJSON {
                
               
                    
                    guard lastShowSentenc + 1 <= self.content!.subTitleArray.count - 1 else{
                        return nil
                    }
                         lastShowSentenc += 1
                    return self.content!.subTitleArray[lastShowSentenc]
                }
                return nil
            }
      
        }else{
            // this is first time
            lastShowSentenc = 0
            return self.content!.subTitleArray[lastShowSentenc]
        }
        

    }
    //MARK:- get sentences that does  show before
    func getSentenceDoseShowBefore()->LyricsSubtitleModel?{
        
        let filterdSentencArrayDoesShowingBefore = content?.subTitleArray.filter { (model) -> Bool in
            
            return ( model.startTime! / 1000 <= counter * self.configuration!.timerRateCheckingJSON &&  model.endTime! / 1000 >= counter * self.configuration!.timerRateCheckingJSON  && model.isShown)
        }
        return filterdSentencArrayDoesShowingBefore?.first
        
    }
    
    //MARK:- get this word
    func getThisWord(sentence : LyricsSubtitleModel ) -> LyricsSubtitleDetailModelModel?{
        
        
        let filterdWordArray = sentence.detail.filter { (word) -> Bool in
            
            let c1 = word.startTime! / 1000 <= counter * self.configuration!.timerRateCheckingJSON
            let c2 = (word.startTime! / 1000 + word.duration! / 1000) >= counter * self.configuration!.timerRateCheckingJSON
            
            if c1 == true , c2 == true , !word.isShown {
                return true
            }else{
                return false
            }
        
        }
         return filterdWordArray.last
    }
    
    @objc func timerLoop(){
      
        
       let newSentence = getSentenceDoesNotShowYet()
        let oldSentence = getSentenceDoseShowBefore()
        // new sentence should be write in top label or bottom label
        // old sentence should start animation
        
        if let newSentence = newSentence {
            // write sentence
            
            if newSentence.index == 23 {
              //  print("hala")
            }
            
            newSentence.isShown = true
            if self.configuration!.status.lastSentenceLocation != nil {
                if self.configuration!.status.lastSentenceLocation! == .bottom {
                    newSentence.location = .top
                }else{
                    newSentence.location = .bottom
                }
            }
            
            self.configuration!.status.lastSentenceLocation = newSentence.location
            writeSentence(text: newSentence.title!, location: newSentence.location)
            
        }
        
        
        if let oldSentence = oldSentence {

         
            if oldSentence.index! >= 34 {
               // print("hi")
            }
            
            if let thisWord = getThisWord(sentence: oldSentence) {
       
                if oldSentence.index != 15 {
                    
                }
                
                   var wordContent =  oldSentence.title!.components(separatedBy: " ")[thisWord.index!]
                
            
                 let direction = oldSentence.direction
                
                var isFirstWord = false
                var isLastWord = false
                if thisWord.index == 0 {
                    isFirstWord = true
                }
                
                if thisWord.index! == oldSentence.detail.count - 1 {
                    isLastWord = true
                }
                
         
                wordContent =  addSpaceIfNeeded(text: wordContent, direction: direction, isFirstWod: isFirstWord, isLastWord: isLastWord)
                
                removeFromWordSubTitleViewArray(currentSentenceIndex: oldSentence.index!)
                thisWord.isShown = true
                   let animationTime = thisWord.duration! / 1000
               
                let location = oldSentence.location
                
                
                play(thisWordShownigWord: wordContent, sentenceIndex: oldSentence.index!, durationAnimation: animationTime, direction: direction, lyricsWordLocation: location, isLastWordInSentenc: isLastWord)

            }
        }
        
        
  
        // ********************
        
  
    // *****************
    }
    
    func addSpaceIfNeeded(text : String , direction : LyricsLanguageType , isFirstWod : Bool , isLastWord : Bool )->String{
        var result = text
        if direction == .rtl {
            // persian
            if !isFirstWod {result.append(" ")}
        }else{
            // english
            if !isLastWord {
                result.append(" ")
            }
        }
        return result
    }
    
    
    func play(thisWordShownigWord : String , sentenceIndex sentencID : Int , durationAnimation : TimeInterval , direction : LyricsLanguageType , lyricsWordLocation : LyricsLocation , isLastWordInSentenc : Bool){
    
        let thisLable = UILabel.init()
        
        let contentString = thisWordShownigWord
   
        thisLable.text = contentString
       
        // bayad dorostesh konam ->
        
        if lyricsWordLocation == .top {
              thisLable.font = self.configuration!.topLabel.font
        }else{
              thisLable.font = self.configuration!.bottomLabel.font
        }
        
      
        // inja should check better
        setAtrebuteForLyrics(sender: thisLable, text: contentString)
         thisLable.sizeToFit()
       setDirectionForThisLabel(sender: thisLable, direction: direction)
    
        if lyricsWordLocation == .top {
            thisLable.frame.size.height = self.configuration!.topLabel.frame.size.height
            thisLable.frame.origin.y = self.configuration!.topLabel.frame.origin.y
        }else{
            thisLable.frame.size.height = self.configuration!.bottomLabel.frame.size.height
            thisLable.frame.origin.y = self.configuration!.bottomLabel.frame.origin.y
        }
     
        let allSubTitleViewsInTopView = getAllViewsInTopViewWithOriginXOrder()
        let allSubTitleViewsInBottomView = getAllViewsInBottomViewWithOriginXOrder()
      
        var destinationWidth = CGFloat(0)
        var destinationOriginX = CGFloat(0)
        

        
        if direction == .rtl {
            
            // right to left
            
            if lyricsWordLocation == .top {
                // in top
                if allSubTitleViewsInTopView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInTopView.last!.frame.origin.x
                    destinationOriginX = allSubTitleViewsInTopView.last!.frame.origin.x - thisLable.frame.size.width
                }else{
                    thisLable.frame.origin.x =    self.configuration!.topLabel.frame.origin.x + self.configuration!.topLabel.frame.size.width
                    
                    destinationOriginX = self.configuration!.topLabel.frame.origin.x + self.configuration!.topLabel.frame.size.width - thisLable.frame.size.width
                }
                
            }else{
                // in bottom
                if allSubTitleViewsInBottomView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInBottomView.last!.frame.origin.x
                    destinationOriginX = allSubTitleViewsInBottomView.last!.frame.origin.x - thisLable.frame.size.width
                }else{
                    thisLable.frame.origin.x =    self.configuration!.bottomLabel.frame.origin.x + self.configuration!.bottomLabel.frame.size.width
                    
                    destinationOriginX = self.configuration!.bottomLabel.frame.origin.x + self.configuration!.bottomLabel.frame.size.width - thisLable.frame.size.width
                }
            }
            
           
            
        }else{
            // leftr to right
            
            if lyricsWordLocation == .top {
                // top
                if allSubTitleViewsInTopView.count >= 1  {
                    
                    thisLable.frame.origin.x = allSubTitleViewsInTopView.first!.frame.origin.x + allSubTitleViewsInTopView.first!.frame.size.width
                   
                    destinationOriginX = thisLable.frame.origin.x
                    
                }else{
                    thisLable.frame.origin.x =    self.configuration!.topLabel.frame.origin.x
                    
                    destinationOriginX = thisLable.frame.origin.x
                }
            }else{
                // bottom
                if allSubTitleViewsInBottomView.count >= 1  {
                    
                    
                    
                    thisLable.frame.origin.x = allSubTitleViewsInBottomView.first!.frame.origin.x + allSubTitleViewsInBottomView.first!.frame.size.width
                  
                    destinationOriginX = thisLable.frame.origin.x
                    
                }else{
                    thisLable.frame.origin.x =    self.configuration!.bottomLabel.frame.origin.x
                    
                    destinationOriginX = thisLable.frame.origin.x
                }
            }
            
           
        }

        destinationWidth =  thisLable.frame.size.width
        thisLable.frame.size.width = 0
        thisLable.backgroundColor = UIColor.white
       thisLable.numberOfLines
         = 0
        thisLable.lineBreakMode = .byCharWrapping

        if lyricsWordLocation == .top {
            self.configuration!.topView.addSubview(thisLable)
            //#->  if isFirstWordInSentence {self.configuration!.status.lastWordLocation = .top}
        }else{
            self.configuration!.bottomView.addSubview(thisLable)
            //#-> if isFirstWordInSentence {self.configuration!.status.lastWordLocation = .bottom}
        }
        
        
        expandViewWithAnimation(sender: thisLable, animationTime: durationAnimation,  destinationWidth: destinationWidth, destinationOriginX: destinationOriginX, isLastWordInSentence: isLastWordInSentenc, sentenceID: sentencID, location: lyricsWordLocation)
        
       
        self.insertToWordSubTitleViewArray(key: sentencID, view: thisLable)
    }

    
    func insertToWordSubTitleViewArray(key : Int , view : UILabel){
        
        if self.wordSubTitleViewArray[key] != nil {
            
            self.wordSubTitleViewArray[key]?.append(view)
            
        }else{
            
            let thisView = [view]
            
            self.wordSubTitleViewArray[key] = thisView
            
        }    
    }
   private func removeFromWordSubTitleViewArray(currentSentenceIndex : Int){
        
        if let labelArray = self.wordSubTitleViewArray[currentSentenceIndex-1] {
            for item in labelArray {
                item.removeFromSuperview()
            }
        }

         self.wordSubTitleViewArray[currentSentenceIndex-1]?.removeAll()
    }
 
   private func setAtrebuteForLyrics(sender : UILabel , text : String){
        let strokeTextAttributes = [
            NSAttributedStringKey.strokeColor : UIColor.black,
            NSAttributedStringKey.foregroundColor : UIColor.orange,
            NSAttributedStringKey.strokeWidth : -3.0,
            NSAttributedStringKey.font : UIFont.init(name: "BYekan", size: 18)!
            ] as [NSAttributedStringKey : Any] as [NSAttributedStringKey : Any]
        sender.attributedText = NSAttributedString(string: text , attributes: strokeTextAttributes)

    }
    
   private func setDirectionForThisLabel(sender : UILabel , direction : LyricsLanguageType ){
       
        
        if direction == .rtl {
            // rtl
            sender.contentMode = .right
            sender.semanticContentAttribute = .forceRightToLeft
            self.configuration!.topView.contentMode = .right
             self.configuration!.topView.semanticContentAttribute = .forceRightToLeft
            
        }else{
            // ltr
            sender.contentMode = .left
            sender.semanticContentAttribute = .forceLeftToRight
            self.configuration!.topView.contentMode = .left
            self.configuration!.topView.semanticContentAttribute = .forceLeftToRight
        }
        
    }
  
    
    
    private func writeNewSentence(blocks : [(content : String , position : LyricsLocation)]){
        
        
        for sentence in blocks {
            
            if sentence.position == .top {
                setTextForTopLabel(text:sentence.content)
            }else{
                setTextForBottomLabel(text:sentence.content)
            }
            
            
        }
        
        
        
    }
    
    private func setLyricsToEmpty(location : LyricsLocation){

        if location == .top {
            self.configuration!.topLabel.text = ""
        }else{
            self.configuration!.bottomLabel.text = ""
        }
        
    }
    
    
    //MARK:- get all view in top view
    
    private func getAllViewsInTopViewWithOriginXOrder() -> [UIView] {
        
        var allSubTitleViewsInTopView = [UIView]()
       
        
        for view in self.configuration!.topView.subviews where view.tag != 999 {
            // for each view in top view insted of topLabel in configuration
            // 999 tag is for lblTop in viewController (main label)
            allSubTitleViewsInTopView.append(view)
        }
        
        allSubTitleViewsInTopView.sort { (view1, view2) -> Bool in
            return view1.frame.origin.x > view2.frame.origin.x
        }
        
        
      return allSubTitleViewsInTopView
        
    }
    
    
    //MAEK:- get all views in bottom view
    
    private func getAllViewsInBottomViewWithOriginXOrder() -> [UIView] {
         var allSubTitleViewsInBottomView = [UIView]()
        for view in self.configuration!.bottomView.subviews where view.tag != 888 {
            // for each view in top view insted of topLabel in configuration
            // 888 tag is for lblBottom in viewcontroller (main label)
            allSubTitleViewsInBottomView.append(view)
        }
        allSubTitleViewsInBottomView.sort { (view1, view2) -> Bool in
            return view1.frame.origin.x > view2.frame.origin.x
        }
     return allSubTitleViewsInBottomView
    }
    
    //MARK:- set frame for word lyrics
    private func setFrameForWord(direction : LyricsLanguageType , location : LyricsLocation , allViewsInTopView : [UIView] , allViewsInBottomView : [UIView] , sender : UILabel){
        
        
    }
    //MARK:- writeSentece
    
    private func writeSentence(text : String , location : LyricsLocation){
        
        if location == .top {
            setTextForTopLabel(text: text)
        }else{
            setTextForBottomLabel(text: text)
        }
    }
    
    //MARK:- write sentence in Top
    private func setTextForTopLabel(text : String){
        self.configuration?.topLabel.text = text
        self.configuration!.topLabel.sizeToFit()
        self.configuration!.topLabel.frame.origin.x = (self.configuration!.topView.bounds.size.width - configuration!.topLabel.frame.size.width) / 2
        self.configuration?.topLabel.frame.size.height = self.configuration!.topView.bounds.size.height
    }
    //MARK:- write sentence in bottom
    private func setTextForBottomLabel(text : String){
        
        self.configuration?.bottomLabel.text = text
        self.configuration!.bottomLabel.sizeToFit()
        self.configuration!.bottomLabel.frame.origin.x = (self.configuration!.bottomView.bounds.size.width - configuration!.bottomLabel.frame.size.width) / 2
        self.configuration?.bottomLabel.frame.size.height = self.configuration!.bottomView.bounds.size.height
    }
     private func writeSentenceWithoutAnimation(content : String , direction : LyricsLanguageType){
        
    }
    private func expandViewWithAnimation(sender : UIView , animationTime : TimeInterval , destinationWidth : CGFloat , destinationOriginX : CGFloat , isLastWordInSentence : Bool , sentenceID : Int , location
        : LyricsLocation){
        
        UIView.animate(withDuration: animationTime, animations: {
            
            sender.frame.origin.x = destinationOriginX
            sender.frame.size.width =  destinationWidth
            
        }) { (complete) in
            
            if complete , isLastWordInSentence {
                
                self.removeFromWordSubTitleViewArray(currentSentenceIndex: sentenceID + 1)
               // self.setLyricsToEmpty(location: location)
                self.showNextTwoSentenc(currentSentecID: sentenceID, location: location)
                
            }
        }
        
       
        
    }
    func showNextTwoSentenc(currentSentecID : Int , location : LyricsLocation){
        
        guard  currentSentecID + 2 <= self.content!.subTitleArray.count-1 else{
            // means this is the lastest sentec in top or bottom
            return
        }
        
        if  location == .top {
            self.configuration!.topLabel.text = self.content!.subTitleArray[currentSentecID + 2].title
        }else{
            self.configuration!.bottomLabel.text = self.content!.subTitleArray[currentSentecID + 2].title
        }
    }
}
