//
//  SampleCalendarEvent.swift
//  CalendarDemo
//
//  Created by Apple on 2018/4/13.
//  Copyright © 2018年 Apple. All rights reserved.
//

import UIKit

protocol CalendarEvent {
    var title :String {get set}
    var day :Int {get set}
    var startHour :Int {get set}
    var durationInHours :Int {get set}
}

class SampleCalendarEvent: NSObject, CalendarEvent {
    
    var title: String = ""
    
    var day: Int = 0
    
    var startHour: Int = 0
    
    var durationInHours: Int = 0
    
    init(title: String, day: Int, startHour: Int, durationInHours:Int) {
        super.init()
        self.title = title
        self.day = day
        self.startHour = startHour
        self.durationInHours = durationInHours
    }
    
    static func randEvent() -> CalendarEvent {
        let randomID = arc4random_uniform(10000)
        let title = "Event \(randomID)"
        let randomDay = arc4random_uniform(7)
        let randomStartHour = arc4random_uniform(20)
        let randomDuration = arc4random_uniform(5) + 1
        return SampleCalendarEvent.init(title: title, day: Int(randomDay), startHour: Int(randomStartHour), durationInHours: Int(randomDuration))
    }
    
    func description() -> String {
        return "\(self.title): Day \(self.day) - Hour \(self.startHour) - Duration \(self.durationInHours)"
    }
}
