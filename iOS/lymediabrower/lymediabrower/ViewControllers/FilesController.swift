//
//  FilesController.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import MJRefresh
import JXPhotoBrowser

class FilesController: UIViewController {
    
    fileprivate let disposeBag = DisposeBag()
    
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
        Api.files(file.itemPath, modulePath).subscribe(onNext: { [weak self] files in
            self?.files = files
            
            self?.images.removeAll()
            for file in files {
                if file.type == "image" {
                    self?.images.append(file)
                }
            }
            
            self?.tableView.mj_header.endRefreshing()
            self?.tableView.reloadData()
        }, onError: { [weak self] error in
            self?.tableView.mj_header.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
}

extension FilesController: UITableViewDelegate, UITableViewDataSource {
    
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
            var index = 0
            if let i = images.index(of: item) {
                index = i
            }
            
            let loader = JXKingfisherLoader()
            let dataSource = JXNetworkingDataSource(photoLoader: loader, numberOfItems: { () -> Int in
                return self.images.count
            }, placeholder: { index -> UIImage? in
                return Consts.getDefaultImage()
            }) { index -> String? in
                let item = self.images[index]
                return (Consts.rootUrl() + item.playPath)
                    .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            }
            let delegate = JXNumberPageControlDelegate()
            
            let browser = JXPhotoBrowser(dataSource: dataSource, delegate: delegate)
            browser.show(pageIndex: index)
        } else if item.type == "video" {
            let vc = VideoController()
            vc.file = item
            navigationController?.pushViewController(vc, animated: true)
        } else if item.type == "document" {
            let dc = DocumentController()
            dc.file = item
            navigationController?.pushViewController(dc, animated: true)
        } else if item.type == "txt" {
//            DispatchQueue.global().async {
//                let pageVc = LYAutoReadPageController()
//                if let fileURL = Bundle.main.url(forResource: "tw", withExtension: "txt"),
//                    let model = LYAutoReadModel.getLocalModel(fileUrl: fileURL) {
//
//                    pageVc.resourceURL = fileURL
//                    pageVc.model = model
//
//                    DispatchQueue.main.async {
//                        self.present(pageVc, animated: true, completion: nil)
//                    }
//                }
//            }
        }
    }
    
}
