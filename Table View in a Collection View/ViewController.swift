//
//  ProductCollectionViewCell.swift
//  Promotion
//
//  Created by Jhamil on 12/08/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//
import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UITableViewController {
    var images = [[String]]()
    var storedOffsets = [Int: CGFloat]()
    let path = "http://dev-happy-order.pantheonsite.io"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request("http://dev-happy-order.pantheonsite.io/promproducts", method: .get).responseJSON { response in
            if let json = response.result.value {
                if  (json as? [[String : AnyObject]]) != nil{
                    if let dictionaryArray = json as? Array<Dictionary<String, AnyObject?>> {
                        if dictionaryArray.count > 0 {
                            for i in 0..<dictionaryArray.count{
                                let Object = dictionaryArray[i]
                                var innerImages = [String]()
                                if let image = Object["field_image"] as? String{
                                    innerImages = image.components(separatedBy: ",")
                                }
                                self.images.append(innerImages)
                                
                            } //End for
                        }
                    }
                }
            }
            self.tableView.reloadData()
        }//End Get

        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.images)
        return self.images.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }

        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? TableViewCell else { return }

        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images[collectionView.tag].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        let url = path + self.images[collectionView.tag][indexPath.item].trimmingCharacters(in: NSCharacterSet.whitespaces);
        print(url)
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                cell.image.image = UIImage(data: data as Data)
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("view row \(collectionView.tag) selected index path \(indexPath)")
    }
}
