//
//  ViewController.swift
//  DDCustomCameraDemo
//
//  Created by USER on 2018/12/4.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    var  manager = DDCustomCameraManager()

    //demo只提供显示第一张的imageview
    @IBOutlet weak var photoView: UIImageView!
    
    //demo只提供显示第一张的imageview
    @IBOutlet weak var albumView: UIImageView!
    
    //相册回调结果接受
    var albumArr:[DDPhotoGridCellModel]?
    
    //拍照结果回调
    var takePhotoArr: [DDCustomCameraResult]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let file = FileManager.default
        let subPathArr = try? file.contentsOfDirectory(atPath: NSTemporaryDirectory())
        for subPath in (subPathArr ?? []) {
            print(subPath)
        }
        DDCustomCameraManager.cleanMoviesFile()
        
        photoView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        photoView.addGestureRecognizer(tap)
        
        albumView.isUserInteractionEnabled = true
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(albumImageTapAction))
        albumView.addGestureRecognizer(tap2)
    }
    
    @objc func tapAction() {

        guard let arr = takePhotoArr else {
            return
        }
        //获取所有的asset数组
        var assetArr = [PHAsset]()
        for model in arr {
            if let asset = model.asset {
                assetArr.append(asset)
            }
        
        }
        if assetArr.count > 0 {
            let manager = DDPhotoPickerManager()
            manager.presentUploadBrowserController(uploadPhotoSource: assetArr, seletedIndex: 0)
        }
    }
    
    @objc func albumImageTapAction() {
        //获取所有的asset数组
        let assetArr = albumArr?.map({ (cellModel) -> PHAsset in
            return cellModel.asset
        })
        let manager = DDPhotoPickerManager()
        
        guard let arr = assetArr else {
            return
        }
        manager.presentUploadBrowserController(uploadPhotoSource: arr, seletedIndex: 0)
    }
    
    
    @IBAction func albumAction(_ sender: Any) {
        let manager = DDPhotoPickerManager()
        manager.maxSelectedNumber = 9
        manager.photoPickerAssetType = .all
        manager.presentImagePickerController {[weak self] (resultArr) in
            guard let arr = resultArr else {
                return
            }
            let model = resultArr?.first
            _ = DDCustomCameraManager.requestImageForAsset(for: model?.asset, targetSize: CGSize(width: 150, height: 150), resultHandler: { (image, dic) in
                self?.albumView.image = image
            })
            self?.albumArr = arr
        }
    }
    
    @IBAction func takePicAction(_ sender: Any) {
        manager.isEnableTakePhoto = true
        manager.isEnableRecordVideo = true
        //录制最长时间
//        manager.maxRecordDuration = 9
        //此属性只截取框内图像。并且不能摄像，只能拍照
//        manager.isShowClipperView = true
        manager.presentCameraController()
        manager.completionBack = {[weak self] (arr) in
            self?.photoView.image = arr?.first?.image
            self?.getPath(asset: arr?.first?.asset)
            self?.takePhotoArr = arr
        }
    }
    
    /// 上传视屏时，导出的filePath，图片不需要调用
    ///
    /// - Parameter asset: asset
    func getPath(asset: PHAsset?) {
        
        if asset?.mediaType != .video {
            return
        }
        
        //presetName 参数主要使用一下三个
        //AVAssetExportPresetLowQuality
        //AVAssetExportPresetMediumQuality
        //AVAssetExportPresetHighestQuality
        DDCustomCameraManager.exportVideoFilePath(for: asset, type: .mp4, presetName: AVAssetExportPresetMediumQuality) { (path, err) in
            //path默认存储在沙盒的tmp目录下
            print(path)
        }
        
        //清除存储在tmp目录下的文件。需要就调用
        DDCustomCameraManager.cleanMoviesFile()
    }
    
}

