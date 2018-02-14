//
//  SecondViewController.swift
//  YtDownloader
//
//  Created by Emir Beytekin on 5.01.2017.
//  Copyright © 2017 Emir Beytekin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SCLAlertView
import AVKit
import AVFoundation
import MediaPlayer
import AssetsLibrary
import SQLite

class SecondViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var objects = [MyVideo]()
    
    var refreshControl = UIRefreshControl()
    
    let myDownloadedFiles = Table("myDownloadedFiles")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Library"
        
        let cellNib: UINib = UINib(nibName: "SecondTableViewCell", bundle: nil)
        
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
        
        tableView?.register(cellNib, forCellReuseIdentifier: "SecondTableViewCell")
        
        list()
        
        self.refreshControl.addTarget(self, action: #selector(list), for: UIControlEvents.valueChanged)
        
        self.tableView?.addSubview(refreshControl)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        list()
        self.tabBarController?.tabBar.items?[1].badgeValue = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func list() {
        
        objects.removeAll()
        do {
            let db = try Connection(Utils.getDbWay())
            let sqlCommand = "SELECT * FROM myDownloadedFiles"
            for row in try db.prepare(sqlCommand) {
                print("id: \(row[0]), name: \(row[1]), filePath: \(row[2])")
                
                let asd = MyVideo()
                asd.videoId = row[0]! as? Int64
                asd.videoTitle = row[1]! as? String
                asd.videoURL = row[2]! as! String
                self.objects.append(asd)
            }
            self.tableView.reloadData()
        } catch {
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSection: NSInteger = 0
        
        if objects.count > 0 {
            
            self.tableView?.backgroundView = nil
            tableView.separatorStyle = .singleLine
            numOfSection = 1
            
            
        } else {
            
            tableView.separatorStyle = .none
            let emptyView = UIView(frame: self.view.bounds)
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:self.tableView!.bounds.size.width, height:self.tableView!.bounds.size.height))
            noDataLabel.text = "No videos found :("
            noDataLabel.textColor = UIColor.uGrayColor()
            noDataLabel.textAlignment = NSTextAlignment.center
            noDataLabel.font = UIFont(name: "Avenir-Black", size: 18.0)

            emptyView.addSubview(noDataLabel)
            
            self.tableView?.backgroundView = emptyView
            
        }
        
        return numOfSection
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return objects.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = "SecondTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! SecondTableViewCell!
        
        let a = objects[indexPath.row] as MyVideo
        cell?.videoNameLabel.text = a.videoTitle

        
        self.tableView?.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView?.tableFooterView?.isHidden = true
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let a = objects[indexPath.row] as MyVideo
        
        print(a.videoURL)
        
        let string = a.videoURL?.replacingOccurrences(of: "file:///", with: "")
        
        let videoDataPath = string
        
        let filePathURL = URL(fileURLWithPath: videoDataPath!)
        
        let alertView = SCLAlertView()
        let alertView2 = SCLAlertView()
        
        alertView.addButton("Watch Video") {
            
            let player = AVPlayer(url: filePathURL)
            
            let playerController = AVPlayerViewController()
            
            playerController.player = player
            
            self.present(playerController, animated: true) {
                
                player.play()
            }
        }
        
        alertView.addButton("Share on social app") {
            
            UISaveVideoAtPathToSavedPhotosAlbum(string!,nil,nil,nil);
            alertView2.showSuccess("Saved", subTitle: "Saved successfully", closeButtonTitle: "Okay")
            
        }
        
        alertView.addButton("Delete") {
            
            
            do {
                let objId = self.objects[indexPath.row]
                let db = try Connection(Utils.getDbWay())
                let alice = self.myDownloadedFiles.filter(a.videoId! == rowid)
                try db.run(alice.delete())
                
                self.objects.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .middle)
                
            } catch {
                
            }
            
            do {
                let fileManager = FileManager.default
                
                // Check if file exists
                if fileManager.fileExists(atPath: string!) {
                    // Delete file
                    try fileManager.removeItem(atPath: string!)
//                    self.list()
                } else {
                    print("File does not exist")
                }
                
            }
            catch let error as NSError {
                print("An error took place: \(error)")
            }
            
            
        }        

        alertView.showSuccess("Choose", subTitle: "What you want this file?", closeButtonTitle: "Cancel")        
        
    }
    
//    func clearTempFolder() {
//        let fileManager = FileManager.default
//        let tempFolderPath = NSTemporaryDirectory()
//        
//        do {
//            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
//            for filePath in filePaths {
//                try fileManager.removeItem(atPath: NSTemporaryDirectory() + filePath)
//            }
//        } catch let error as NSError {
//            print("Could not clear temp folder: \(error.debugDescription)")
//        }
//    }
    


}
