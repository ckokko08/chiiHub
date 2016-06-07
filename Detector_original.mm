//
//  Detector.m
//  originalphoto
//
//  Created by 久保田千尋 on 2016/01/12.
//  Copyright © 2016年 Chihiro Kubota. All rights reserved.
//

#import "originalphoto-Bridging-Header.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@interface Detector()
{
    cv::CascadeClassifier cascade;
}
@end

@implementation Detector: NSObject

- (id)init {
    self = [super init];
    
    //　分度器の読み込み
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    std::string cascadeName = (char *)[path UTF8String];
    
    if(!cascade.load(cascadeName)){
        return nil;
    }
    
    return self;
    
}

- (UIImage *)recognizeFace:(UIImage *)image{
    //UIImage -> cv::Mat変換
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat mat(rows, cols, CV_8UC4);
    
    CGContextRef contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    //顔検出
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(mat, faces,
                             1.1,2,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30,30));
    
    //　顔の位置に丸を描く
    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r) {
        cv::Point center;
        int radius;
        center.x = cv::saturate_cast<int>((r->x + r->width*0.5));
        center.y = cv::saturate_cast<int>((r->y + r->height*0.5));
        radius = cv::saturate_cast<int>((r->width + r->height));
        cv::circle(mat, center, radius, cv::Scalar(80,80,255),3,8,0);
    }
    
    UIImage *resultImage = MatToUIImage(mat);
    return resultImage;
    
}

+ (UIImage *)DetectEdgeWithImage:(UIImage *)image {
    
    //convert image to mat
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    //convert mat to gray scale
    cv::Mat gray;
    cv::cvtColor(mat,gray,CV_BGR2GRAY);
    
    //detect edge
    cv::Mat edge;
    cv::Canny(gray, edge, 200, 180);
    
    //convert to image
    UIImage *edgeImg = MatToUIImage(edge);
    
    return edgeImg;
    
}

   // cv::Mat -> UIImage変換
 // UIImage *resultImage = MatToUIImage(mat);

  //return resultImage;

//}


@end

//顔検出オブジェクト
//let detector = Detector()

//- (id)init {
    //self = [super init];
    
    // 分類器の読み込み
    //NSBundle *bundle = [NSBundle mainBundle];
   // NSString *path = [bundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    //std::string cascadeName = (char *)[path UTF8String];
    
    //if(!cascade.load(cascadeName)) {
     //   return nil;
    //}
    
    //return self;
//}

//- (UIImage *)recognizeFace:(UIImage *)image {
    // UIImage -> cv::Mat変換
   // CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    //CGFloat cols = image.size.width;
   // CGFloat rows = image.size.height;
    
   // cv::Mat mat(rows, cols, CV_8UC4);
    
   // CGContextRef contextRef = CGBitmapContextCreate(mat.data,
              //                                      cols,
                       //                             rows,
                      //                              8,
                      //                              mat.step[0],
                        //                            colorSpace,
                          //                          kCGImageAlphaNoneSkipLast |
                            //                        kCGBitmapByteOrderDefault);
    
    //CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    //CGContextRelease(contextRef);
    
    // 顔検出
    //std::vector<cv::Rect> faces;
    //cascade.detectMultiScale(mat, faces,
      //                       1.1, 2,
        //                     CV_HAAR_SCALE_IMAGE,
          //                   cv::Size(30, 30));
    
    // 顔の位置に丸を描く
    //std::vector<cv::Rect>::const_iterator r = faces.begin();
    //for(; r != faces.end(); ++r) {
      //  cv::Point center;
        //int radius;
        //center.x = cv::saturate_cast<int>((r->x + r->width*0.5));
        //center.y = cv::saturate_cast<int>((r->y + r->height*0.5));
        //radius = cv::saturate_cast<int>((r->width + r->height));
        //cv::circle(mat, center, radius, cv::Scalar(80,80,255), 3, 8, 0 );
    //}
    
    
    // cv::Mat -> UIImage変換
    //UIImage *resultImage = MatToUIImage(mat);
    
    //return resultImage;
//}

//@end