//
//  BurgerVC.swift
//  Burgerdex
//
//  Created by Matthew Sullivan on 2018-01-03.
//  Copyright © 2018 Dev & Barrel Inc. All rights reserved.
//
import UIKit

class BurgerVC: UITableViewController {
    
    private let kLazyLoadCollectionCellImage = 1
    
    var burger: BurgerPreview!
    var burgerAttr = [Array<BurgerObject>]()
    var badges = [Badge]()
    var fusionBurgers = [BurgerPreview]()
    var burgerThumbnail : UIImage!
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        self.title = burger.name
        
        layoutBurgerView()
    
    }
    
    func layoutBurgerView(){
        
        let burgerHeaderView = BurgerHeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        
        self.tableView.tableHeaderView  = burgerHeaderView
        
        burgerHeaderView.burgerImage.image =  burgerThumbnail
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        //always fill the view
        blurEffectView.frame = burgerHeaderView.burgerImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.9
        
        burgerHeaderView.burgerImage.addSubview(blurEffectView)
        
        let url = URL(string: burger.photoUrl)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async(execute: {
                
                
                UIView.animate(withDuration: 0.5, animations: {
                    
                    blurEffectView.alpha = 0.0
                    
                }, completion: { _ in
                    
                    burgerHeaderView.burgerImage.image  = UIImage(data: data!)
                    
                    blurEffectView.removeFromSuperview()
                })
                
                
            })
            
        }).resume()
        
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        var burgerInfo = Burger.generateBurgerPlaceholderInformation()
        
        self.burgerAttr.append([burgerInfo as BurgerObject])
    
        self.tableView.allowsSelection = false
        
        TableLoader.addLoaderTo(self.tableView)
        
        self.tableView.reloadData()
        
        Burger.fetchBurgerDetails(burgerID: burger.burgerID,completion: { (data) in
            
            burgerInfo = data
            
            if burgerInfo.fused.count > 0 {
                
                for burger in burgerInfo.fused {
                    
                    let name = burger["name"] as? String
                    let kitchen = burger["kitchen"] as? String
                    let imagePath = burger["image"] as? String
                    var catalogueNumber = burger["id"] as? Int
                    let imageOrigin = "https://burgerdex.ca/"
                    
                    let pattyImagePath = imageOrigin + imagePath!
                    
                    if catalogueNumber == nil {catalogueNumber = 0}
                    
                    
                    
                    guard let burgerPreview = BurgerPreview.init(name: name!,
                                                                 kitchen: kitchen!,
                                                                 catalogueNumber: catalogueNumber!,
                                                                 photoUrl: pattyImagePath,
                                                                 photo: UIImage(),
                                                                 burgerID: catalogueNumber!)else{
                                                                    fatalError("Unable to instantiate burgerPreview")
                    }
                    
                    self.fusionBurgers += [burgerPreview]
                }
                
            }
            
            self.tableView.allowsSelection = true
            TableLoader.removeLoaderFrom(self.tableView)
            
            self.burgerAttr[0] = [burgerInfo as BurgerObject]
            self.burgerAttr.append(self.fusionBurgers)
            
            guard let ratingBadge = Badge.init(ratingTitle: burgerInfo.rating,
                                               badgeTitle: "rating",
                                               badgeIcon: UIImage(named: "rating")!
                )else {
                    
                    fatalError("Unable to instantiate rating badge")
            }
            
            self.badges += [ratingBadge]
            
            if burgerInfo.fusion {
                
                guard let fusionBadge = Badge.init(ratingTitle: "",
                                                   badgeTitle: "fusion",
                                                   badgeIcon: UIImage(named: "fusion")!
                    )else {
                        
                        fatalError("Unable to instantiate fusion badge")
                }
                
                self.badges += [fusionBadge]
            }
            
            if burgerInfo.veggie {
                
                guard let veggieBadge = Badge.init(ratingTitle: "",
                                                   badgeTitle: "veggie",
                                                   badgeIcon: UIImage(named: "veggie")!
                    )else {
                        
                        fatalError("Unable to instantiate veggie badge")
                }
                
                self.badges += [veggieBadge]
            }
            
            if burgerInfo.spicy {
                
                guard let spicyBadge = Badge.init(ratingTitle: "",
                                                  badgeTitle: "spicy",
                                                  badgeIcon: UIImage(named: "spicy")!
                    )else {
                        
                        fatalError("Unable to instantiate spicy badge")
                }
                
                self.badges += [spicyBadge]
            }
            
            if burgerInfo.extinct {
                
                guard let extinctBadge = Badge.init(ratingTitle: "",
                                                    badgeTitle: "extinct",
                                                    badgeIcon: UIImage(named: "available")!
                    )else {
                        
                        fatalError("Unable to instantiate extinct badge")
                }
                
                self.badges += [extinctBadge]
            }
            
            if burgerInfo.seasonal {
                
                guard let seasonalBadge = Badge.init(ratingTitle: "",
                                                     badgeTitle: "seasonal",
                                                     badgeIcon: UIImage(named: "seasonal")!
                    )else {
                        
                        fatalError("Unable to instantiate seasonal badge")
                }
                
                self.badges += [seasonalBadge]
            }
            
            if burgerInfo.hasChallenge {
                
                guard let hasChallengeBadge = Badge.init(ratingTitle: "",
                                                         badgeTitle: "challenge",
                                                         badgeIcon: UIImage(named: "hasChallenge")!
                    )else {
                        
                        fatalError("Unable to instantiate hasChallenge badge")
                }
                
                self.badges += [hasChallengeBadge]
            }
            
            if burgerInfo.hasMods {
                
                guard let hasModsBadge = Badge.init(ratingTitle: "",
                                                    badgeTitle: "mods",
                                                    badgeIcon: UIImage(named: "hasMods")!
                    )else {
                        
                        fatalError("Unable to instantiate hasChallege badge")
                }
                
                self.badges += [hasModsBadge]
            }
            
            self.tableView.reloadData()
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? BurgerTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return burgerAttr.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return burgerAttr[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If first row it's our burgers information. Else it's fusion burger cells.
         if indexPath.section == 0 {
            
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "BurgerInfoCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? BurgerTableViewCell  else{
                fatalError("The dequeued cell is not an instance of BurgerTableViewCell.")
            }
            
            let burger = burgerAttr[indexPath.section][indexPath.row] as! Burger
            
            cell.discoveryDate.text = burger.dateCaptured
            cell.price.text = burger.price
            cell.region.text = burger.location
            cell.descript.text = burger.descript
            
            let ingredients = "• " + burger.ingredients.replacingOccurrences(of: ",", with: "\n\n• ")
            
            cell.ingredients.text = ingredients
            
            if burger.fused.count == 0 {cell.fusionLabel.text = ""}
            
            return cell
            
         }else{
            
            // Table view cells are reused and should be dequeued using a cell identifier.
            let cellIdentifier = "CatalogueTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CatalogueTableViewCell  else {
                fatalError("The dequeued cell is not an instance of CatalogueTableViewCell.")
            }
            
            let burger = burgerAttr[indexPath.section][indexPath.row] as! BurgerPreview
            
            cell.burgerName.text = burger.name
            cell.kitchenName.text = burger.kitchen
            cell.catalogueNumberLabel.text = "No."
            
            
            if burger.catalogueNumber == 0 {
                
                cell.catalogueNumberNumber.text = "?"
                
            }else{
                
                cell.catalogueNumberNumber.text = String(burger.catalogueNumber)
                
            }
            
            cell.burgerID = burger.burgerID
            
            updateImageForCell(cell,
                               inTableView: tableView,
                               withImageURL: burger.photoUrl,
                               andImageView: cell.burgerImage!,
                               atIndexPath: indexPath)

            
            return cell
           
        }

        
    }
    
    func updateImageForCell(_ cell: UITableViewCell,
                            inTableView tableView: UITableView,
                            withImageURL: String,
                            andImageView: UIImageView,
                            atIndexPath indexPath: IndexPath) {
        
        let imageView = andImageView
        
        imageView.image = kLazyLoadPlaceholderImage
        
        let burger = burgerAttr[indexPath.section][indexPath.row] as! BurgerPreview
        
        let imageURL = burger.photoUrl
        
        ImageManager.sharedInstance.downloadImageFromURL(imageURL) { (success, image) -> Void in
            
            if success && image != nil {
                
                if (tableView.indexPath(for: cell) as NSIndexPath?)?.row == (indexPath as NSIndexPath).row {
                    
                    imageView.image = image
                    //Convert photo back to UIImage and use this instead
                    burger.photo = imageView.image!
                    
                }
            }
        }
    }
    
    func loadImagesForOnscreenRows() {
        
            if burgerAttr.count > 0 {
        
                let visiblePaths = tableView.indexPathsForVisibleRows ?? [IndexPath]()
    
                for indexPath in visiblePaths {
                    
                    let burger = burgerAttr[indexPath.section][indexPath.row] as! BurgerPreview
                    
                    let cell = tableView(self.tableView, cellForRowAt: indexPath) as! CatalogueTableViewCell
                    
                    updateImageForCell(cell, inTableView: tableView,
                                       withImageURL: burger.photoUrl,
                                       andImageView: cell.burgerImage!,
                                       atIndexPath: indexPath)
                }
            }
        
    }
    
    // MARK: - When decelerated or ended dragging, we must update visible rows
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        /*
         if let _ = scrollView as? UITableView {
            //loadImagesForOnscreenRows()
            
         }
 */
    }
    /*
     override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
     if !decelerate { loadImagesForOnscreenRows() }
     }
     */
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
         if section == 0 {
            
            let  cell = tableView.dequeueReusableCell(withIdentifier: "BurgerHeaderCell") as! BurgerHeaderTableViewCell
            
            cell.burgerName.text = burger.name
            cell.kitchenName.text = burger.kitchen
            cell.catalogueNumberLabel.text = "No."
            cell.catalogueNumberNumber.text = String(burger.catalogueNumber)
            
            return cell
            
         }else{
            
            return nil
            
        }
        
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let _ = scrollView as? UITableView {
            
            let headerView = self.tableView.tableHeaderView as! BurgerHeaderView
            
            headerView.scrollViewDidScroll(scrollView: scrollView)
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        if indexPath.section == 1 {
            
            return 80;
            
        }else{
            
            return tableView.rowHeight;
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            
            return 0.0;
            
        }else{
            
            return 80.0
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BurgerVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return badges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let burgerBadge = badges[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BadgeCell", for: indexPath) as? BurgerBadgeCollectionViewCell  else{
            
            fatalError("The dequeued cell is not an instance of BurgerTableViewCell.")
        }
        
        cell.ratingLabel.text = burgerBadge.ratingTitle
        cell.badgeTitle.text = burgerBadge.badgeTitle
        cell.badgeImage.image = burgerBadge.badgeIcon
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
    }
}