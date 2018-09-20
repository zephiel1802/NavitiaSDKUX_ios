//
//  UIAutoFilled.swift
//  NavitiaSDKUI
//
//  Copyright © 2018 kisio. All rights reserved.
//

protocol UIAutoFilledLabelDelegate {
    
    func autofillDidFinish(_ target: UIAutoFilledLabel)
}

class UIAutoFilledLabel: UILabel {
    
    @IBInspectable var autofillLeftText: String?
    @IBInspectable var autofillRightText: String?
    var autofillPattern: Character?
    var delegate: UIAutoFilledLabelDelegate?
    
    override var bounds: CGRect {
        didSet {
            autoFill()
        }
    }
    
    private func autoFill() {
        guard numberOfLines > 0, text != nil, autofillPattern != nil, let autofillLeftText = autofillLeftText, let autofillRightText = autofillRightText else {
            return
        }
        
        // Init the label text with both left and right side texts including the space in between
        text = String.init(format: "%@  %@", autofillLeftText, autofillRightText)
        
        addPattern()
    }
    
    private func addPattern() {
        guard numberOfLines > 0, autofillLeftText != nil, let autofillRightText = autofillRightText, let text = text, let autofillPattern = autofillPattern else {
            return
        }
        
        // The index computing is based on the right part index
        let rightTextIndices = text.indices(of: autofillRightText)
        if let lastOccurenceIndex = rightTextIndices.last, lastOccurenceIndex - 2 > 0 {
            // If the text is truncated, then we have to stop adding the autofillpattern and remove the last pattern added
            if isTruncated {
                var screenAdaptedText = text
                screenAdaptedText.remove(at: text.index(text.startIndex, offsetBy: lastOccurenceIndex - 2))
                self.text = screenAdaptedText
                
                // At this point, the label is ready and totally filled with the given pattern
                delegate?.autofillDidFinish(self)
            } else {
                // The pattern should be added before the autofillRightText
                let mutableText = NSMutableString(string: text)
                mutableText.insert(String(autofillPattern), at: lastOccurenceIndex - 1)
                self.text = String(mutableText)
                
                // Continue adding pattern until the label text is truncated
                addPattern()
            }
        }
    }
}
