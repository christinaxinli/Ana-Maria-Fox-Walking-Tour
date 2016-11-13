//
//  diaryEntryTableViewCell.swift
//  slg - beta - 2
//
//  Created by Sean Keenan on 9/5/16.
//  Copyright © 2016 Christina li. All rights reserved.
//

import UIKit

class diaryEntryTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var diaryPhoto: UIImageView!
    @IBOutlet weak var diaryText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
