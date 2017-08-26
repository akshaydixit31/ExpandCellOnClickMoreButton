//
//  ViewController.swift
//  AddMoreButtonInCell
//
//  Created by Appinventiv Technologies on 26/08/17.
//  Copyright © 2017 Appinventiv Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
//=========== Variables ================
    let itemList = ["Apple","Lava","MI","Samsung","Sony","Vivo","Window"]   //
     let mobImages = [UIImage(named: "iphone"),UIImage(named: "lava"),UIImage(named: "mi"),UIImage(named: "samsung"),UIImage(named: "sony"),UIImage(named: "vivo"),UIImage(named: "window")] //
    var hieght: CGFloat = 200
    var expandedCells = [Int]()
    var isSelect = false
//=========== Outlet's =================
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
   }
    @IBAction func moreButtonTapped(_ sender: UIButton) {
//==== Create cellObject and indexPath-------------
        guard   let cell = getCell(sender) as? CellData else{fatalError()}
//        guard let indexPath = self.tableView.indexPath(for: cell) else {fatalError()}
//  ==============================================================
        if isSelect == false{
            cell.moreButton.setTitle("Hide", for: .normal)
            isSelect = true
        }else{
            cell.moreButton.setTitle("more", for: .normal)
            isSelect = false
        }
        
        if expandedCells.contains(sender.tag) {
            expandedCells = expandedCells.filter({ $0 != sender.tag})
        }
        else {
            expandedCells.append(sender.tag)
        }
        tableView.reloadData()
    }
}
//================= TableView method's ======================

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
      if expandedCells.contains(indexPath.row) {
            return 200
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellData", for: indexPath) as? CellData else{
            fatalError()
        }
        cell.moreButton.tag = indexPath.row
        cell.imageIcon.image = mobImages[indexPath.row]
        cell.nameLabel.text = itemList[indexPath.row]
        cell.hideImageIcon.image = mobImages[indexPath.row]
        return cell
    }
    //------------------------- Method's of class----------------------------
    func getCell(_ button: UIButton) -> UITableViewCell{
        var cell : UIView = button
        while !(cell is CellData) {
            if let super_view = cell.superview {
                cell = super_view
            }else{}
        }
        guard let tableCell = cell as? CellData else {fatalError()}
        return tableCell
    }
}



class CellData: UITableViewCell {
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hideImageIcon: UIImageView!
    @IBOutlet weak var moreButton: UIButton!
    
    
}

