//
//  DDPhotoPickerConfig.swift
//  Photo
//
//  Created by USER on 2018/10/24.
//  Copyright © 2018年 leo. All rights reserved.
//

import Foundation
import UIKit
import Photos

/// 导航条高度（不包含状态栏高度）默认44
let DDPhotoNavigationHeight: CGFloat = 44

var DDPhotoScreenWidth: CGFloat = UIScreen.main.bounds.size.width
var DDPhotoScreenHeight: CGFloat = UIScreen.main.bounds.size.height

var DDPhotoStatusBarHeight: CGFloat = DDPhotoIsiPhoneX.isIphonex() ? 44 : 20
let DDPhotoNavigationTotalHeight: CGFloat = DDPhotoStatusBarHeight + DDPhotoNavigationHeight
let DDPhotoHomeBarHeight: CGFloat = DDPhotoIsiPhoneX.isIphonex() ? 34 : 0

//底部view
let DDPhotoPickerBottomViewHeight: CGFloat = 52

//图片相关 cell显示加载图片的size
let DDPhotoPickerBreviaryPhotoWidth = 140.0
let DDPhotoPickerBreviaryPhotoHeight = 140.0

let selectEnableColor = UIColor(red: 67/255.0, green: 116/255.0, blue: 255/255.0, alpha: 1)
let selectNotEnableColor = UIColor(red: 108/255.0, green: 108/255.0, blue: 108/255.0, alpha: 1)

public class  DDPhotoIsiPhoneX {
    static public func isIphonex() -> Bool {
        
        var isIphonex = false
        if UIDevice.current.userInterfaceIdiom != .phone {
            return isIphonex
        }
        
        if #available(iOS 11.0, *) {
            /// 利用safeAreaInsets.bottom > 0.0来判断是否是iPhone X。
            let mainWindow = UIApplication.shared.keyWindow
            if mainWindow?.safeAreaInsets.bottom ?? CGFloat(0.0) > CGFloat(0.0) {
                isIphonex = true
            }
        }
        return isIphonex
    }
}

extension Notification.Name {
    static var DDPhotoFullScreenNotification = NSNotification.Name(rawValue: "DDPhotoFullScreenNotification")
}
