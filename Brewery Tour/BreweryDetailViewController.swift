//
//  BreweryDetailViewController.swift
//  Brewery Tour
//
//  Created by Alexander Pojman on 12/13/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import UIKit

class BreweryDetailViewController: UIViewController {
    
    @IBOutlet weak var breweryDescription: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    
    @IBOutlet weak var breweryNameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var brewery: Brewery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate Label
        breweryNameLabel.text = brewery.title?.uppercased()
        
        // Set Kerning
        breweryNameLabel.attributedText = kerningForText(text: breweryNameLabel.text!, amount: 5.5)
        
        // Populate Description
        breweryDescription.sizeToFit();
        breweryDescription.text = brewery.desc
        
        // Set Kerning
        breweryDescription.attributedText = kerningForText(text: breweryDescription.text!, amount: 3.0)
        
        // Add Border to UIButton
        checkInButton.layer.borderWidth = 2
        checkInButton.layer.borderColor = UIColor.lightGray.cgColor
        
        // Set Kerning for Check-in Button
        checkInButton.setAttributedTitle(kerningForText(text: checkInButton.title(for: .normal)!, amount: 5.0), for: .normal)
        
        // Nav Bar Customizations
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.black
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
        
    }
    
    func kerningForText(text: String, amount: CGFloat) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSKernAttributeName, value: CGFloat(amount), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.black, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
