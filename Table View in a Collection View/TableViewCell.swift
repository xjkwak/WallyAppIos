//
//  ProductCollectionViewCell.swift
//  Promotion
//
//  Created by Jhamil on 12/08/17.
//  Copyright © 2017 Ash Furrow. All rights reserved.
//
import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var collectionView: UICollectionView!

}

extension TableViewCell {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false)
        collectionView.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
