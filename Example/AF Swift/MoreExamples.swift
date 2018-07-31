//
//  MoreExamples.swift
//  FA Swift
//
//  Created by Patrik Vaberer on 1/30/17.
//  Copyright © 2017 Patrik Vaberer. All rights reserved.
//

import UIKit

class MoreExamples: UIViewController {
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        stepper.setFABackgroundImage(icon: .FAGithub, forState: .normal)
        stepper.setFAIncrementImage(icon: FASolid.FASBell, forState: .normal)
        stepper.setFADecrementImage(icon: FASolid.FASBellSlash, forState: .normal)
        
        
        image1.image = UIImage.init(bgIcon: FASolid.FASSquare, bgTextColor: .black, topIcon: FASolid.FASTerminal, topTextColor: .white, bgLarge: true, size: CGSize(width: 50, height: 50))
        image2.image = UIImage.init(bgIcon: FASolid.FASBan, bgTextColor: .red, topIcon: FASolid.FASCamera, topTextColor: .black,size: CGSize(width: 50, height: 50))
        
        
        button1.setFATitleColor(color: .blue)
        button1.setFAText(prefixText: "follow me on ", icon: FABrands.FABTwitter, postfixText: ". Thanks!", size: 25, forState: .normal, iconSize: 30)
        
        
        textField.setRightViewFAIcon(icon: FASolid.FASSearch, rightViewMode: .always, textColor: .black, backgroundColor: .clear, size: nil)
        textField.setLeftViewFAIcon(icon: FASolid.FASPlus, leftViewMode: .always, textColor: .black, backgroundColor: .clear, size: nil)
        
        
        slider.setFAMinimumValueImage(icon: FASolid.FASBellSlash)
        slider.setFAMaximumValueImage(icon: FASolid.FASBell)
    }
}
