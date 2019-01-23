//
//  UIImage+FLCommon.swift
//  FLMusic_iOS
//
//  Created by 冯里 on 2018/5/13.
//  Copyright © 2018年 fengli. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func coreBlur(inputImage image: UIImage, blurNumber: Double) -> UIImage {
        
        let context = CIContext(options: nil)
        //获取原始图片
        let inputImage =  CIImage(image: image)
        //使用高斯模糊滤镜
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey:kCIInputImageKey)
        //设置模糊半径值（越大越模糊）
        filter.setValue(blurNumber, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: image.size)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        //显示生成的模糊图片
        return UIImage(cgImage: cgImage!)
    }
    
    
    class func image(color: UIColor) -> UIImage {
        return self.image(color: color, size: CGSize(width: 1, height: 1));
    }
    
    class func image(color: UIColor, size: CGSize) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        
        return gradientImage(bounds: bounds, colors: colors, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 1))
    }
    
    class func gradientHImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        return gradientImage(bounds: bounds, colors: colors, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 0))
    }
    
    class func gradientImage(bounds: CGRect, colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> UIImage {
        
        var colorArr: [CGColor] = []
        for c: UIColor in colors {
            colorArr.append(c.cgColor)
        }
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let lastColor = colorArr.last
        let colorSpace = lastColor?.colorSpace
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colorArr as CFArray, locations: nil)
        let width = bounds.size.width
        let height = bounds.size.height
        let start = CGPoint(x: width*startPoint.x, y: height*startPoint.y)
        let end = CGPoint(x: width*endPoint.x, y: height*endPoint.y)
        
        context?.drawLinearGradient(gradient!, start: start, end: end, options: [CGGradientDrawingOptions.drawsBeforeStartLocation, CGGradientDrawingOptions.drawsAfterEndLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        context?.restoreGState()
        UIGraphicsEndImageContext()
        return image!
    }
}
