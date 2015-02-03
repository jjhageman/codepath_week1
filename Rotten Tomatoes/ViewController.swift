//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Jeremy Hageman on 2/2/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    override func overrideTraitCollectionForChildViewController(childViewController: UIViewController) -> UITraitCollection! {
        <#code#>
    } func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(<#identifier: String#>)
        let cell = UITableViewCell(style: <#UITableViewCellStyle#>, reuseIdentifier: nil)
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
    }

}

