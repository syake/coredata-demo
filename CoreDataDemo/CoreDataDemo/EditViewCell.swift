//
//  EditViewCell.swift
//  CoreDataDemo
//
//  Created by Hiroaki Komatsu on 2016/04/14.
//  Copyright © 2016年 Hiroaki Komatsu. All rights reserved.
//

import UIKit

protocol EditViewCellDelegate {
    func cellTapGesture(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, selected: Bool)
}

class EditViewCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField?
    @IBOutlet weak var icon: UIImageView?
    
    var delegate: EditViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if icon != nil {
            icon!.image = icon!.image!.imageWithRenderingMode(.AlwaysTemplate)
            icon!.image!.imageWithRenderingMode(.AlwaysTemplate)
            icon!.highlightedImage = icon!.highlightedImage!.imageWithRenderingMode(.AlwaysTemplate)
            icon!.highlightedImage!.imageWithRenderingMode(.AlwaysTemplate)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("tapGesture:"))
            tapGesture.delegate = self
            icon!.addGestureRecognizer(tapGesture)
            
            sync()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var actived: Bool {
        get {
            return icon!.highlighted
        }
        set(actived) {
            icon!.highlighted = actived
            sync()
        }
    }

    func tapGesture(sender: UITapGestureRecognizer) {
        icon!.highlighted = !icon!.highlighted
        sync()
        
        let tableView = superview?.superview as! UITableView
        let tappedIndexPath = tableView.indexPathForCell(self)
        self.delegate?.cellTapGesture(tableView, cellForRowAtIndexPath: tappedIndexPath!, selected: icon!.highlighted)
        
        textField?.resignFirstResponder()
    }
    
    func sync() {
        if icon!.highlighted {
            textField?.alpha = 0.5
            icon!.tintColor = UIColor(red: 0.15294117647058825, green: 0.6823529411764706, blue: 0.3764705882352941, alpha: 1.0)
            
        } else {
            textField?.alpha = 1
            icon!.tintColor = UIColor.lightGrayColor()
        }
    }
}
