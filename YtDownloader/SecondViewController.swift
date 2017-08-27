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

class SecondViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var objects = [MyVideo]()
    
    var refreshControl = UIRefreshControl()
    
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
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            
            let directoryContents = try FileManager.default.contentsOfDirectory( at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            
            print(directoryContents)
//            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp4" }
//            print("mp4 urls:",mp3Files)
            var i = 0;
            
            for datas in directoryContents {
                i += 1;
                let list = MyVideo()
                list.videoTitle = "\(i) - \(datas)"
                list.videoURL = "\(datas)"
                self.objects.append(list)
                
            }
            
            if self.refreshControl.isRefreshing
            {
                self.refreshControl.endRefreshing()
            }

            
            self.tableView.reloadData()

            
        } catch let error as NSError {
            print(error.localizedDescription)
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
        
//        cell?.videoNameLabel.text = a.videoTitle
        cell?.videoNameLabel.text = " \(indexPath.row + 1) - My Video"

        
        self.tableView?.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView?.tableFooterView?.isHidden = true
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let a = objects[indexPath.row] as MyVideo
        
        print(a.videoURL)
        
        let string = a.videoURL?.replacingOccurrences(of: "file:///private", with: "")
        
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
                let fileManager = FileManager.default
                
                // Check if file exists
                if fileManager.fileExists(atPath: string!) {
                    // Delete file
                    try fileManager.removeItem(atPath: string!)
                    self.list()
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
