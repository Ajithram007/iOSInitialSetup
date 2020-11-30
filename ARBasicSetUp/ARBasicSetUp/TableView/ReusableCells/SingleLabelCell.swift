//
//  SingleLabelCell.swift
//  MrCooper
//
//  Created by Ajithram on 30/11/20.
//

import UIKit

class SingleLabelCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}


extension SingleLabelCell: TableViewCellDataPopulation {
    func populate(_ data: Any) {
        if let labelData = data as? LabelConstraints {
            label.numberOfLines = 0
            self.leadingConstraint.constant = labelData.leadingAndTrailingSpace
            self.trailingConstraint.constant = labelData.leadingAndTrailingSpace
            self.topConstraint.constant = labelData.topSpace
            self.bottomConstraint.constant = labelData.bottomSpace
            label.text = labelData.labelData
            self.backgroundColor = labelData.cellBackgroundColor
        }
    }
}


class LabelConstraints: NSObject {
    var leadingAndTrailingSpace: CGFloat = 16.0
    var topSpace: CGFloat = 8.0
    var bottomSpace: CGFloat = 8.0
    var labelData: String  = ""
    var cellBackgroundColor: UIColor = UIColor.white
    
    override init() {
        super.init()
    }
    
    public init?(leadingAndTrailingSpace: CGFloat? = 16.0, topSpace: CGFloat? = 8.0, bottomSpace: CGFloat? = 8.0, labelData: String? = "", cellBackgroundColor: UIColor = UIColor.white) {
        super.init()
        
        self.leadingAndTrailingSpace = leadingAndTrailingSpace ?? 16.0
        self.topSpace = topSpace ?? 8.0
        self.bottomSpace = bottomSpace ?? 8.0
        self.labelData = labelData ?? ""
        self.cellBackgroundColor = cellBackgroundColor
    }
}
