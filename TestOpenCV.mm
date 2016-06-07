//
//  TestOpenCV.m
//  originalphoto
//
//  Created by 久保田千尋 on 2016/01/12.
//  Copyright © 2016年 Chihiro Kubota. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TestOpenCV : NSObject
+(UIImage *)DetectEdgeWithImage:(UIImage *)image;
@end

#import "originalphoto-Bridging-Header.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@implementation TestOpenCV : NSObject

+(UIImage *)DetectEdgeWithImage:(UIImage *)image{
    
    //UIImageをcv::Matに変換
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    //白黒濃淡画像に変換
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_BGR2GRAY);
    
    //エッジを検出
    cv::Mat edge;
    cv::Canny(gray, edge, 200, 100);
    
    //cv::MatをUIImageに変換
    UIImage *edgeImg = MatToUIImage(edge);
    
    return edgeImg;
}
@end
