//
//  PokemonViewController.swift
//  PokeList
//
//  Created by UtahC on 2016/9/1.
//  Copyright © 2016年 UtahC. All rights reserved.
//

import UIKit
import GoogleMaps

class PokemonViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let screenBounds = UIScreen.mainScreen().bounds
    var pokemonInfo: PokemonInfo!
    var tableView: UITableView!
    
    convenience init (pokeInfo: PokemonInfo) {
        self.init()
        self.pokemonInfo = pokeInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Pokemon Information"

        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenBounds.width, height: screenBounds.height / 2 - 5), style: .Plain)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "PokemonInformationCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.allowsMultipleSelection = false
        self.view.addSubview(tableView)
        
        let camera = GMSCameraPosition.cameraWithLatitude(pokemonInfo.coords.latitude, longitude: pokemonInfo.coords.longitude, zoom: 3)
        let mapView = GMSMapView.mapWithFrame(CGRect(x: 0, y: screenBounds.height / 2,
            width: screenBounds.width, height: screenBounds.height / 3), camera: camera)
        mapView.myLocationEnabled = true
        self.view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(pokemonInfo.coords.latitude, pokemonInfo.coords.longitude)
        marker.title = "\(pokemonInfo.name)"
        marker.map = mapView
        
        let button = UIButton(frame: CGRect(origin: CGPoint.zero,
            size: CGSize(width: screenBounds.width / 4, height: screenBounds.width / 4)))
        //button.frame.size = CGSize(width: screenBounds.width / 2, height: screenBounds.width / 4)
        let mapViewMaxY = screenBounds.height / 2 + screenBounds.height / 3
        let spaceHeight = screenBounds.height - mapViewMaxY
        print("\(mapViewMaxY + spaceHeight / 2)/\(screenBounds.height)")
        button.center = CGPoint(x: screenBounds.width / 2, y: mapViewMaxY + spaceHeight / 2)
        button.setImage(UIImage(named: "Button-Next-icon"), forState: .Normal)
        self.view.addSubview(button)
        
        _ = NSTimer(timeInterval: 1, target: self, selector: #selector(refreshCountdownTimerSeconds), userInfo: nil, repeats: true)
    }
    
    func refreshCountdownTimerSeconds() {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("\(scrollView.contentOffset.y)")
        scrollView.contentOffset.y = -65;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "PokemonInformationCell")
        switch (indexPath.row) {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = pokemonInfo.name
        case 1:
            cell.textLabel?.text = "Until"
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            cell.detailTextLabel?.text = "\(dateFormatter.stringFromDate(pokemonInfo.until))"
        case 2:
            
            cell.textLabel?.text = "Rarity"
            cell.detailTextLabel?.text = "\(pokemonInfo.rarity)"
        case 3:
            cell.textLabel?.text = "IV (%)"
            if pokemonInfo.iv <= 0 {
                cell.detailTextLabel?.text = "unknow"
            }
            else {
                cell.detailTextLabel?.text = "\(pokemonInfo.iv)"
            }
        case 4:
            cell.textLabel?.text = "Latitude"
            cell.detailTextLabel?.text = "\(pokemonInfo.coords.latitude)"
        case 5:
            cell.textLabel?.text = "Longitude"
            cell.detailTextLabel?.text = "\(pokemonInfo.coords.longitude)"
        default:
            break
        }
        
        return cell
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
