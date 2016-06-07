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
    cv::CascadeClassifier faceCascade;
}
@end

@implementation Detector: NSObject

- (id)init {
    self = [super init];
    
    //　分度器の読み込み
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *facePath = [bundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    std::string faceCascadeName = (char *)[facePath UTF8String];
    if(!faceCascade.load(faceCascadeName)){
        return nil;
    }
    return self;
    
}

- (cv::Mat )convertUIImage2CVMat:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat mat(rows, cols, CV_8UC4);
    CGContextRef contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return mat;
}

- (UIImage *)recognizeFace:(UIImage *)image{
    //UIImage -> cv::Mat変換
//    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
//    CGFloat cols = image.size.width;
//    CGFloat rows = image.size.height;
//    cv::Mat mat(rows, cols, CV_8UC4);
//    CGContextRef contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
//    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
//    CGContextRelease(contextRef);

    cv::Mat mat = [self convertUIImage2CVMat:image];
    cv::Mat dst_img = mat.clone();
    //顔検出
    std::vector<cv::Rect> faces;
    faceCascade.detectMultiScale(mat, faces,
                             1.1,2,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30,30));
  
    //顔の位置に丸を描く
    CGFloat image_width = image.size.width;
    CGFloat image_height = image.size.height;

    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r) {
        cv::Point center;
        int radius;
        center.x = cv::saturate_cast<int>((r->x + r->width*0.5));
        center.y = cv::saturate_cast<int>((r->y + r->height*0.5));
        radius = cv::saturate_cast<int>((r->width + r->height) * 0.25);
        //cv::circle(mat, center, radius, cv::Scalar(80,80,255),3,8,0);
        //cv::circle roi(center, radius, cv::Scalar(80,80,255),3,8,0);
        cv::Rect roi_top(0, 0, image_width, r->y);
        cv::Mat src_roi_top = mat(roi_top);
        cv::Mat dst_roi_top = dst_img(roi_top);
        cv::GaussianBlur(src_roi_top, dst_roi_top, cv::Size(11, 11), 10, 10);
        
        cv::Rect roi_left(0, r->y, r->x, r->y+r->height);
        cv::Mat src_roi_left = mat(roi_left);
        cv::Mat dst_roi_left = dst_img(roi_left);
        cv::GaussianBlur(src_roi_left, dst_roi_left, cv::Size(11, 11), 10, 10);
        
        cv::Rect roi_right(r->x+r->width, r->y, image_width - r->x - r->width, r->height);
        cv::Mat src_roi_right = mat(roi_right);
        cv::Mat dst_roi_right = dst_img(roi_right);
        cv::GaussianBlur(src_roi_right, dst_roi_right, cv::Size(11, 11), 10, 10);
        
        cv::Rect roi_bottom(0, r->y+r->height, image_width, image_height-r->y-r->height);
        cv::Mat src_roi_bottom = mat(roi_bottom);
        cv::Mat dst_roi_bottom = dst_img(roi_bottom);
        cv::GaussianBlur(src_roi_bottom, dst_roi_bottom, cv::Size(11, 11), 10, 10);
    }
    UIImage *resultImage = MatToUIImage(dst_img);
    return resultImage;
}


- (UIImage *)applyGaussianFilter:(UIImage *)image {
    // ガウシアンを用いた平滑化
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat mat(rows, cols, CV_8UC4);
    CGContextRef contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    //cv::Mat mat = convertUIImage2CVMat(image);
   cv::Mat dst_img;
    //入力画像，出力画像，カーネルサイズ，標準偏差x, y
   cv::GaussianBlur(mat, dst_img, cv::Size(11,11), 10, 10);
    UIImage *resultImage = MatToUIImage(dst_img);
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

@end

