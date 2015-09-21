//
//  NotECell.swift
//  NotE
//
//  Created by TSUNG-LUN LIAO on 2015/6/25.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit

class NotECell: UITableViewCell {


//    @IBOutlet weak var noteLabel: UILabel!
    
    var noteLabel:UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if (self.noteLabel == nil) {
            self.noteLabel = UILabel(frame: CGRectMake(0, 0, 200, 20))
            self.addSubview(self.noteLabel)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(note:NSString, size:CGSize){
        
        self.noteLabel.text               = note as String;
        self.noteLabel.textAlignment      = NSTextAlignment.Left;
        self.noteLabel.font               = UIFont.systemFontOfSize(15.0)
        self.noteLabel.numberOfLines      = 0
        self.noteLabel.lineBreakMode      = NSLineBreakMode.ByWordWrapping
        
        
        let expectedLabelSize:CGSize = note.boundingRectWithSize(
            size,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName:self.noteLabel.font],
            context: nil).size


        self.noteLabel.frame = CGRectMake(0, 5, expectedLabelSize.width, expectedLabelSize.height)

        
    }

}
