//
//  FindListCell.swift
//  FLMusic
//
//  Created by 冯里 on 2019/1/24.
//  Copyright © 2019 冯里. All rights reserved.
//

import UIKit

class FindListCell: UITableViewCell {
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
