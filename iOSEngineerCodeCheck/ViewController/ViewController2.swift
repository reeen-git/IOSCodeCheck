//
//  ViewController2.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    
    @IBOutlet weak var ImgView: UIImageView!
    @IBOutlet weak var TtlLbl: UILabel!
    @IBOutlet weak var LangLbl: UILabel!
    @IBOutlet weak var StrsLbl: UILabel!
    @IBOutlet weak var WchsLbl: UILabel!
    @IBOutlet weak var FrksLbl: UILabel!
    @IBOutlet weak var IsssLbl: UILabel!
    
    private var repository: Repository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setTexts()
        getImage()
    }
    
    func setTexts() {
        guard let repository else { return }
        LangLbl.text = "Written in \(repository.language ?? "")"
        StrsLbl.text = "\(repository.stargazersCount) stars"
        WchsLbl.text = "\(repository.watchersCount) watchers"
        FrksLbl.text = "\(repository.forksCount) forks"
        IsssLbl.text = "\(repository.openIssuesCount) open issues"
    }
    
    func getImage(){
        TtlLbl.text = repository?.fullName
        if let imgURL = repository?.avatarImageUrl {
            URLSession.shared.dataTask(with: imgURL) { (data, res, err) in
                let img = UIImage(data: data!)!
                DispatchQueue.main.async {
                    self.ImgView.image = img
                }
            }.resume()
        }
    }
}
