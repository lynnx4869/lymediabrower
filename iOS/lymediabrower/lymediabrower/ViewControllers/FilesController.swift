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
import Kingfisher

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
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        tableView.mj_header = header
        tableView.mj_header?.beginRefreshing()
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
            
            self?.tableView.mj_header?.endRefreshing()
            self?.tableView.reloadData()
        }, onError: { [weak self] error in
            self?.tableView.mj_header?.endRefreshing()
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
            if let i = images.firstIndex(of: item) {
                index = i
            }
            
            let browser = JXPhotoBrowser()
            browser.numberOfItems = {
                self.images.count
            }
            
            browser.reloadCellAtIndex = { context in
                let browserCell = context.cell as? JXPhotoBrowserImageCell
                let item = self.images[context.index]
                let urlString = (Consts.rootUrl() + item.playPath).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                browserCell?.imageView.kf.setImage(with: URL(string: urlString ?? ""), placeholder: Consts.getDefaultImage(), options: [], progressBlock: nil, completionHandler: { _ in
                    browserCell?.setNeedsLayout()
                })
            }
            
            browser.pageIndex = index
            browser.pageIndicator = JXPhotoBrowserNumberPageIndicator()
            browser.show()
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
