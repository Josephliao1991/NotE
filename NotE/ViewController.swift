//
//  ViewController.swift
//  NotE
//
//  Created by TSUNG-LUN LIAO on 2015/6/25.
//  Copyright (c) 2015年 TSUNG-LUN LIAO. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var note :NSMutableArray!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.didUpdateData()
        
        //Check Data When App Enter Did BecomeActive
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didUpdateData", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
    }

    override func viewWillAppear(animated: Bool) {
        
        self.didUpdateData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - UITableView DataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //
        return note.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! NotECell
   

        cell.configure(self.note[indexPath.row] as! NSString, size: self.view.frame.size)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //
        
        let expectedLabelSize:CGSize = self.note[indexPath.row].boundingRectWithSize(
            CGSizeMake(self.view.frame.size.width, 0),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)],
            context: nil).size
        
        return expectedLabelSize.height + 10
        
    }
    

    
// MARK: - 
   @objc private func didUpdateData(){
        
        if let data: AnyObject = NSUserDefaults(suiteName: "group.tw.tokakyo.NotE")?.objectForKey("notes"){
            
            note = data as! NSMutableArray
            
        }else{
            
            note = []
        }
        
        self.tableView.reloadData()
        
    }
    
}

