//
//  PostDetailViewController.swift
//  uprm1
//
//  Created by Javier Bustillo on 8/17/17.
//  Copyright © 2017 Javier Bustillo. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postText: UILabel!
    var comments: [PFObject]!
    var posts: [PFObject]!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        let post = posts![index!]
        postText.text = post["post"] as? String
        
        refreshData()
        
        
        

    }
    override func viewDidAppear(_ animated: Bool) {
        refreshData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let comments = comments{
            return comments.count
        }
        else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as! CommentCell
        
        cell.comments = comments![indexPath.row]
        cell.selectionStyle = .none
        cell.upVote.tag = indexPath.row
        cell.downVote.tag = indexPath.row
        
        return cell
        
    }

    func refreshData(){
       
        let post = posts![index!]

        let query = PFQuery(className: "Comment")
        query.order(byDescending: "createdAt")
        
        query.limit = 20
        query.whereKey("originalID", equalTo: post.objectId!)
        
        query.findObjectsInBackground { (comments: [PFObject]?, error: Error?) in
            if let comments = comments{
                self.comments = comments
                self.tableView.reloadData()
                print("woo")
            } else {
                // handle error
                print("error")
                
            }
        }
    }
    
    @IBAction func upVote(_ sender: UIButton) {
        let upVoters = self.comments[sender.tag]["upVoters"] as! [String]
        let downVoters = self.comments[sender.tag]["downVoters"] as! [String]
        let userName = PFUser.current()?.username
        if(upVoters.contains(userName!)){
            self.comments[sender.tag].remove(userName!, forKey: "upVoters")
            self.comments[sender.tag].incrementKey("steps", byAmount: -1)
            self.comments[sender.tag].saveInBackground()
            print("unUpvoted")
            
        }else if(!upVoters.contains(userName!) && !downVoters.contains(userName!)) {
            self.comments[sender.tag].add(userName!, forKey: "upVoters")
            self.comments[sender.tag].incrementKey("steps")
            self.comments[sender.tag].saveInBackground()
            print("upvoted")
        }else if(downVoters.contains(userName!)){
            self.comments[sender.tag].remove(userName!, forKey: "downVoters")
            self.comments[sender.tag].add(userName!, forKey: "upVoters")
            self.comments[sender.tag].incrementKey("steps", byAmount: 2)
            self.comments[sender.tag].saveInBackground()
            
        }
    }

    @IBAction func downVote(_ sender: UIButton) {
        let upVoters = self.comments[sender.tag]["upVoters"] as! [String]
        let downVoters = self.comments[sender.tag]["downVoters"] as! [String]
        let userName = PFUser.current()?.username
        if(downVoters.contains(userName!)){
            self.comments[sender.tag].remove(userName!, forKey: "downVoters")
            self.comments[sender.tag].incrementKey("steps")
            self.comments[sender.tag].saveInBackground()
            print("unUpvoted")
            
        }else if(!downVoters.contains(userName!) && !upVoters.contains(userName!)) {
            self.comments[sender.tag].add(userName!, forKey: "downVoters")
            self.comments[sender.tag].incrementKey("steps", byAmount: -1)
            self.comments[sender.tag].saveInBackground()
            print("upvoted")
        }else if(upVoters.contains(userName!)){
            self.comments[sender.tag].remove(userName!, forKey: "upVoters")
            self.comments[sender.tag].add(userName!, forKey: "downVoters")
            self.comments[sender.tag].incrementKey("steps", byAmount: -2)
            self.comments[sender.tag].saveInBackground()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueToCommenter"
            {
                let post = posts![index!]
                print(1)

                let originalID = post.objectId
                let commenterVC = segue.destination as! CommenterViewController
                
                commenterVC.originalID = originalID!
                
            }
        }

    }
    


