//
//  CatagoryViewController.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import UIKit
import  CoreLocation

struct CatagoryCellConstants
{
    static let height = 200.0
}

class CatagoryViewController: BaseViewController
{
    var locationCatagories = [Catagory]()
    var overlay :UIView?
    @IBOutlet weak var catagoryTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        populateLocationCatagories()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        animateTable()
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: Defaults.newUserKey)
        {
            showTutorialOverlay()
            UserDefaults.standard.set(false, forKey: Defaults.newUserKey)
        }
    }
    
    
    private func showTutorialOverlay()
    {
        overlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: view.bounds.size.height))
        overlay?.backgroundColor = #colorLiteral(red: 0.08026780933, green: 0.03767936677, blue: 0.02108437568, alpha: 1)
        overlay?.alpha = 0.0
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(removeTutorialOverlay))
        overlay?.addGestureRecognizer(tapGesture)
        self.view.addSubview(overlay!)
        view.bringSubview(toFront: overlay!)
        animateOverLay(isPresenting:true)
    }
    
  private func animateOverLay(isPresenting flag:Bool)
    {
        UIView.animate(withDuration: 0.5,
                       delay: flag ? 0.5 : 0.0 ,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        self.overlay?.alpha = flag ? 0.8 : 0.0
        },
                       completion: { (sucess) in
                        
                        if sucess
                        {
                            self.overlay?.isHidden = flag ? false : true
                        }
        })
    }
    
    @objc  private func removeTutorialOverlay()
    {
        animateOverLay(isPresenting: false)
    }
    
    
    private func populateLocationCatagories()
    {
        let catagory1 = Catagory(type: .garbage)
        let catagory2 = Catagory(type: .indraCanteen)
        let catagory3 = Catagory(type: .washroom)
        locationCatagories.append(catagory1)
        locationCatagories.append(catagory2)
        locationCatagories.append(catagory3)
    }
    
    private func animateTable()
    {
        catagoryTableView.reloadData()
        let cells = catagoryTableView.visibleCells
        let tableHeight = catagoryTableView.bounds.size.height
        
        for cell in cells
        {
            cell.transform = CGAffineTransform(translationX: 0, y:tableHeight )
        }
        
        var delayCounter = 0.3
        for cell in cells
        {
            UIView.animate(withDuration: 1.75,
                           delay: Double(delayCounter) * 0.05,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                animations: {
                    
                    cell.transform = CGAffineTransform.identity
            },
                completion: nil)
            delayCounter += 1
        }
        
        for cell in cells
        {
            if let catagoryCell  = cell as? CatagoryTableViewCell
            {
                catagoryCell.animateMyLabel()
            }
        }
    }
    
    private func navigateToLocationController(locationType:LocationType)
    {
        let locationVc = self.storyboard?.instantiateViewController(withIdentifier: "LocationFinderViewController") as! LocationFinderViewController
        locationVc.selectedCatagory = locationType
        self.navigationController?.pushViewController(locationVc, animated: true)
    }
}

extension CatagoryViewController:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return CGFloat( CatagoryCellConstants.height)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let catatogory = locationCatagories[indexPath.row]
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        {
            navigateToLocationController(locationType: catatogory.type)
        }
        else
        {
            MyLocationManager.shared.requestForAccess{[weak self]status in
                if status
                {
                    self?.navigateToLocationController(locationType: catatogory.type)
                }
                else
                {
                // show location acces required messege
                }
            }
        }
    }
}

extension CatagoryViewController:UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCatagories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let catagoryCell = tableView.dequeueReusableCell(withIdentifier: "Catagory", for: indexPath) as! CatagoryTableViewCell
        catagoryCell.myCatagory = locationCatagories[indexPath.row]
        return catagoryCell
    }
}
