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
import LYAutoUtils
import MWPhotoBrowser

class FilesController: UIViewController, UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate {
    
    var file: FileModel!
    
    fileprivate var tableView: UITableView!
    fileprivate var files = [FileModel]()
    fileprivate var images = [MWPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        if file == nil {
            file = FileModel()
            file.itemName = "主页"
            file.itemPath = ""
            file.playPath = ""
            file.type = ""
            file.imageIndex = -1
        
            let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeUrl(_:)))
            navigationItem.rightBarButtonItem = item
        }
        
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
                         parameters: ["fileroot": file.itemPath],
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
                        let urlString = (Consts.rootUrl() + oneFile.playPath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                        let image = MWPhoto(url: URL(string: urlString))
                        self?.images.append(image!)
                        
                        oneFile.imageIndex = (self?.images.count)! - 1
                    } else {
                        oneFile.imageIndex = -1
                    }
                }
                
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData()
        }) { [weak self] (error) in
            LYAutoPop.show(message: "网络错误", type: .error, duration: 2.0)
            self?.tableView.mj_header.endRefreshing()
        }
    }
    
    @objc fileprivate func changeUrl(_ sender: UIBarButtonItem) {
        let ruc = RootUrlController()
        present(ruc, animated: true, completion: nil)
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
            navigationController?.pushViewController(fc, animated: true)
        } else if item.type == "image" {
            let browser = MWPhotoBrowser(delegate: self)
            
            // Set options
            browser?.displayActionButton = false
            browser?.displayNavArrows = false
            browser?.displaySelectionButtons = false
            browser?.zoomPhotosToFill = true
            browser?.alwaysShowControls = false
            browser?.enableGrid = true
            browser?.startOnGrid = false
            browser?.autoPlayOnAppear = false

            browser?.showNextPhoto(animated: true)
            browser?.showPreviousPhoto(animated: true)
            
            if item.imageIndex != -1 {
                browser?.setCurrentPhotoIndex(UInt(item.imageIndex))
            }
            
            navigationController?.pushViewController(browser!, animated: true)
        } else if item.type == "video" {
            let vc = VideoController()
            vc.file = item
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: - MWPhotoBrowserDelegate
    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(images.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        return images[Int(index)]
    }
    
}
