//
//  CatagoryTableViewCell.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit

class CatagoryTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var typeNameLabel: UILabel!
        {
        didSet
        {
            typeNameLabel.alpha = 0
        }
        
    }
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var typeImage: UIImageView!
    var myCatagory:Catagory?
    {
        didSet
        {
            var imageName = "washRoom"
            switch myCatagory!.type
            {
            case .garbage:
                typeNameLabel.text = "Trash Can"

                imageName = "trashCan"
            case .washroom:
                typeNameLabel.text = "Washrooms"
            case .indraCanteen:
                typeNameLabel.text = "Canteen"
                imageName = "canteen"
            }
            typeImage.image = UIImage(named: imageName)
            overlayView.backgroundColor = generateRandomColor()
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }
    
    func animateMyLabel()  {
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseInOut,
                       animations: {
                        self.typeNameLabel.alpha = 1
        }) { (sucessFlag) in
            
        }
    }
    
    func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 0.7)
    }
    
}
