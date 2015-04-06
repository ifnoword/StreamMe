//
//  ShowEventViewController.m
//  StreamMe
//
//  Created by MEI C on 4/23/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "ShowEventViewController.h"

@interface ShowEventViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *phtoView;
@property (weak, nonatomic) IBOutlet UINavigationItem *head;

@end

#define MAXNUM_OF_CMT_PER_LOAD 10


@implementation ShowEventViewController

- (IBAction)getCommentBtnPressed:(id)sender {
    [self.tabBarController setSelectedIndex:1];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self.event.deathtime compare:[NSDate date]]== NSOrderedAscending || !self.event){
        //[self alertWithMsg:@"Unavaible Feed!"];
        self.view.userInteractionEnabled = NO;
    }
    else{
        self.view.userInteractionEnabled = YES;
    }
    
}


-(void)viewWillAppear:(BOOL)animated{

    self.getCommentsBtn.hidden = self.fromCommentView;
    
    NSLog(@"Show Event: %@",self.event.eventid);
    [self.event loadPhoto];
    [self.event fetchUsername];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSLog(@"%@",[NSTimeZone systemTimeZone]);
    
    self.head.title = self.event.title;
    self.usernameLabel.text = self.event.creator;
    self.timeLabel.text = [formatter stringFromDate:self.event.birthtime];
    self.addrLabel.text = self.event.address;
    self.textView.text = self.event.text;
    self.phtoView.image = self.event.image;
    
    [[NSUserDefaults standardUserDefaults] setObject:self.event.eventid forKey:@"UserCurrentEventId"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void) alertWithMsg:(NSString*) alertMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
