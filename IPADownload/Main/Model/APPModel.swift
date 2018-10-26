//
//  APPModel.swift
//  IPADownload
//
//  Created by Jason on 2018/10/23.
//  Copyright © 2018 Jason. All rights reserved.
//

import Foundation

struct APPModel {
    
    var title:String?
    
    var desc:String?
    
    var version:String?
    
    var fsize:String?
    
    var thumb:String?
    
    var downurl:String?
    
    
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        desc = dictionary["desc"] as? String
        version = dictionary["version"] as? String
        fsize = dictionary["fsize"] as? String
        thumb = dictionary["thumb"] as? String
        downurl = dictionary["downurl"] as? String
    }
    
}


