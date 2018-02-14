//
//  FirstViewViewController.swift
//  YtDownloader
//
//  Created by Emir Beytekin on 5.01.2017.
//  Copyright © 2017 Emir Beytekin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import Kingfisher
import SCLAlertView
import GoogleMobileAds
import MediaPlayer
import AVKit
import AVFoundation
import SQLite

class FirstViewController: UIViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var urlText: UTextField!
    var objects = [VideoDetail]()
    var isClickable:Bool = true
    var videoTitle = ""
    var videoURL:String = ""
    var videoFileName: String = ""
    var videoFilePath: String = ""
    var videoExt = ""
    @IBOutlet weak var myLoader: UIProgressView!
    @IBOutlet weak var loadingTxt: UILabel!
    
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var videoPlace: UIView!
    @IBOutlet weak var videoName: UILabel!
    @IBOutlet weak var videoThumb: UIImageView!
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var saveLabel: UILabel!
    var isAccess:Bool = false
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    // hello db
    
    let myDownloadedFiles = Table("myDownloadedFiles")
    let did = Expression<Int64>("id")
    let dFileName = Expression<String?>("dFileName")
    let dFilePath = Expression<String>("dFilePath")
    var dbWay:String! = ""

    
    func dbCreate() { // veritabanını oluşturur
        let part1DbPath = self.dbWay!
        
        var db: OpaquePointer? = nil
        if sqlite3_open(part1DbPath, &db) == SQLITE_OK {
            print("Successfully opened connection to database at \(part1DbPath)")
            self.createTables()
        } else {
            print("Unable to open database. Verify that you created the directory described " +
                "in the Getting Started section.")
        }
    }
    
    func createTables() { // tabloları
        do {
            let db = try Connection(self.dbWay!)
            try db.run(myDownloadedFiles.create { t in
                t.column(did, primaryKey: true)
                t.column(dFileName)
                t.column(dFilePath)
            })
            
        } catch {
            print("bir hata oluştu, amanın!")
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        self.dbWay = paths[0] + "/db.sqlite3"
        self.dbCreate()
        self.lastRecords()
        self.saveLabel.text = "is Valid URL!"
        self.firstCheck()
        self.makeStyle()
        self.title = "Download File"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(FirstViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        myLoader.transform = myLoader.transform.scaledBy(x: 1, y: 30)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeStyle() {
        self.urlText.textField.text = ""
        myLoader.progress = 0
        myLoader.alpha = 0
        downloadButton.layer.cornerRadius = 5
        downloadButton.layer.borderWidth = 2
        downloadButton.layer.borderColor = UIColor.white.cgColor
        
        NVActivityIndicatorView.DEFAULT_TYPE = .ballScaleMultiple
        videoPlace.alpha = 0
        videoName.alpha = 0
        videoThumb.alpha = 0
        self.downloadButton.isEnabled = false
        
        videoThumb?.layer.cornerRadius = (videoThumb?.frame.size.height)!/2
        videoThumb?.layer.masksToBounds = true
        videoThumb?.layer.borderColor = UIColor.uBlackColor().cgColor
        videoThumb?.layer.borderWidth = 2

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        
        if(urlText.textField.text == "" || urlText.textField.text == nil) {
            SCLAlertView().showError("Error", subTitle: "URL is empty?")
        } else {
            
            self.getData()
            
            
        }
    }
    
    func firstCheck() {
        
        let urlString: String = "\(BASE_URL)/first.php"
        
        Alamofire.request(urlString).responseJSON { response in
            
            self.stopAnimating()
            
            let x = response.response?.statusCode
            
            
            if (x == 500) {
                
                let alert = UIAlertController(title: "Error", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        
                        print("asdadas")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            switch response.result {
            case .success(let value):
                
                let resp = JSON(value)
                
                print(resp)
                
                self.isAccess = resp["data"].boolValue
                
            case .failure(let error):
                print(error)
                self.isAccess = false
            }
        }
        
    }
    
    func getData() {
        
        myLoader.progress = 0
        
        self.loadingTxt.text = ""
        
        self.objects.removeAll()
        
        self.dismissKeyboard()
        
        let size = CGSize(width: 30, height:30)
        
        startAnimating(size, message:"Please Wait..")
      
        let urlString: String = "\(BASE_URL)/down.php?url=\(urlText.textField.text!)"

        Alamofire.request(urlString).responseJSON { response in

            self.stopAnimating()
            
            self.firstCheck()
            
            let x = response.response?.statusCode
            
            
            if (x == 500) {
                
                let alert = UIAlertController(title: "Error", message: "Connection Error", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        
                        print("asdadas")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            switch response.result {
            case .success(let value):
                
                let resp = JSON(value)
                
                print(resp)
                
                if(resp["data"]["status"].bool == false) {
                    let message = resp["data"]["message"].string!
                    SCLAlertView().showError("Wrong!", subTitle: message)
                    return
                }
                
                if(resp["data"].count != 0) {
                    
                    self.videoPlace.alpha = 0.6
                    self.videoName.alpha = 1.0
                    self.videoThumb.alpha = 1.0
                    
                    let address = VideoDetail()
                    
                    let x = resp["data"]["name"].string
                    let y = resp["data"]["thumb"].string
                    self.videoURL = resp["data"]["fileUrl"].string!
                    self.videoExt = resp["data"]["ext"].string ?? "mp4"
                    
                    self.videoFileName = "yallah.mp4"//"\(x!).mp4"
                    
                    if (x != nil) {
                        address.baslik = x
                        self.videoName.text = address.baslik
                        self.videoTitle = address.baslik!
                        self.isClickable = true
                        self.downloadButton.isEnabled = true
                    } else {
                        address.baslik = "Sorry, video is not found :("
                        self.videoName.text = address.baslik
                        self.isClickable = false
                        self.downloadButton.isEnabled = false
                    }
                    
                    
                    if (y != nil) {
                        address.thumb = y
                        let url = URL(string: address.thumb!)
                        self.isClickable = true
                        self.videoThumb.kf.setImage(with: url)
                        self.downloadButton.isEnabled = true
                    } else {
                        address.thumb = "http://www.51allout.co.uk/wp-content/uploads/2012/02/Image-not-found.gif"
                        let url = URL(string: address.thumb!)
                        self.isClickable = true
                        self.videoThumb.alpha = 0.3
                        self.videoThumb.kf.setImage(with: url)
                        self.downloadButton.isEnabled = true
                        
                    }
                    
                } else {
                    print("obje yok")
                }
                

                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func insertRecord(fName:String? = "", fPath:String = "") {
        print(fPath)
        
        do {
            let db = try Connection(self.dbWay!)
            let insert = myDownloadedFiles.insert(dFileName <- fName!, dFilePath <- fPath)
            let rowid = try db.run(insert)
            print("kayıt id \(rowid)")
        } catch {
            print("kayıt eklenemedi")
        }
    }
    

    @IBAction func downAction2(_ sender: Any) {
        
        if (isClickable == true && isAccess == true) {
            self.saveLabel.text = "is Valid URL!"
            let alertView = SCLAlertView()
            alertView.addButton("Yes!", target:self, selector:#selector(FirstViewController.downloadFB as (FirstViewController) -> () -> ()))

            alertView.showSuccess("Shortcut Process", subTitle: "Are you ready to make shortcut?", closeButtonTitle: "NO")
            
        }
        
    }
    
    func randomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func downloadFB() {
        
        getBanner()
        
        let alertView = SCLAlertView()
//
        
        let destination: (URL, HTTPURLResponse) -> (URL, DownloadRequest.DownloadOptions) = {
            (temporaryURL, response) in
            
            if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let suggestedFilename = response.suggestedFilename {
                
                let filePath = directoryURL.appendingPathComponent("\(self.randomInt(min: 1, max: 9999)).\(self.videoExt)")
                
                self.videoFilePath = filePath.path
                self.insertRecord(fName: self.videoTitle, fPath: self.videoFilePath)
                
                return (filePath, [.removePreviousFile])
            }
            return (temporaryURL, [.removePreviousFile, .createIntermediateDirectories])
            
        }
        
        var resumeData: Data?
        
        let request: DownloadRequest
        
        if let resumeData = resumeData {
            
            request = Alamofire.download(resumingWith: resumeData).downloadProgress(closure: { (progress) in
                print(progress.fractionCompleted)
                
            })
        
        } else {
            request = Alamofire.download(
                self.videoURL as String!,method: .get,parameters: nil,encoding: JSONEncoding.default,headers: nil,to: destination).downloadProgress(closure: { (progress) in
                    self.myLoader.alpha = 1.0
                    self.myLoader.progress = Float(progress.fractionCompleted)
                    
                    let fullName = String(progress.fractionCompleted)
                    let fullNameArr = fullName.components(separatedBy: ".")
                    let firstName: String = fullNameArr[1]
                    
                    if (Float(progress.fractionCompleted) != 1.0) {
                        let index1 = firstName.index(firstName.startIndex, offsetBy: 2)
                    
                        let substring1 = firstName.substring(to: index1)
                    
                    self.loadingTxt.text = "% \(substring1)"
                    }
                    
                    
                    if (Float(progress.fractionCompleted) == 1.0) {
                        self.loadingTxt.text = "%100"
                        alertView.showSuccess("Shortcut created.", subTitle: "Is this amazing??", closeButtonTitle: "YES")
                        self.tabBarController?.tabBar.items?[1].badgeValue = "1"
                        
                    }
                    
                }).response(completionHandler: { (DefaultDownloadResponse) in
                    //here you able to access the DefaultDownloadResponse
//                    print(DefaultDownloadResponse)
                    //result closure
                })

        }

    }
    
    func getBanner() {
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-5742871402454995/8567220244"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
    }
    
    func lastRecords() {
        do {
            let db = try Connection(Utils.getDbWay())
            let sqlCommand = "SELECT * FROM myDownloadedFiles"
            for row in try db.prepare(sqlCommand) {
                print("id: \(row[0]), name: \(row[1]), filePath: \(row[2])")
            }
        } catch {
            
        }
        
    }

}


