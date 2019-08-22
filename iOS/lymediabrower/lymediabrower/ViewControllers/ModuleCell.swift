//
//  ModuleCell.swift
//  lymediabrower
//
//  Created by xianing on 2017/12/8.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit

class ModuleCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    
    var title: String! {
        didSet {
            let dict: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.strokeWidth: -3,
                NSAttributedString.Key.strokeColor: UIColor.black
            ]
            titleLabel.attributedText = NSAttributedString(string: title,
                                                           attributes: dict)
            titleLabel.textAlignment = .center
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
