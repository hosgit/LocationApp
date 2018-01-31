//
//  TutorialCollectionViewCell.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var tutorialImage: UIImageView!
    var tutotial:Tutorial?
    {
        didSet
        {
            tutorialImage.image = tutotial?.image
        }
    }
}
