# DDCustomCamera

#### 1.基本使用

```
        let manager = DDCustomCameraManager()
         //是否允许拍照
        manager.isEnableTakePhoto = true
        //是否允许摄像
        manager.isEnableRecordVideo = true
          //录制最长时间
//        manager.maxRecordDuration = 9
        //此属性只截取取框内图像。并且不能摄像，只能拍照
//        manager.isShowClipperView = true
        manager.presentCameraController()
        //完成回调
        manager.completionBack = {[weak self] (model) in
            print(model.debugDescription)
            self?.getPath(asset: model?.asset)
        }
```

#### 2.完成回调model介绍 -- DDCustomCameraResult

```
    //资源对象
    public var asset: PHAsset?
    public var isVideo: Bool? //fale: 为图片， true为视屏
    //图片 -- 若为视屏，则返回视屏首张图片
    public var image: UIImage?
    //时长
    public var duration: String?
```

#### 3.若要上传视屏，获取对应的filePath

```
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
```

#### 4.DDCustomCameraManager另外还提供了以下操作asset方法

```
    /// 获取图片
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - targetSize: 获取图片的size（用于展示实际所需大小）
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestImageForAsset(for asset: PHAsset?, targetSize: CGSize, resultHandler: @escaping (UIImage?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID 
    
        
    /// 获取原始图片的data（用于上传）
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestOriginalImageDataForAsset(for asset: PHAsset?, resultHandler: @escaping (Data?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID 
    
    
    /// 获取相册视屏播放的item
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestVideoForAsset(for asset: PHAsset?, resultHandler: @escaping (AVPlayerItem?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID 


 /// 获取视屏的avasset
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - resultHandler: 回调
    /// - Returns: id
    static public func requestAVAssetForAsset(for asset: PHAsset?, resultHandler: @escaping (AVAsset?, [AnyHashable : Any]?) -> Void) -> PHImageRequestID
    
    
    /// 导出视屏上传临时存储的filePath
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - type: 导出格式
    ///   - presetName: 压缩格式 ，常见的为以下三种
            //AVAssetExp
            ortPresetLowQuality
            //AVAssetExportPresetMediumQuality
            //AVAssetExportPresetHighestQuality
    ///   - compelete: 完成回调
    static public func exportVideoFilePath(for asset: PHAsset?, type: DDExportVideoType, presetName: String, compelete:((String?, NSError?)->())?)
```

#### 5.具体使用，请参照DDKitDemo
