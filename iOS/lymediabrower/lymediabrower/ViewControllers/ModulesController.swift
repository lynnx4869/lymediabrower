//
//  ModulesController.swift
//  lymediabrower
//
//  Created by xianing on 2017/12/8.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh
import LYAutoUtils
import RxSwift

class ModulesController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let disposeBag = DisposeBag()

    fileprivate var collectionView: UICollectionView!
    fileprivate var modules = [FileModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        navigationItem.title = "主页"
        
        let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(changeUrl(_:)))
        navigationItem.rightBarButtonItem = item
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (view.bounds.width-30)/2, height: (view.bounds.width-30)/2)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(UINib(nibName: "ModuleCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ModuleCellId")
        view.addSubview(collectionView)
                
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(onLoadData))
        header.lastUpdatedTimeLabel?.isHidden = true
        header.stateLabel?.isHidden = true
        collectionView.mj_header = header
        collectionView.mj_header?.beginRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func changeUrl(_ sender: UIBarButtonItem) {
        let ruc = RootUrlController()
        present(ruc, animated: true, completion: nil)
    }
    
    @objc fileprivate func onLoadData() {
        Api.modules().subscribe(onNext: { [weak self] modules in
            self?.modules = modules
            
            self?.collectionView.mj_header?.endRefreshing()
            self?.collectionView.reloadData()
        }, onError: { [weak self] error in
            self?.collectionView.mj_header?.endRefreshing()
        }).disposed(by: disposeBag)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModuleCellId", for: indexPath) as! ModuleCell
        
        let module = modules[indexPath.item]
        cell.title = module.itemName
        
        cell.iconImage.image = Consts.getDefaultImage()
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let module = modules[indexPath.item]

        let fc = FilesController()
        fc.file = module
        fc.modulePath = module.itemPath
        navigationController?.pushViewController(fc, animated: true)
    }

}
