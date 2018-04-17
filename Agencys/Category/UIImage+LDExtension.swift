//
//  UIImage-LDExtension.swift
//  ExpressSystem
//
//  Created by Kean on 2017/5/31.
//  Copyright © 2017年 Kean. All rights reserved.
//

import UIKit

public enum UIImageContentMode {
    case scaleToFill, scaleAspectFit, scaleAspectFill
}
extension UIImage {
    
    
    /// 根据颜色生成纯色图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 纯色图片
     class func ld_image(color : UIColor, _ size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        // 获得上下文
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    //添加水印
    func drawTextInImage(_ str: String)->UIImage {
        //开启图片上下文
        UIGraphicsBeginImageContext(self.size)
        //图形重绘
        
        self.draw(in: CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height))
        //水印文字属性
        let att = [NSAttributedStringKey.foregroundColor:UIColor.red,
                   NSAttributedStringKey.font:UIFont.systemFont(ofSize: 50),
                   NSAttributedStringKey.backgroundColor:UIColor.clear]
        //水印文字大小
        let text = NSString(string: str)
        let size =  text.size(withAttributes: att)
        //绘制文字
        text.draw(in: CGRect(x: 40, y: 60, width: size.width, height: size.height), withAttributes: att)
        //从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
        
    }
    

    //图片上加水印图片
    func drawImageInImage(named: String, _ alpha: CGFloat = 1.0) -> UIImage {
        let w = self.size.width
        let h = self.size.height
        // 开始给图片添加图片
        UIGraphicsBeginImageContext(self.size)
        self.draw(in: CGRect(x: 0, y: 0, width: w, height: h))
        let drawImage = UIImage(named: named)
        drawImage?.draw(in: CGRect(x: 20, y: 20, width: w-40, height:h-40), blendMode: .normal, alpha: alpha)
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return waterMarkedImage!
    }
    
    //获取压缩图片Data
    func compressImageData() -> Data{
        var data:NSData = UIImageJPEGRepresentation(self, 1.0)! as NSData
        print("Data:\(data.length)")
        if data.length > 150*1024 {
            if data.length > 2*1024*1024 {
                data=UIImageJPEGRepresentation(self, 0.1)! as NSData
            } else if data.length > 1024*1024 {
                data=UIImageJPEGRepresentation(self, 0.25)! as NSData
            } else if data.length > 512*1024 {
                data=UIImageJPEGRepresentation(self, 0.5)! as NSData
            } else if data.length > 200*1024 {
                data=UIImageJPEGRepresentation(self, 0.7)! as NSData
            }
        }
        
        print("changeData:\(data.length)")
        return data as Data
    }
    
    //获取压缩图片
    func compressImage() -> UIImage{
        let imageData = self.compressImageData()
        let compressImage = UIImage(data: imageData)
        return compressImage ?? UIImage()
    }

    // image转成base64String
    func toBase64String() -> String {
        return self.compressImageData().base64EncodedString()
    }
    
    

    /// 设置圆角
    ///
    /// - Returns: 带圆角的图片
     func ld_circleImage() -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        // false 代表透明
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: rect)
        //裁剪
        context?.clip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭上下文
        UIGraphicsEndImageContext()
        return image ?? nil
    }
    
    //创建一个图像的裁剪副本。
    func crop(bounds: CGRect) -> UIImage? {
        return UIImage(cgImage: (self.cgImage?.cropping(to: bounds)!)!,
                       scale: 0.0, orientation: self.imageOrientation)
    }
    
    
    //创建一个缩放图片。
    func resize(toSize: CGSize, _ contentMode: UIImageContentMode = .scaleToFill) -> UIImage? {
        let horizontalRatio = toSize.width / self.size.width;
        let verticalRatio = toSize.height / self.size.height;
        var ratio: CGFloat!
        
        switch contentMode {
        case .scaleToFill:
            ratio = 1
        case .scaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: size.width * ratio, height: size.height * ratio)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(rect.size.width), height: Int(rect.size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        let transform = CGAffineTransform.identity
        
        // Rotate and/or flip the image if required by its orientation
        context?.concatenate(transform);
        
        // Set the quality level to use when rescaling
        context!.interpolationQuality = CGInterpolationQuality(rawValue: 3)!
        
        //CGContextSetInterpolationQuality(context, CGInterpolationQuality(kCGInterpolationHigh.value))
        
        // Draw into the context; this scales the image
        context?.draw(self.cgImage!, in: rect)
        
        // Get the resized image from the context and a UIImage
        let newImage = UIImage(cgImage: (context?.makeImage()!)!, scale: self.scale, orientation: self.imageOrientation)
        return newImage;
    }
    
    var hasAlpha: Bool {
        let alpha: CGImageAlphaInfo = self.cgImage!.alphaInfo
        switch alpha {
        case .first, .last, .premultipliedFirst, .premultipliedLast:
            return true
        default:
            return false
        }
    }

    func applyAlpha() -> UIImage? {
        if hasAlpha {
            return self
        }
        
        let imageRef = self.cgImage;
        let width = imageRef?.width;
        let height = imageRef?.height;
        let colorSpace = imageRef?.colorSpace
        
        // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue)
        let offscreenContext = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace!, bitmapInfo: bitmapInfo.rawValue)
        
        // Draw the image into the context and retrieve the new image, which will now have an alpha layer
        let rect: CGRect = CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!))
        offscreenContext?.draw(imageRef!, in: rect)
        let imageWithAlpha = UIImage(cgImage: (offscreenContext?.makeImage()!)!)
        return imageWithAlpha
    }
    
    //设置图片圆角
    func roundCorners(cornerRadius: CGFloat) -> UIImage? {
        // If the image does not have an alpha layer, add one
        let imageWithAlpha = applyAlpha()
        if imageWithAlpha == nil {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let width = imageWithAlpha?.cgImage?.width
        let height = imageWithAlpha?.cgImage?.height
        let bits = imageWithAlpha?.cgImage?.bitsPerComponent
        let colorSpace = imageWithAlpha?.cgImage?.colorSpace
        let bitmapInfo = imageWithAlpha?.cgImage?.bitmapInfo
        let context = CGContext(data: nil, width: width!, height: height!, bitsPerComponent: bits!, bytesPerRow: 0, space: colorSpace!, bitmapInfo: (bitmapInfo?.rawValue)!)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!)*scale, height: CGFloat(height!)*scale)
        
        context?.beginPath()
        if (cornerRadius == 0) {
            context?.addRect(rect)
        } else {
            context?.saveGState()
            context?.translateBy(x: rect.minX, y: rect.minY)
            context?.scaleBy(x: cornerRadius, y: cornerRadius)
            let fw = rect.size.width / cornerRadius
            let fh = rect.size.height / cornerRadius
            context?.move(to: CGPoint(x: fw, y: fh/2))
            context?.addArc(tangent1End: CGPoint(x: fw, y: fh), tangent2End: CGPoint(x: fw/2, y: fh), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: 0, y: fh), tangent2End: CGPoint(x: 0, y: fh/2), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: fw/2, y: 0), radius: 1)
            context?.addArc(tangent1End: CGPoint(x: fw, y: 0), tangent2End: CGPoint(x: fw, y: fh/2), radius: 1)
            context?.restoreGState()
        }
        context?.closePath()
        context?.clip()
        
        context?.draw(imageWithAlpha!.cgImage!, in: rect)
        let image = UIImage(cgImage: (context?.makeImage()!)!, scale:scale, orientation: .up)
        UIGraphicsEndImageContext()
        return image
    }

    
//    //等比例缩放
//    -(UIImage*)scaleToSize:(CGSize)size
//    {
//    CGFloat width = CGImageGetWidth(self.CGImage);
//    CGFloat height = CGImageGetHeight(self.CGImage);
//    
//    float verticalRadio = size.height*1.0/height;
//    float horizontalRadio = size.width*1.0/width;
//    
//    float radio = 1;
//    if(verticalRadio>1 && horizontalRadio>1)
//    {
//    radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
//    }
//    else
//    {
//    radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
//    }
//    
//    width = width*radio;
//    height = height*radio;
//    
//    int xPos = (size.width - width)/2;
//    int yPos = (size.height-height)/2;
//    
//    // 创建一个bitmap的context
//    // 并把它设置成为当前正在使用的context
//    UIGraphicsBeginImageContext(size);
//    
//    // 绘制改变大小的图片
//    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
//    
//    // 从当前context中创建一个改变大小后的图片
//    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // 使当前的context出堆栈
//    UIGraphicsEndImageContext();
//    
//    // 返回新的改变大小后的图片
//    return scaledImage;
//    }
}
