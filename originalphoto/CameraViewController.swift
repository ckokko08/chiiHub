//
//  CameraViewController.swift
//  originalphoto
//
//  Created by 久保田千尋 on 2016/06/21.
//  Copyright © 2016年 Chihiro Kubota. All rights reserved.
//

import UIKit
import Fusuma

class CameraViewController: UIViewController,FusumaDelegote {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.presentFusuma()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func camera(){
    }
    
        @IBAction func photo(){
    }
    
    func presentFusuma(){
        let fusuma = FusumaViewController()
        fusuma.delegote = self
        self.presentedViewController(fusuma, animated: false, completion: nil)
    }
    
    func fusumaImageSelected(image: UIImage){
        self.toViewTransition(image)
    }
    
    func fusumaVideoCompleted(withfileURL fileURL: NSURL){
        
    }
    
    func toViewTransition(image: UIImage){
        self.performSegueWithIdentifier("toView", sender: image)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toView"{
            let viewCon = segue.destinationViewController as! ViewController
            viewCon.image = sender as! UIImage
    }
        
    }
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
