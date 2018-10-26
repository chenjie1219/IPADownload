//
//  resultCellView.swift
//  IPADownload
//
//  Created by Jason on 2018/10/24.
//  Copyright © 2018 Jason. All rights reserved.
//

import Cocoa
import SDWebImage

class resultCellView: NSTableCellView {
    
    @IBOutlet weak var iconView: NSImageView!
    
    @IBOutlet weak var titleLbl: NSTextField!
    
    @IBOutlet weak var versionLbl: NSTextField!
    
    @IBOutlet weak var sizeLbl: NSTextField!
    
    lazy var downloadURL = ""
    
    func config(_ model:APPModel) {
        
        titleLbl.stringValue = model.title ?? ""
        
        versionLbl.stringValue = model.version ?? ""
        
        sizeLbl.stringValue = model.fsize ?? ""
        
        let url = URL(string: model.thumb ?? "")
        
        iconView.sd_setImage(with: url)
        
        downloadURL = model.downurl ?? ""
        
    }
    
    @IBAction func downloadBtnClick(_ sender: NSButton) {
        
        sender.isEnabled = false
        
        sender.title = "下载中"
        
        HttpTool.shared.download(URLString: downloadURL, title: titleLbl.stringValue, progressHandler: { (value) in
            
            
            
            let progressStr = String(format: "%.2f", value*100)
            
            sender.title = "\(progressStr)%"
            
        }) {
            
            sender.isEnabled = true
            
            sender.title = "下载"
            
            let downloadPath = "~/Downloads"
            
            NSWorkspace.shared.selectFile("\(downloadPath)/\(self.titleLbl.stringValue).ipa", inFileViewerRootedAtPath: downloadPath)
            
        }
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
