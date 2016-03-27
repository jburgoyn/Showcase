//
//  MaterialTextField.swift
//  ShowcaseJB
//
//  Created by Jonny B on 2/6/16.
//  Copyright © 2016 Jonny B. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
        
    }
    
    //For placeholder text to be offset to the right
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, 10, 0)
    }
    
    //For entering text to be offset to the right
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        
        return CGRectInset(bounds, 10, 0)
    }

}
