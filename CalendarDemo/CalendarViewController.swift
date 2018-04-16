//
//  CalendarViewController.swift
//  CalendarDemo
//
//  Created by Apple on 2018/4/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CalendarViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let headerViewNib = UINib.init(nibName: "HeaderView", bundle: nil)
        self.collectionView!.register(headerViewNib, forSupplementaryViewOfKind: "DayHeaderView", withReuseIdentifier: "HeaderView")
        self.collectionView!.register(headerViewNib, forSupplementaryViewOfKind: "HourHeaderView", withReuseIdentifier: "HeaderView")
        // Define cell and header view configuration
        let dataSource = self.collectionView!.dataSource as! CalendarDataSource
        dataSource.configureCellBlock = {(cell,IndexPath,event) in
            cell.titleLabel.text = event.title
        }
        dataSource.configureHeaderViewBlock = {(headerView,kind,indexpath) in
            if kind == "DayHeaderView" {
                headerView.titleLabel.text = "\(indexpath.item + 1)"
            } else if kind == "HourHeaderView" {
                headerView.titleLabel.text = String.init(format: "%2d", indexpath.item + 1) + ":00"
            }
        }
    }
}
