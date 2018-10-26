//
//  HttpTool.swift
//  IPADownload
//
//  Created by Jason on 2018/10/24.
//  Copyright © 2018年 Jason. All rights reserved.
//

import Alamofire

//设置manager属性 (重要)
var manager:SessionManager? = nil


class HttpTool: NSObject {
    
    /// 创建单例
    static let shared:HttpTool = {
        
        let instance = HttpTool()
        
        //配置 , 通常默认即可
        let config:URLSessionConfiguration = URLSessionConfiguration.default
        
        //设置超时时间为60S
        config.timeoutIntervalForRequest = 60
        config.requestCachePolicy = .reloadIgnoringCacheData
        
        //根据config创建manager
        manager = SessionManager(configuration: config)
        
        manager?.delegate.sessionDidReceiveChallenge = { session, challenge in
            var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
            var credential: URLCredential?
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                disposition = URLSession.AuthChallengeDisposition.useCredential
                credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            } else {
                if challenge.previousFailureCount > 0 {
                    disposition = .cancelAuthenticationChallenge
                } else {
                    credential = manager?.session.configuration.urlCredentialStorage?.defaultCredential(for: challenge.protectionSpace)
                    
                    if credential != nil {
                        disposition = .useCredential
                    }
                }
            }
            return (disposition, credential)
        }
        
        return instance
    }()
    
}


// MARK: - 网络请求
extension HttpTool{
    
    
    func request(method:Alamofire.HTTPMethod, URLString:String, parameters:[String:Any]?, completion:@escaping (_ value:AnyObject)->()) {
        
        let requestHeader:HTTPHeaders = ["Content-Type": "application/json"]
        
        var params = parameters
        
        if params == nil {
            params = [String:Any]()
        }
        
        manager?.request(URLString, method: method, parameters: params, encoding: JSONEncoding.default,headers: requestHeader).responseJSON(completionHandler:{(response) in
            
            switch response.result.isSuccess{
            case true:
                
                let obj = response.result.value as AnyObject
                
                completion(obj)
                
            case false: break
                
            }
            
        })
    }
    
    
    func download(URLString:String,title:String,progressHandler:@escaping ((_ progress:Double)->()),completion:@escaping (()->())) {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let downloadURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
            let fileURL = downloadURL.appendingPathComponent("\(title).ipa")
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        manager?.download(URLString, to: destination).downloadProgress(closure: { (progress) in
            
            let value =  Double(progress.completedUnitCount)/Double(progress.totalUnitCount)
            
            progressHandler(value)
            
        }).responseData(completionHandler: { (response) in
            
            switch response.result {
                
            case .success:
                
                print("文件下载完毕: \(response)")
                
            case .failure:
                
                
               break
            }
            
            completion()
            
        })
        
        
        
    }
    
}



