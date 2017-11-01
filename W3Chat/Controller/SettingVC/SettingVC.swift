//
//  SettingVC.swift
//  W3Chat
//
//  Created by ios2 on 10/24/17.
//  Copyright © 2017 Aryan-dev. All rights reserved.
//

import UIKit

class SettingVC: UIViewController , UITableViewDelegate ,UITableViewDataSource  {

    @IBOutlet var Setting_Table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Settings"
        
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(named: "sidemenu"), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 10  , height: 10)
        btn1.addTarget(self, action: #selector((SSASideMenu.presentLeftMenuViewController)), for: .touchUpInside)
        
        let item1 = UIBarButtonItem(customView: btn1 )
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)
        
        
        Setting_Table.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        Setting_Table.delegate   = self
        Setting_Table.dataSource = self
        Setting_Table.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource
     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PUSH NOTIFICATIONS"
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
        
        
        
        return cell
    }
    /*** cell is tapped ***/
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
       
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
