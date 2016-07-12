//
//  ViewController.swift
//  originalphoto
//
//  Created by 久保田千尋 on 2015/11/24.
//  Copyright © 2015年 Chihiro Kubota. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var imageFromCameraRoll: UIImageView!
    @IBOutlet var bSavePic : UIButton!
    
    var scale:CGFloat = 1.0
    var width:CGFloat = 0
    var height:CGFloat = 0
    var screenwidth:CGFloat = 0
    var screenheight:CGFloat = 0
    var image: UIImage!
    var edge: UIImage!
    var faceImage: UIImage!
    var blurImage: UIImage!
    var processflg = false
    var process_face_flg = false
    var process_blur_flg = false
    var edgeflg = false
    var faceflg = false
    var blurflg = false
    let detector = Detector()
    //let buttonImageDefault :UIImage? = UIImage(named:"buttonDefault.png")
    //let buttonImageSelected :UIImage? = UIImage(named:"buttonSelected.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageFromCameraRoll.image = image
        
        if let img = imageFromCameraRoll.image {
            image = img
            edge = Detector.DetectEdgeWithImage(image)
            //let edge = Detector.DectEdgeWithImage(image)
            //myImageView.image = edge
            
            // Screen Sizeの取得
            screenwidth = self.view.bounds.width
            screenheight = self.view.bounds.height
            
            //　画像の幅・高さの取得
            width = image.size.width
            height = image.size.height
            
            // 画像サイズをスクリーン幅に合わせる
            scale = screenwidth / width
            let rect:CGRect = CGRectMake(0, 0, 100, 100)
            
            // ImageView frame をCGRectMakeで作った短形に合わせる
            imageFromCameraRoll!.frame = rect;
            
            //画像の中心を187.5,333.5の位置に設定、iPhon6のケース
//            imageFromCameraRoll!.center = CGPointMake(187.5,333.5)
            imageFromCameraRoll!.center = CGPointMake(187.5,333.5)
            imageFromCameraRoll.contentMode = .ScaleAspectFit
            imageFromCameraRoll.clipsToBounds = true
            // viewにimageviewを追加する
            self.view.addSubview(imageFromCameraRoll)
        }else {
            print("画像が表示できませーん")
        }
        
        
//        self.navigationController?.hideBarsOnTap = true
    }
    // 画像縮小
   // @IBAction func minus(sender: AnyObject){
       
     //   if(width*scale > screenwidth/10){
       //     scale -= 0.2
        //}
        
      //  let rect:CGRect = CGRectMake(0, 0, width*scale, height*scale)
        //imageFromCameraRoll.frame = rect;
      //  imageFromCameraRoll.center = CGPointMake(187.5, 333.5)
        //self.view.addSubview(imageFromCameraRoll)
        
    //画像拡大
    //@IBAction func plus(senter: AnyObject){
            
        //if(width*scale < screenwidth*2){
           // scale += 0.2
        
    //    }
   // }
        //let rect:CGRect = CGRectMake(0, 0, width*scale, height*scale)
        //imageFromCameraRoll.frame = rect;
       // imageFromCameraRoll.center = CGPointMake(187.5, 333.5)
       // self.view.addSubview(imageFromCameraRoll)
    
    //}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        //contentModeを設定
        // http://anthrgrnwrld.hatenablog.com/entry/2015/10/17/123659 参照
        //.ScaleAspectFit
        //.ScaleAspectFill
        //.ScaleToFill
    }
    
    

    @IBAction func detectegde(){
        self.navigationController?.navigationBarHidden = true
        NSLog("detecting egde")
        if processflg == false {
            edge = Detector.DetectEdgeWithImage(image)
            processflg = true
        }
        
        if edgeflg == false{
            NSLog("yes")
            imageFromCameraRoll.image = edge
            edgeflg = true
        } else {
            NSLog("no")
            imageFromCameraRoll.image = image
            edgeflg = false
        }
        self.view.addSubview(imageFromCameraRoll)
    }
    
    @IBAction func captureFace() {
        self.navigationController?.navigationBarHidden = true
        if process_face_flg == false {
            faceImage = self.detector.recognizeFace(image)
            process_face_flg = true
        }
        
        if faceflg == false {
            imageFromCameraRoll.image = faceImage
            faceflg = true
        } else {
            imageFromCameraRoll.image = image
            faceflg = false
        }
    }
    
    @IBAction func blurFace(){
        self.navigationController?.navigationBarHidden = true
        if process_blur_flg == false {
            blurImage = self.detector.applyGaussianFilter(image)
            process_blur_flg = true
        }
        
        if blurflg == false {
            imageFromCameraRoll.image = blurImage
            blurflg = true
        } else {
            imageFromCameraRoll.image = image
            blurflg = false
        }

        
    }
    
    @IBAction func savePic(sender : AnyObject){
        let image:UIImage = imageFromCameraRoll.image!
        
        if let data: UIImage = image{
            UIImageWriteToSavedPhotosAlbum(data, self, "image:didFinishSavingWithError:contextInfo:",nil)
        }
        
        
    }
    


    func pickImageFromLibrary() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {    //追記
            
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言しているという理解
            let controller = UIImagePickerController()
            
            //おまじないという認識で今は良いと思う
            controller.delegate = self
            
            //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            //以下はカメラロールの例
            //.Cameraを指定した場合はカメラを呼び出し(シミュレーター不可)
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo: [String : AnyObject]) {
        
        if didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] != nil {
        
            image = didFinishPickingMediaWithInfo[UIImagePickerControllerOriginalImage] as? UIImage
            let screenWidth = self.view.bounds.width
            let width = image.size.width
            let height = image.size.height
            let scale = screenWidth / width
            let rect: CGRect = CGRectMake(0, 0, screenWidth, screenWidth)
            imageFromCameraRoll.image = image
            imageFromCameraRoll.clipsToBounds = true
            imageFromCameraRoll.frame = rect
        }
        processflg = false
    
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage,didFinishSavingWithError error: NSError!,contextInfo:UnsafeMutablePointer<Void>){
        print("1")
        
        if error != nil {
            print(error.code)
            
        }
        
    }
    
    @IBAction func pressCameraRoll(sender: AnyObject) {
        self.navigationController?.navigationBarHidden = true
        pickImageFromLibrary()  //ライブラリから写真を選択する
        NSLog("hogehoge");
    }
    
    @IBAction func colorFilter(){
        
        //加工したい画像
        let filterImage : CIImage = CIImage(image: originalImage)!
        
        //加工の準備　色調節
        filter = CIFilter(name: "CIColorControls")!
        filter.setValue(filterImage, forkpty: kCIInputImageKey)
        filter.setValue(1.0, forKey: "inputSaturation")
        filter.setValue(0.5, forKey: "inputBrightness")
        filter,setValue(2.5, forKey: "inputContrast")
        
        //加工した画像表示
        let ctx = CIContext(options:nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, fromRect:filter.outputImage!.extent)
        cameraImageView.image = UIImage(CGImage: cgImage)
    }
    
}









