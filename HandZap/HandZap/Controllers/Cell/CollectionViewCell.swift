//
//  CollectionViewCell.swift
//  HandZap
//
//  Created by Chandra Rao on 24/02/20.
//  Copyright © 2020 Chandra Rao. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var innerView: UIView!

    func configureUI() {
        DispatchQueue.main.async {
            self.innerView.layer.masksToBounds = true
            self.innerView.layer.cornerRadius = 5.0
        }
    }
}
