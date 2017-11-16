//
//  FileCell.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import Kingfisher

class FileCell: UITableViewCell {
    
    var itemName: String! {
        didSet {
            title.text = itemName
        }
    }
    var type: String! {
        didSet {
            if type != "image" {
                icon.image = UIImage(named: type)
            }
            
            if type == "directory" {
                arrow.isHidden = false
            } else {
                arrow.isHidden = true
            }
        }
    }
    var playPath: String! {
        didSet {
            if type == "image" && playPath != "" {
                let urlString = (Consts.rootUrl() + playPath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                icon.kf.setImage(with: URL(string: urlString))
            }
        }
    }
    
    @IBOutlet fileprivate weak var icon: UIImageView!
    @IBOutlet fileprivate weak var title: UILabel!
    @IBOutlet fileprivate weak var arrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
