//
//  CatalogTableViewCell.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/30.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {
    
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var japaneseLabel: UILabel!
    @IBOutlet weak var heartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
