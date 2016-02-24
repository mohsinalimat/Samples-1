//
//  ViewController.swift
//  Sample
//
//  Created by Lasha Efremidze on 2/23/16.
//  Copyright © 2016 Lasha Efremidze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = ["https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12751247_1556549097988432_1552574224_n.jpg?ig_cache_key=MTE5MTY0OTc5MDg3OTI4NjkyOA%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12747655_834461406677253_178252631_n.jpg?ig_cache_key=MTE5MTYxNDgyNDY1MzcwMTY4Mg%253D%253D.2.c", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12724817_231270400541788_239495761_n.jpg?ig_cache_key=MTE5MTU0NjUyNDk2MTU4NTM0Ng%253D%253D.2", "https://scontent.cdninstagram.com/l/t51.2885-15/s640x640/e35/12783423_240906046242745_1164986462_n.jpg?ig_cache_key=MTE5MTU0MDUwMDk1OTU3NDAzNg%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12747766_788911781214573_1500886810_n.jpg?ig_cache_key=MTE5MTUzMTc3OTMxNTQ0ODYyMg%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/11350726_1561830240811202_765847719_n.jpg?ig_cache_key=MTE5MTQ5OTA5MzM4MTkwMDM4MA%253D%253D.2.c", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12750085_1073491459357363_456047886_n.jpg?ig_cache_key=MTE5MTQ4MTcxOTM0MDQ4MzkyNQ%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12716514_254677984877817_56950437_n.jpg?ig_cache_key=MTE5MTQ2MDYwNjE3ODU2MDk1MA%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12446048_875353972562195_1932785872_n.jpg?ig_cache_key=MTE5MTQzODk1MjExMTA4MTgyMw%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12750296_897798193650893_1390433434_n.jpg?ig_cache_key=MTE5MTQzNjM3Mjg2NTc3OTk3Nw%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12728592_1736044019963196_2122317496_n.jpg?ig_cache_key=MTE5MTQwNTQ0NDM0MzIyMzEwNA%253D%253D.2.c", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12751292_967249320018098_1812328001_n.jpg?ig_cache_key=MTE5MTM1MzM0OTYyMTQzNzQzNA%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12750359_1571177479865580_62848682_n.jpg?ig_cache_key=MTE5MTMwMjcyOTUyOTc5NTg2Mg%253D%253D.2", "https://scontent.cdninstagram.com/l/t51.2885-15/s640x640/e35/12751129_744965672269739_49822591_n.jpg?ig_cache_key=MTE5MTE2NDE0NDMwODk2MzQyOQ%253D%253D.2.c", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12446045_1718792375003250_1674124247_n.jpg?ig_cache_key=MTE5MTE0MDI4NjE2NjY5NjIwOQ%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12783415_1662427170648826_1291399988_n.jpg?ig_cache_key=MTE5MTEwMzU5MTE3NTkwNjU4OQ%253D%253D.2", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12749791_223406708006836_1246552848_n.jpg?ig_cache_key=MTE5MTA5NzU0MzI3MjE4MDcyOQ%253D%253D.2.c", "https://scontent.cdninstagram.com/t51.2885-15/s640x640/e35/12783892_163755587340119_904021412_n.jpg?ig_cache_key=MTE5MTA4MDYxMzIzMjcyMDI1NA%253D%253D.2.c"]
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let images = urls.flatMap { UIImage(data: NSData(contentsOfURL: NSURL(string: $0)!)!) }
            dispatch_async(dispatch_get_main_queue()) {
                let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("CollectionViewControllerId") as! CollectionViewController
                viewController.images = images
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.modalTransitionStyle = .CrossDissolve
                navigationController.modalPresentationStyle = .OverFullScreen
                self.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
