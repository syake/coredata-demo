//
//  BlogViewController.swift
//  CoreDataDemo
//
//  Created by Hiroaki Komatsu on 2016/04/02.
//  Copyright © 2016年 Hiroaki Komatsu. All rights reserved.
//

import UIKit
import CoreData

class BlogViewController: UITableViewController {

    var items: [Blog]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.items = CoreDataManager.sharedInstance.blogs

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.setRightBarButtonItems([self.editButtonItem(), self.addButtonItem()], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.items = CoreDataManager.sharedInstance.blogs
            self.tableView.reloadData()
            self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: .None)
            dispatch_async(dispatch_get_main_queue(), {() -> Void in
                self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            })
        }
        super.viewWillAppear(animated)
    }
    
    func addButtonItem() -> UIBarButtonItem {
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add:")
        return button
    }
    
    func add(sender: UIButton) {
        let controller = UIAlertController(title: "Add Article", message: "", preferredStyle: .Alert)
        controller.addTextFieldWithConfigurationHandler({(title: UITextField!) -> Void in
        })
        controller.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) -> Void in
            
            let textField = controller.textFields![0] as UITextField
            let value = textField.text
            if value != "" {
                CoreDataManager.sharedInstance.addBlog(value!)
                self.items = CoreDataManager.sharedInstance.blogs
                self.tableView.reloadData()
            }
            
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(controller, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.items == nil {
            return 0
        }
        return self.items!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        let entity = self.items![indexPath.row]
        cell.tag = indexPath.row
        if entity.title != nil {
            cell.textLabel!.text = entity.title
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if self.items != nil {
                let entity = self.items!.removeAtIndex(indexPath.row)
                CoreDataManager.sharedInstance.deleteBlog(entity.uuid!)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let tag = sender?.tag
        let controller = segue.destinationViewController as! ArticlesViewController
        controller.blog = self.items![tag!]
    }


}
