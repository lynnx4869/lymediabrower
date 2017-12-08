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
            let dict: [NSAttributedStringKey: Any] = [
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17),
                NSAttributedStringKey.strokeWidth: -3,
                NSAttributedStringKey.strokeColor: UIColor.black
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
