//
//  ViewController.swift
//  IPADownload
//
//  Created by Jason on 2018/10/23.
//  Copyright © 2018 Jason. All rights reserved.
//

import Cocoa

class MainVC: NSViewController {

    @IBOutlet weak var typeSelector: NSPopUpButton!
    
    @IBOutlet weak var resultTableView: NSTableView!
    
    @IBOutlet weak var searchFld: NSSearchField!
    
    lazy var apps = [APPModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.headerView = nil
        
        resultTableView.rowHeight = 60
        
        resultTableView.selectionHighlightStyle = .none
        
    }
    
    @IBAction func switchClick(_ sender: NSPopUpButton) {
        
        searchClick(searchFld)
    }
    
    @IBAction func searchClick(_ sender: NSSearchField) {
        
        if sender.stringValue == "" {
            
            apps.removeAll()
            
            resultTableView.reloadData()
            
            return
        }
        
        let type = (typeSelector.selectedTag() == 0) ? PPSearchType.PPJailbreak : PPSearchType.PPStore
        
        let vm = APPVM()
        
        vm.searchApp(sender.stringValue, type) {[weak self] in
            
            guard let self = self else {
                return
            }
            
            self.apps = vm.apps
            
            self.resultTableView.reloadData()
            
        }
        
    }
    

    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


extension MainVC:NSTableViewDelegate,NSTableViewDataSource{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return apps.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let app = apps[row]
        
        let identifier = tableColumn?.identifier
        
        let cellView = tableView.makeView(withIdentifier: identifier!, owner: self) as? resultCellView
        
        cellView?.config(app)
        
        return cellView
    }
    
}

