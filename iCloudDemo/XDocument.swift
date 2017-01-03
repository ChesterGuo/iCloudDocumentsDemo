//
//  XDocument.swift
//  LifeDiary
//
//  Created by ChesterGuo on 2016/12/5.
//  Copyright © 2016年 Guo. All rights reserved.
//
let kArchiveKey  = "Diary"

import UIKit

class XDocument: UIDocument {
    var diaries : Array<Dictionary<String, Any>>!
    override func contents(forType typeName: String) throws -> Any {
        let data = NSMutableData.init()
        let archiver:NSKeyedArchiver = NSKeyedArchiver.init(forWritingWith: data)
        archiver.encode(self.diaries, forKey: kArchiveKey)
        archiver.finishEncoding()
        return data
    }
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        let unarchiver:NSKeyedUnarchiver = NSKeyedUnarchiver.init(forReadingWith: contents as! Data)
        self.diaries = unarchiver.decodeObject(forKey: kArchiveKey) as! Array
        unarchiver.finishDecoding()
    }
}
