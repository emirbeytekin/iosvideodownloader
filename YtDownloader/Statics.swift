//
//  Statics.swift
//  YtDownloader
//
//  Created by Emir Beytekin on 12.12.2017.
//  Copyright © 2017 Emir Beytekin. All rights reserved.
//

import UIKit

class Utils: NSObject {

    class func getDbWay() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
       return paths[0] + "/db.sqlite3"
    }
}
