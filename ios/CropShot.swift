@objc(CropShot)
class CropShot: NSObject, RCTBridgeModule {
    
    // This lets React Native know about this module
    static func moduleName() -> String! {
        return "CropShot"
    }
    
    // You can optionally implement this method to return the methods to be exposed
    static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    var bridge: RCTBridge!
    
    @objc(captureScreenshot:y:width:height:resolve:reject:)
    func captureScreenshot(_ x: NSNumber, y: NSNumber, width: NSNumber, height: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                reject("capture_error", "Could not find key window", nil)
                return
            }
            let resizableRectangle = CGRect(x: CGFloat(truncating: x), y: CGFloat(truncating: y), width: CGFloat(truncating: width), height: CGFloat(truncating: height))
            let viewRectangle = CGRect(x: CGFloat(truncating: 0), y: CGFloat(truncating: 0), width: CGFloat(truncating: width), height: CGFloat(truncating: height))
            let rendererRect = CGSize(width: CGFloat(truncating:width), height: CGFloat(truncating:height))
            
            let renderer = UIGraphicsImageRenderer(size: rendererRect)
            let screenshot = renderer.pngData { context in
                keyWindow.resizableSnapshotView(from: resizableRectangle, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)?.drawHierarchy(in: viewRectangle,afterScreenUpdates: true)
            }
            let base64String = screenshot.base64EncodedString()
            resolve(base64String)
        }
    }
    
    @objc
    func captureScreenshotWithRef(_ reactTag: NSNumber, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        DispatchQueue.main.async {
            
            guard let bridge = self.bridge else {
                reject("E_NO_BRIDGE", "Bridge not found", nil)
                return
            }
            guard let view = bridge.uiManager.view(forReactTag: reactTag) else {
                reject("E_NO_VIEW", "View not found", nil)
                return
            }
            // let frame = view.frame
            // let x = frame.origin.x
            // let y = frame.origin.y
            // let width = frame.size.width
            // let height = frame.size.height
            
            let bound = view.bounds
            let convertedBound = view.convert(bound, to: nil)
            let x = convertedBound.origin.x
            let y = convertedBound.origin.y
            let width = convertedBound.size.width
            let height = convertedBound.size.height
            // print("BOUNDS: Width::\(bound.width), Height:: \(bound.height), MinX:: \(bound.minX), MaxX:: \(bound.maxX), MinY:: \(bound.minY), MaxY:: \(bound.maxY), Size:: \(bound.size), Origin:: \(bound.origin)")
            // print("CONVERTED BOUNDS: Width::\(convertedBound.width), Height:: \(convertedBound.height), MinX:: \(convertedBound.minX), MaxX:: \(convertedBound.maxX), MinY:: \(convertedBound.minY), MaxY:: \(convertedBound.maxY), Size:: \(convertedBound.size), Origin:: \(convertedBound.origin)")
            // print("Frame Origin: X::\(frame.origin.x), Y:: \(frame.origin.y)")
            // print("Frame Size: Width::\(frame.size.width), Height:: \(frame.size.height)")
            // let fixedCoordinates = UIScreen.main.fixedCoordinateSpace.bounds
            // let coordinates = UIScreen.main.coordinateSpace.bounds
            // let overscanCompensationInsets = UIScreen.main.overscanCompensationInsets
            // print("Fixed Coordinates: Width::\(fixedCoordinates.width), Height:: \(fixedCoordinates.height), MinX:: \(fixedCoordinates.minX), MaxX:: \(fixedCoordinates.maxX), MinY:: \(fixedCoordinates.minY), MaxY:: \(fixedCoordinates.maxY), Size:: \(fixedCoordinates.size), Origin:: \(fixedCoordinates.origin)")
            // print("Coordinates: Width::\(coordinates.width), Height:: \(coordinates.height), MinX:: \(coordinates.minX), MaxX:: \(coordinates.maxX), MinY:: \(coordinates.minY), MaxY:: \(coordinates.maxY), Size:: \(coordinates.size), Origin:: \(coordinates.origin)")
            // print("Overscan Compensation: Top::\(overscanCompensationInsets.top)")
            guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                reject("capture_error", "Could not find key window", nil)
                return
            }
            let resizableRectangle = CGRect(x: x, y:  y, width:  width, height:  height)
            let viewRectangle = CGRect(x: CGFloat(truncating: 0), y: CGFloat(truncating: 0), width: width, height: height)
            let rendererRect = CGSize(width: width, height: height)
            
            let renderer = UIGraphicsImageRenderer(size: rendererRect)
            let screenshot = renderer.pngData { context in
                keyWindow.resizableSnapshotView(from: resizableRectangle, afterScreenUpdates: true, withCapInsets: UIEdgeInsets.zero)?.drawHierarchy(in: viewRectangle,afterScreenUpdates: true)
            }
            let base64String = screenshot.base64EncodedString()
            resolve(base64String)
        }
    }
}
