//
//  APPVM.swift
//  IPADownload
//
//  Created by Jason on 2018/10/24.
//  Copyright © 2018 Jason. All rights reserved.
//

import Cocoa

class APPVM: NSObject {

    lazy var apps = [APPModel]()
    
    func searchApp(_ keyword:String,_ type:PPSearchType,completion:@escaping (()->())) {
        
        let tunnel = (type == .PPJailbreak) ? PPJailbreakCommand : PPStoreCommand
        
        let clFlag = (type == .PPJailbreak) ? 1 : 3
        
        let params = ["dcType":0,"keyword":keyword,"clFlag":clFlag,"perCount":30,"page":0] as [String : Any]
        
        let urlStr = baseURL+"?Tunnel-Command="+tunnel
        
        HttpTool.shared.request(method: .post, URLString: urlStr, parameters: params) { (result) in
            
            guard let content = result["content"] as? [[String:AnyObject]] else{
                return
            }
            
            for dic in content {
                
                let model = APPModel(fromDictionary: dic)
                
                self.apps.append(model)
                
            }
            
            completion()
            
        }
    }
    
    
    
    
}
