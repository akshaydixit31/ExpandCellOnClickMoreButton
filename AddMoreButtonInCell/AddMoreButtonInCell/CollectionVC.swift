//
//  CollectionVC.swift
//  AddMoreButtonInCell
//
//  Created by Appinventiv Technologies on 31/08/17.
//  Copyright © 2017 Appinventiv Technologies. All rights reserved.
//

import UIKit

class CollectionVC: UIViewController {
//---------------- Outlet's -----------------
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
//---------------- Variable's ---------------
  var itemList = [String]()
  var mobImages = [UIImage]()
    var searchActive : Bool = false //  for check search bar state................
    var filtered:[String] = []      //  For stored filter result's.................
//========== ViewDidLoad method ==============
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    @IBAction func listButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
}
//==================== Class extension ==============
extension CollectionVC: UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate{
    //---------- Search Method's ----------------
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
        self.collectionView.reloadData()
    }

    
    //----------- Collection view method's ---------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellData", for: indexPath) as? CollectionCellData else{
            fatalError()
        }
        if(searchActive){
            cell.centerTitleLabel.text = filtered[indexPath.row]
        } else {
            cell.centerTitleLabel.text = itemList[indexPath.row]
            cell.centerImage.image = mobImages[indexPath.row]
        }
        return cell
    }
    
   
}

//---------- Class for cell ----------------
class CollectionCellData: UICollectionViewCell {
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var centerTitleLabel: UILabel!
    
}
