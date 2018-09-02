//
//  ProFeaturesViewController.swift
//  Wins
//
//  Created by Eman I on 5/29/16.
//  Copyright © 2016 Eman. All rights reserved.
//

import UIKit
import StoreKit

class ProFeaturesViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver  {

    
    @IBAction func restorePurchases(_ sender: AnyObject) {
        
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    @IBOutlet var restoreButton: UIButton!
    @IBAction func upgrade(_ sender: AnyObject) {
        
        for product in list {
            let prodID = product.productIdentifier
            if prodID ==  "IAP identifier" {
                p = product
                buyProduct()
                break;
            }
        }
        
    }
    @IBOutlet var proButton: UIButton!
    @IBOutlet var backbutton: UIButton!
    @IBAction func goback(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    func buyProduct() {
        print("bought \(p.productIdentifier)")
        let pay = SKPayment(product: p)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(pay as SKPayment)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("transactions restored")
        let purchasedItemIds = []
        for transaction in queue.transactions {
            let t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            switch prodID {
            case "in app identifier":
                //unlock the app
                goPro()
                print("time to unlock:")
            default:
                print("IAP not set up")
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("product request")
        let myproducts = response.products
        
        for product in myproducts {
            print("product added")
            print(product.productIdentifier)
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            list.append(product as SKProduct)
        }
        
        proButton.isEnabled = true
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        
        for transaction:AnyObject in transactions {
            let trans = transaction as! SKPaymentTransaction
            print(trans.error)
            
            switch trans.transactionState {
            
            case.purchased:
                print("worked out lets give pro")
                print(p.productIdentifier)
                
                let prodId = p.productIdentifier
                switch prodId {
                case "in app identifier":
                    //unlock the app
                    print("time to unlock:")
                    goPro()
                default:
                    print("IAP not set up")
                }
            
                queue.finishTransaction(trans)
                break;
                
            case.failed:
                print("buy error")
                queue.finishTransaction(trans)
                break;
         
            default:
                print("default case")
                break;
            }
            
        }
    }
    
    func finishTransaction(_ trans:SKPaymentTransaction){
        print("finish trans")
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans")
    }
    
    func goPro() {
        //user defaults
    }
    
    @IBOutlet var featuresCollection: UICollectionView!
    
    fileprivate var features = Feature.createFeatures()
    override func viewDidLoad() {
        super.viewDidLoad()

        proButton.isEnabled = false
       
        let background = CAGradientLayer().greenLayer()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        // Do any additional setup after loading the view.
        
        //set up IAP
        if (SKPaymentQueue.canMakePayments()) {
            print("IAP is enabled, loading")
            let productID:NSSet = NSSet(objects: "iap identifier")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("please enable IAP")
        }
    }

    fileprivate struct Storyboard {
        static let CellIdentifier = "Feature Cell"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension ProFeaturesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of features \(features.count)")
        return features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = featuresCollection.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! FeaturesCollectionViewCell
        
        cell.feature = self.features[(indexPath as NSIndexPath).item]
        
        return cell 
    }
}

extension ProFeaturesViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let layout = self.featuresCollection?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
}
