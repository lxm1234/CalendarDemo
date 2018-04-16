//
//  CalendarDataSource.swift
//  CalendarDemo
//
//  Created by Apple on 2018/4/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

typealias ConfigureCellBlock = (_ cell :CalendarEventCell,_ indexPath :IndexPath,_ event :CalendarEvent) -> Void
typealias ConfigureHeaderViewBlock = (_ headerView :HeaderView, _ kind :String, _ indexPath :IndexPath) -> Void

class CalendarDataSource: NSObject, UICollectionViewDataSource {
    
    var configureCellBlock :ConfigureCellBlock?
    var configureHeaderViewBlock :ConfigureHeaderViewBlock?
    
    
    var events: [CalendarEvent] = []
    
    override func awakeFromNib() {
        for _ in 0..<20 {
            let event = SampleCalendarEvent.randEvent()
            self.events.append(event)
        }
    }
    
    func indexPathsOfEventsBetween(minDayIndex: Int, maxDayIndex: Int,minStartHour: Int,maxStartHour :Int) -> [IndexPath] {
        var indexPaths :[IndexPath] = []
        for (index,event) in self.events.enumerated() {
            if event.day >= minDayIndex, event.day <= maxDayIndex,event.startHour >= minStartHour,event.startHour <= maxStartHour {
                indexPaths.append(IndexPath(item: index, section: 0))
            }
        }
        return indexPaths
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = self.events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CalendarEventCell
        self.configureCellBlock?(cell,indexPath,event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        self.configureHeaderViewBlock?(headerView, kind, indexPath)
        return headerView;
    }
    
}
