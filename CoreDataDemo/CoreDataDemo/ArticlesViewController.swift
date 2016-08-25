//
//  ArticlesViewController.swift
//  CoreDataDemo
//
//  Created by Hiroaki Komatsu on 2016/04/02.
//  Copyright © 2016年 Hiroaki Komatsu. All rights reserved.
//

import UIKit

class ArticlesViewController: UITableViewController, UITextFieldDelegate, EditViewCellDelegate {
    
    var blog: Blog?
    var items: [Article]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.setRightBarButtonItem(self.editButtonItem(), animated: true)
        
        if blog != nil {
            let textfield = UITextField(frame: CGRectMake(0, 0, (self.navigationController?.navigationBar.frame.size.width)!, 21.0))
            textfield.textAlignment = .Center
            textfield.text = blog!.title
            textfield.tag = -1
            textfield.delegate = self
            self.navigationItem.titleView = textfield
            self.items = CoreDataManager.sharedInstance.articles(blog!.uuid!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.editing = editing
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.items == nil {
            return 1
        }
        return self.items!.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: EditViewCell
        
        // Configure the cell...
        if self.items!.count > indexPath.row {
            cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! EditViewCell
            let entity = self.items![indexPath.row]
            if entity.title != nil {
                cell.textField!.text = entity.title
            }
            cell.actived = (entity.active == 1)
            
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("addIdentifier", forIndexPath: indexPath) as! EditViewCell
            cell.textField!.text = ""
            cell.textField!.becomeFirstResponder()
        }
        cell.textField!.delegate = self
        cell.textField!.tag = indexPath.row
        cell.tag = indexPath.row
        cell.delegate = self

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.reuseIdentifier == "addIdentifier" {
            return false
        }
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            // Delete the row from the data source
            if self.items != nil {
                let entity = self.items!.removeAtIndex(indexPath.row)
                CoreDataManager.sharedInstance.deleteArticle(entity.uuid!)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let text = textField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let tag = textField.tag
        if tag == -1 {
            // title edit
            if text.characters.count > 0 {
                textField.text = text
                CoreDataManager.sharedInstance.updateBlog(blog!.uuid!, title: text)
            } else {
                textField.text = blog!.title
            }
        } else if tag > -1 && self.items!.count > tag {
            // update
            let entity = self.items![tag]
            if text.characters.count > 0 {
                textField.text = text
                CoreDataManager.sharedInstance.updateArticle(entity.uuid!, title: text)
            } else {
                textField.text = entity.title
            }
        } else if self.items!.count == tag {
            // add
            if text.characters.count > 0 {
                textField.text = text
                let blog_uuid = blog!.uuid!
                CoreDataManager.sharedInstance.addArticle(blog_uuid, title: text, body: "")
                self.items = CoreDataManager.sharedInstance.articles(blog_uuid)
                self.tableView.reloadData()
            } else {
                textField.text = ""
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITextFieldDelegate
    
    func cellTapGesture(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, selected: Bool) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let entity = self.items![cell!.tag]
        CoreDataManager.sharedInstance.updateArticle(entity.uuid!, active: selected)
        
    }
}
