//
//  ViewController.swift
//  PokeList
//
//  Created by UtahC on 2016/8/26.
//  Copyright © 2016年 UtahC. All rights reserved.
//

import UIKit

extension NSDate {
    struct Formatter {
        static let iso8601: NSDateFormatter = {
            let formatter = NSDateFormatter()
            formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)
            formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
            return formatter
        }()
    }
    var iso8601: String { return Formatter.iso8601.stringFromDate(self) }
}

extension String {
    var dateFromISO8601: NSDate? {
        return NSDate.Formatter.iso8601.dateFromString(self)
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let fullScreenSize = UIScreen.mainScreen().bounds.size
    var pokemons: [PokemonInfo] = []
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        
        // Do any additional setup after loading the view, typically from a nib.
        tableView = UITableView(frame: CGRect(
            x: 0, y: 20,
            width: fullScreenSize.width,
            height: fullScreenSize.height - 20),
            style: .Plain)
        
        // 註冊 cell
        tableView.registerClass(
            UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // 設置委任對象
        tableView.delegate = self
        tableView.dataSource = self
        
        // 分隔線的樣式
        tableView.separatorStyle = .SingleLine
        
        // 分隔線的間距 四個數值分別代表 上、左、下、右 的間距
        tableView.separatorInset =
            UIEdgeInsetsMake(0, 20, 0, 20)
        
        // 是否可以點選 cell
        tableView.allowsSelection = true
        
        // 是否可以多選 cell
        tableView.allowsMultipleSelection = false
        
        // 加入到畫面中
        self.view.addSubview(tableView)
        
        var timer = NSTimer()
        timer.invalidate() // just in case this button is tapped multiple times
        
        // start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(actionMethod), userInfo: nil, repeats: true)
        
        tableView.visibleCells
        
        
    }
    
    func actionMethod() {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 必須實作的方法：每一組有幾個 cell
    func tableView(tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    // 必須實作的方法：每個 cell 要顯示的內容
    func tableView(tableView: UITableView,
                   cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            // 取得 tableView 目前使用的 cell
            let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            
            // 設置 Accessory 按鈕樣式
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    cell.accessoryType = .Checkmark
                } else if indexPath.row == 1 {
                    cell.accessoryType = .DetailButton
                } else if indexPath.row == 2 {
                    cell.accessoryType =
                        .DetailDisclosureButton
                } else if indexPath.row == 3 {
                    cell.accessoryType = .DisclosureIndicator
                }
            }
            
//            if indexPath.row % 2 == 1 {
//                cell.backgroundColor = UIColor.grayColor()
//            }
            
            // 顯示的內容
            if let label = cell.textLabel {
                label.text = "\(pokemons[indexPath.row].name)"
            }
            
//            if let detail = cell.detailTextLabel {
//                detail.text = "in \(Int(pokemons[indexPath.row].until.timeIntervalSinceNow)) seconds"
//            }
//            var origin = CGPoint(x: cell.bounds.origin.x, y: cell.bounds.origin.y)
//            origin.y = origin.y + cell.bounds.height - 20
            
//            let url = NSURL(fileURLWithPath: "001.png")
//            if let data = NSData(contentsOfURL: url)
//            {
//                cell.imageView?.image = UIImage(data: data)
//            }
            
            let fileName = pokemons[indexPath.row].icon.characters.split("/").map(String.init).last!
            cell.imageView?.image = UIImage(named: fileName.characters.split(".").map(String.init).first!)
            
            var subLabel = UILabel(frame: CGRect(origin: cell.bounds.origin, size: CGSize(width: cell.bounds.width, height: 15)).offsetBy(dx: 235, dy: 0))
            subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: subLabel.font.pointSize)
            subLabel.font = subLabel.font.fontWithSize(12)
            subLabel.text = String("in \(Int(pokemons[indexPath.row].until.timeIntervalSinceNow)) sec")
            
            cell.addSubview(subLabel)
            
            subLabel = UILabel(frame: CGRect(origin: cell.bounds.origin, size: CGSize(width: cell.bounds.width, height: 15)).offsetBy(dx: 235, dy: 12))
            subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: subLabel.font.pointSize)
            subLabel.font = subLabel.font.fontWithSize(12)
            subLabel.text = String(format: "Lat: %10f", pokemons[indexPath.row].coords.latitude)
            
            cell.addSubview(subLabel)
            
            subLabel = UILabel(frame: CGRect(origin: cell.bounds.origin, size: CGSize(width: cell.bounds.width, height: 15)).offsetBy(dx: 235, dy: 24))
            subLabel.font = UIFont(name: "HelveticaNeue-Bold", size: subLabel.font.pointSize)
            subLabel.font = subLabel.font.fontWithSize(12)
            subLabel.text = String(format: "Lng: %10f", pokemons[indexPath.row].coords.longitude)
            
            cell.addSubview(subLabel)
            
            return cell
    }
    
    func getData() {
        let postEndpoint: String = "http://pokesnipers.com/api/v1/pokemon.json"
        let url = NSURL(string: postEndpoint)!
        
        var urlContents: NSString?
        do {
            urlContents = try NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding)
            let jsonRoot =
                try NSJSONSerialization.JSONObjectWithData(urlContents!.dataUsingEncoding(NSUTF8StringEncoding)!, options: .AllowFragments)
            let jsonArray = jsonRoot["results"] as! [[String: AnyObject]]
            for var jsonObj in jsonArray {
                let id = jsonObj["id"] as! Int
                let name = jsonObj["name"] as! String
                let coordsString = jsonObj["coords"] as! String!
                let lat = Double(coordsString.characters.split(",").map(String.init)[0])
                let lng = Double(coordsString.characters.split(",").map(String.init)[1])
                let coords = Coordinate(latitude: lat!, longitude: lng!)
                let until = (jsonObj["until"] as! String).dateFromISO8601!
                var iv = 0
                if jsonObj["iv"] != nil {
                    iv = jsonObj["iv"] as! Int
                }
                let attacks: [String?] = [nil, nil]
                let icon = jsonObj["icon"] as! String
                let rarity = jsonObj["rarity"] as! String
                let pokeInfo = PokemonInfo(id: id, name: name, coords: coords, until: until, iv: iv, attacks: attacks, icon: icon, rarity: rarity)
                pokemons.append(pokeInfo)
            }
        }
        catch {
            print("read failed")
        }
        //print(urlContents)
    }
    
    class PokemonInfo {
        var id: Int
        var name: String
        var coords: Coordinate
        var until: NSDate
        var iv: Int
        var attacks: [String?]
        var icon: String
        var rarity: String
        
        init(id: Int, name: String, coords: Coordinate, until: NSDate, iv: Int, attacks: [String?], icon: String, rarity: String) {
            self.id = id
            self.name = name
            self.coords = coords
            self.until = until
            self.iv = iv
            self.attacks = attacks
            self.icon = icon
            self.rarity = rarity
        }
    }
    
    struct Coordinate {
        var latitude: Double
        var longitude: Double
    }
}