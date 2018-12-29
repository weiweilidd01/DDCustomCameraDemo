//
//  DDPhotoPickerManager.swift
//  Photo
//
//  Created by USER on 2018/10/25.
//  Copyright © 2018年 leo. All rights reserved.
//

import UIKit
import Photos

public class DDPhotoPickerManager: NSObject {
    //默认最大可选中数
    public var maxSelectedNumber: Int = 1
    //选择图片的size大小，为需要展示的缩略图大小。
    //若默认返回原图，大图片会导致内存问题
    //展示时按需获取图片大小
    //若为上传图片，请调用DDPhotoImageManager.requestOriginalImage方法获取
    public var imageSize:CGSize = CGSize.init(width: 140, height: 140)
    //选择类型
    public var photoPickerAssetType: DDPhotoPickerAssetType = .all
    //是否支持录制视屏
    public var isEnableRecordVideo: Bool = true
    //是否支持拍照
    public var isEnableTakePhoto: Bool = true
    //最大录制时长
    public var maxRecordDuration: Int = 15
    //是否获取限制区域中的图片
    public var isShowClipperView: Bool = false
    
    //当前对象是否是从DDCustomCamera present呈现,外界禁止调用禁止设置此值
    public var isFromDDCustomCameraPresent: Bool = false
}

extension DDPhotoPickerManager {
    
    /// 预览选择上传的资源
    ///
    /// - Parameter uploadPhotoSource:  要预览的资源文件
    public func showUploadBrowserController(uploadPhotoSource: [PHAsset], seletedIndex: Int) {
        //遍历创建数据
        let arr = uploadPhotoSource.map({ (asset) -> DDPhotoGridCellModel in
            let type = DDPhotoImageManager.transformAssetType(asset)
            let duratiom = DDPhotoImageManager.getVideoDuration(asset)
            let model = DDPhotoGridCellModel(asset: asset, type: type, duration: duratiom)
            return model
        })
        
        let vc = DDPhotoUploadBrowserController()
        vc.photoArr = arr
        vc.currentIndex = seletedIndex
        if getTopViewController?.navigationController == nil {
            getTopViewController?.present(vc, animated: true, completion: nil)
            return
        }
        getTopViewController?.navigationController?.pushViewController(vc, animated: true)

    }
    
   /// 显示图片选择控制器
   ///
   /// - Parameter finishedHandler: 完成回调
   public func presentImagePickerController(finishedHandler:@escaping ([DDPhotoGridCellModel]?)->()) {
        let authorStatus = PHPhotoLibrary.authorizationStatus()
        switch authorStatus {
        case .notDetermined:  //未确定 申请
            PHPhotoLibrary.requestAuthorization { (status) in
                //没有授权直接退出
                if status != .authorized {
                    return;
                }
            }
            break
        case .restricted: break
        case .denied:
            //弹窗提示
            let alertVC = UIAlertController(title: "提示", message: "请在iPhone的”设置-隐私-照片“选项中，允许app访问您的照片", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .default) { (action) in
            }
            let actionCommit = UIAlertAction(title: "去设置", style: .default) { (action) in
                //去设置
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(url)
                }
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(actionCommit)
            getTopViewController?.present(alertVC, animated: true, completion: nil)
            return
        case .authorized:
            break
        default:
            break
        }
    
        if isHavePhotoLibraryAuthority() == false {
            return
        }
        
        //已经授权通过,获取当前controller
        guard let vc = getTopViewController else {
            print("未获取presentController")
            return
        }
        
        //present picker controller
        let pickerVC = DDPhotoPickerViewController(assetType: photoPickerAssetType, maxSelectedNumber: maxSelectedNumber) {(selectedArr) in
            guard let arr = selectedArr else {
                finishedHandler(nil)
                return
            }
            for cellModel in arr {
               _ = DDPhotoImageManager.default().requestTargetImage(for: cellModel.asset, targetSize: CGSize(width: 150, height: 150), resultHandler: { (image, dic) in
                    cellModel.image = image
                })
            }
            //回调
            finishedHandler(arr)
        }
        //清空gif缓存
        DDPhotoImageManager.default().removeAllCache()
        let nav = DDPhotoPickerNavigationController(rootViewController: pickerVC)
        nav.previousStatusBarStyle = UIApplication.shared.statusBarStyle
        pickerVC.isFromDDCustomCameraPresent = false
        pickerVC.isEnableRecordVideo = isEnableRecordVideo
        pickerVC.isEnableTakePhoto = isEnableTakePhoto
        pickerVC.maxSelectedNumber = maxSelectedNumber
        pickerVC.maxRecordDuration = maxRecordDuration
        pickerVC.isShowClipperView = isShowClipperView
        vc.present(nav, animated: true, completion: nil)
    }
}

private extension DDPhotoPickerManager {
    
    var getTopViewController: UIViewController? {
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        return getTopViewController(viewController: rootViewController)
    }
    
    func getTopViewController(viewController: UIViewController?) -> UIViewController? {
        
        if let presentedViewController = viewController?.presentedViewController {
            return getTopViewController(viewController: presentedViewController)
        }
        
        if let tabBarController = viewController as? UITabBarController,
            let selectViewController = tabBarController.selectedViewController {
            return getTopViewController(viewController: selectViewController)
        }
        
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return getTopViewController(viewController: visibleViewController)
        }
        
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return getTopViewController(viewController: pageViewController.viewControllers?.first)
        }
        
        for subView in viewController?.view.subviews ?? [] {
            if let childViewController = subView.next as? UIViewController {
                return getTopViewController(viewController: childViewController)
            }
        }
        return viewController
    }
    
    /// 是否有相册访问权限
    ///
    /// - Returns: bool
    func isHavePhotoLibraryAuthority() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            return true
        }
        return false
    }
}
