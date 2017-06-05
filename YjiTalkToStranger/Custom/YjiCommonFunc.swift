//
//  YjiCommonFunc.swift
//  YjiTalkToStranger
//
//  Created by 季 雲 on 2017/06/05.
//  Copyright © 2017 Ericji. All rights reserved.
//

import UIKit

class YjiCommonFunc: NSObject {
    
    class func stringYMD(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: NSLocale.Key.identifier.rawValue)
        formatter.calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        return formatter.string(from: date)
    }
    
}
