//
//  WeekCalendarLayout.swift
//  CalendarDemo
//
//  Created by Apple on 2018/4/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

let DaysPerWeek = 7
let HoursPerDay = 24
let HorizontalSpacing :CGFloat = 10
let HeightPerHour :CGFloat = 50
let DayHeaderHeight :CGFloat = 40
let HourHeaderWidth :CGFloat = 100

class WeekCalendarLayout: UICollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        // Don't scroll horizontally
        let contentWidth = self.collectionView?.bounds.size.width
        // Scroll vertically to display a full day
        let contentHeight = DayHeaderHeight + HeightPerHour * CGFloat(HoursPerDay)
        return CGSize(width: contentWidth ?? 0, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes :[UICollectionViewLayoutAttributes] = []
        // Cells
        let visibleIndexPaths = self.indexPathsOfItems(rect: rect)
        for indexPath in visibleIndexPaths {
            let attributes = self.layoutAttributesForItem(at: indexPath)
            layoutAttributes.append(attributes!)
        }
        // Supplementary views
        let dayHeaderViewIndexPaths = self.indexPathsOfDayHeaderViews(rect: rect)
        for indexPath in dayHeaderViewIndexPaths {
            let attributes = self.layoutAttributesForSupplementaryView(ofKind: "DayHeaderView", at: indexPath)
            layoutAttributes.append(attributes!)
        }
        
        let hourHeaderViewIndexPaths = self.indexPathsOfHourHeaderViews(rect: rect)
        for indexPath in hourHeaderViewIndexPaths {
            let attributes = self.layoutAttributesForSupplementaryView(ofKind: "HourHeaderView", at: indexPath)
            layoutAttributes.append(attributes!)
        }
        return layoutAttributes;
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let dataSource = self.collectionView!.dataSource as! CalendarDataSource
        let event = dataSource.events[indexPath.item]
        let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attributes.frame = self.frame(for: event)
        return attributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: elementKind, with: indexPath)
        let totalWidth = self.collectionViewContentSize.width
        if elementKind == "DayHeaderView" {
            let availableWidth = totalWidth - HourHeaderWidth
            let widthPerDay = availableWidth / CGFloat(DaysPerWeek)
            attributes.frame = CGRect.init(x: HourHeaderWidth + widthPerDay * CGFloat(indexPath.item), y: 0, width: widthPerDay, height: DayHeaderHeight)
        } else if elementKind == "HourHeaderView" {
            attributes.frame = CGRect.init(x: 0, y: DayHeaderHeight + HeightPerHour * CGFloat(indexPath.item), width: totalWidth, height: HeightPerHour)
            attributes.zIndex = -10
        }
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension WeekCalendarLayout {
    func indexPathsOfItems(rect: CGRect) -> [IndexPath] {
        let minVisibleDay = self.dayIndexFromXCoordinate(xPosition: rect.minX)
        let maxVisibleDay = self.dayIndexFromXCoordinate(xPosition: rect.maxX)
        let minVisibleHour = self.hourIndexFromYCoordinate(yPosition: rect.minY)
        let maxVisibleHour = self.hourIndexFromYCoordinate(yPosition: rect.maxY)
        
        let dataSource = self.collectionView!.dataSource as! CalendarDataSource
        let indexPaths = dataSource.indexPathsOfEventsBetween(minDayIndex: minVisibleDay, maxDayIndex: maxVisibleDay, minStartHour: minVisibleHour, maxStartHour: maxVisibleHour)
        return indexPaths
    }
    
    func dayIndexFromXCoordinate(xPosition: CGFloat) -> Int {
        let contentWidth = self.collectionViewContentSize.width - HourHeaderWidth
        let widthPerDay = contentWidth / CGFloat(DaysPerWeek)
        return max(0, Int((xPosition - HourHeaderWidth)/widthPerDay))
    }
    
    func hourIndexFromYCoordinate(yPosition: CGFloat) -> Int {
        return max(0, Int((yPosition - DayHeaderHeight)/HeightPerHour))
    }
    
    func indexPathsOfDayHeaderViews(rect: CGRect) -> [IndexPath] {
        var indexPaths :[IndexPath] = []
        if rect.minY > DayHeaderHeight {
            return indexPaths
        }
        let minDayIndex = self.dayIndexFromXCoordinate(xPosition: rect.minX)
        let maxDayIndex = self.dayIndexFromXCoordinate(xPosition: rect.maxX)
        for i in minDayIndex...maxDayIndex {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        return indexPaths
    }
    
    func indexPathsOfHourHeaderViews(rect: CGRect) -> [IndexPath] {
        var indexPaths :[IndexPath] = []
        if rect.minX > HourHeaderWidth {
            return indexPaths
        }
        let minHourIndex = self.hourIndexFromYCoordinate(yPosition: rect.minY)
        let maxHourIndex = self.hourIndexFromYCoordinate(yPosition: rect.maxY)
        for i in minHourIndex...maxHourIndex {
            indexPaths.append(IndexPath.init(item: i, section: 0))
        }
        return indexPaths
    }
    
    func frame(for event: CalendarEvent) -> CGRect {
        let totalWidth = self.collectionViewContentSize.width - HourHeaderWidth
        let widthPerDay = totalWidth / CGFloat(DaysPerWeek)
        var frame = CGRect.zero
        frame.origin.x = HourHeaderWidth + widthPerDay * CGFloat(event.day)
        frame.origin.y = DayHeaderHeight + HeightPerHour * CGFloat(event.startHour)
        frame.size.width = widthPerDay
        frame.size.height =  CGFloat(event.durationInHours) * HeightPerHour
        frame = frame.insetBy(dx: HorizontalSpacing / 2.0, dy: 0)
        return frame
    }
}
