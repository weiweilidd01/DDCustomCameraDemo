//
//  DDPhotoStyleConfig.swift
//  DDCustomCameraDemo
//
//  Created by weiwei.li on 2019/1/4.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import UIKit

public class DDPhotoStyleConfig: NSObject {
    public static let shared = DDPhotoStyleConfig()
    
    public var navigationBackImage: UIImage?
    public var navigationBackgroudColor: UIColor?
    public var navigationTintColor: UIColor?
    public var navigationBarStyle:UIBarStyle = .black
    public var seletedImageCircleColor: UIColor?
    
    public var bottomBarBackgroudColor: UIColor?
    public var bottomBarTintColor: UIColor?

}
