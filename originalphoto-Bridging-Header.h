//
//  originalphoto-Bridging-Header.h
//  
//
//  Created by 久保田千尋 on 2016/01/12.
//
//

#ifndef originalphoto_Bridging_Header_h
#define originalphoto_Bridging_Header_h


#endif /* originalphoto_Bridging_Header_h */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Detector: NSObject

- (id)init;
- (UIImage *)recognizeFace:(UIImage *)image;
- (UIImage *)applyGaussianFilter:(UIImage *)image;
+ (UIImage *)DetectEdgeWithImage:(UIImage *)image;

@end