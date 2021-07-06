//
//  ChatViewController.m
//  ParseChat
//
//  Created by Elizabeth Ke on 7/6/21.
//

#import "ChatViewController.h"
#import "Parse/Parse.h"
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *messages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:true];
    [self onTimer];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.messages = [NSArray new];
}

- (IBAction)sendMessage:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];
    chatMessage[@"text"] = self.messageTextField.text;
    chatMessage[@"user"] = PFUser.currentUser;
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            [self.messageTextField setText:@""];
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChatCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ChatCell"];
    
    PFObject *message = self.messages[indexPath.row];
    cell.messageLabel.text = message[@"text"];
    
    PFUser *user = message[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.userLabel.text = user.username;
    } else {
        // No user found, set default username
        cell.userLabel.text = @"🤖";
    }
    return cell;
    
    
}

- (void)onTimer {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
    [query includeKey:@"user"];
    [query orderByDescending:@"createdAt"];

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.messages = posts;
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    

}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
