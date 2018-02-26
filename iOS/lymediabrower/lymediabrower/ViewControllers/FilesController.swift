//
//  FilesController.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import JXPhotoBrowser

class FilesController: UIViewController, UITableViewDelegate, UITableViewDataSource, PhotoBrowserDelegate {
    
    var file: FileModel!
    var modulePath: String!
    
    fileprivate var tableView: UITableView!
    fileprivate var files = [FileModel]()
    fileprivate var images = [FileModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        navigationItem.title = file.itemName
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "FileCell", bundle: Bundle.main),
                           forCellReuseIdentifier: "FileCellId")
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(onLoadData))
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.stateLabel.isHidden = true
        tableView.mj_header = header
        tableView.mj_header.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func onLoadData() {
        HttpUtil.request(url: "/files",
                         parameters: ["fileroot": file.itemPath, "modulePath": modulePath],
                         success:
            { [weak self] (data) in
                let dic = data as! [String: Any]
                let fileList = dic["fileList"] as! [[String: String]]
                
                self?.files.removeAll()
                
                for item in fileList {
                    let oneFile = FileModel()
                    oneFile.setValuesForKeys(item)
                    self?.files.append(oneFile)
                    
                    if oneFile.type == "image" {
                        self?.images.append(oneFile)
                    }
                }
                
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData()
        }) { [weak self] (error) in
            self?.tableView.mj_header.endRefreshing()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileCellId", for: indexPath) as! FileCell
        cell.selectionStyle = .none
        
        let item = files[indexPath.row]
        cell.itemName = item.itemName
        cell.type = item.type
        cell.playPath = item.playPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = files[indexPath.row]
        
        if item.type == "directory" {
            let fc = FilesController()
            fc.file = item
            fc.modulePath = modulePath
            navigationController?.pushViewController(fc, animated: true)
        } else if item.type == "image" {
            let browser = PhotoBrowser(showByViewController: self, delegate: self)
            
            if let index = images.index(of: item) {
                browser.show(index: index)
            } else {
                browser.show(index: 0)
            }
        } else if item.type == "video" {
            let vc = VideoController()
            vc.file = item
            navigationController?.pushViewController(vc, animated: true)
        } else if item.type == "txt" {
            let tc = TxtController()
            tc.file = item
            navigationController?.pushViewController(tc, animated: true)
        }
    }
    
    //MARK: - PhotoBrowserDelegate
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return images.count
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        let row = files.index(of: images[index])!
        return tableView.cellForRow(at: IndexPath(row: row, section: 0))
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        let row = files.index(of: images[index])!
        let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? FileCell
        return cell?.icon.image
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        let item = images[index]
        if let url = (Consts.rootUrl() + item.playPath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: url)
        }
        return nil
    }
    
}
