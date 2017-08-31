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
    let itemList = ["Apple","Lava","MI","Samsung","Sony","Vivo","Window","Apple","Lava","MI","Samsung","Sony","Vivo","Window","Apple","Lava","MI","Samsung","Sony","Vivo","Window"]   //
     let mobImages = [UIImage(named: "iphone"),UIImage(named: "lava"),UIImage(named: "mi"),UIImage(named: "samsung"),UIImage(named: "sony"),UIImage(named: "vivo"),UIImage(named: "window"),UIImage(named: "iphone"),UIImage(named: "lava"),UIImage(named: "mi"),UIImage(named: "samsung"),UIImage(named: "sony"),UIImage(named: "vivo"),UIImage(named: "window"),UIImage(named: "iphone"),UIImage(named: "lava"),UIImage(named: "mi"),UIImage(named: "samsung"),UIImage(named: "sony"),UIImage(named: "vivo"),UIImage(named: "window")] //
    var hieght: CGFloat = 200
    var expandedCells = [Int]()
    var moreBtnName = [String]()
    var searchActive : Bool = false //  for check search bar state................
    var filtered:[String] = []      //  For stored filter result's.................
//=========== Outlet's =================
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        for tempIndex in 0..<itemList.count{
            moreBtnName.insert("More", at: tempIndex)
        }
   }
    @IBAction func gridButton(_ sender: UIButton) {
        guard let collectionVcObj = self.storyboard?.instantiateViewController(withIdentifier: "CollectionVC") as? CollectionVC else{fatalError()}
        collectionVcObj.itemList = self.itemList
        collectionVcObj.mobImages = self.mobImages as! [UIImage]
        self.navigationController?.pushViewController(collectionVcObj, animated: false)
        
    }
    @IBAction func moreButtonTapped(_ sender: UIButton) {
//==== Create cellObject and indexPath-------------
        guard   let cell = getCell(sender) as? CellData else{fatalError()}
        guard let indexPath = self.tableView.indexPath(for: cell) else {fatalError()}
       if moreBtnName[indexPath.row] == "More"{
            moreBtnName[indexPath.row] = "Hide"
        }
        else if moreBtnName[indexPath.row] == "Hide"{
            moreBtnName[indexPath.row] = "More"
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
//================= Extension of ViewController ======================

extension ViewController: UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
//================= SearchBar method's ======================
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
         filtered = itemList.filter({ (text) -> Bool in
    let tmp: NSString = text as NSString
    let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        if filtered.isEmpty {
            let alert = UIAlertController(title: "Alert", message: "Result not match", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        self.tableView.reloadData()
    }

    
//================= TableView method's ======================
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return itemList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
      if expandedCells.contains(indexPath.row) {
            return UITableViewAutomaticDimension
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CellData", for: indexPath) as? CellData else{
            fatalError()
        }
        if(searchActive){
            cell.nameLabel.text = filtered[indexPath.row]
        } else {
            cell.nameLabel.text = itemList[indexPath.row]
            cell.moreButton.tag = indexPath.row
            cell.moreButton.setTitle(moreBtnName[indexPath.row], for: .normal)
            cell.imageIcon.image = mobImages[indexPath.row]
            cell.hideImageIcon.image = mobImages[indexPath.row]
        }
       
//        cell.nameLabel.text = itemList[indexPath.row]
       
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

