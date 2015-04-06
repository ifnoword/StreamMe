//
//  CommentViewController.m
//  StreamMe
//
//  Created by MEI C on 4/23/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (strong,nonatomic) NSMutableArray *commentArray;
@property (strong,nonatomic) Event *event;
@end

#define MAXNUM_OF_CMT_PER_LOAD 10

@implementation CommentViewController
-(NSMutableArray *) commentArray{
    if (!_commentArray) {
        _commentArray = [[NSMutableArray alloc]init];
    }
    return _commentArray;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cellNum = indexPath.row;
    if (cellNum == 0) {
        return 34.0f;
    }
    else {
        return 85.0f;
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"Get %d comments",self.commentArray.count);
    return self.commentArray.count+1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger cellnum = indexPath.row;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d HH:mm"];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    if(cellnum == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadCommentCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoadCommentCell"];
        }
        return cell;
    }
    else{
        CommentCell *cell = (CommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
        if (cell == nil){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        Message *comment = [self.commentArray objectAtIndex:cellnum-1];
        cell.usernamelabel.text = comment.creator;
        cell.textView.text = comment.text;
        cell.timelabel.text = [formatter stringFromDate:comment.birthtime];
        cell.photoView.image = comment.avatar;
        if (!cell.photoView.image) {
            cell.photoView.image = [UIImage imageNamed:@"default_head"];
        }
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Table Cell selection INVoked!");
    if (indexPath.row == 0){
        
        [self performSelector:@selector(loadmore)];
    }
}

-(void) loadmore{
    NSInteger count = self.commentArray.count;
    ;
    NSArray *newLoad = [[NSArray alloc]initWithArray:[self.event getLatestCommentsOfNum:MAXNUM_OF_CMT_PER_LOAD andSkip:count]];
    if (newLoad.count == 0){
        [self alertWithTitle:@"Oops!" andMsg:@"No More Comments"];
    }
    else{
        NSMutableArray *insertIndexPaths = [NSMutableArray arrayWithCapacity:MAXNUM_OF_CMT_PER_LOAD];
        for (int ind = 0; ind < [newLoad count]; ind++)
        {
            NSIndexPath *newPath =  [NSIndexPath indexPathForRow:1+ind inSection:0];
            [insertIndexPaths addObject:newPath];
            [self.commentArray insertObject:[newLoad objectAtIndex:ind]  atIndex:ind];
        }
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        ShowEventViewController *childVC = segue.destinationViewController;
        childVC.event = self.event;
        childVC.fromCommentView = YES;
    }
    
}

- (IBAction)sendBtnPressed:(id)sender {
    if ([self.inputField.text isEqualToString:@""]) {
        [self alertWithTitle:@"Oops!" andMsg:@"Empty Comment Message!"];
    }
    else{
        NSError *error = [self.event makeCommentWithText:self.inputField.text andRecipient:@""];
        if (!error) {
            self.inputField.text = @"";
            [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
            if (self.commentArray.count > 0){
                [self.commentArray removeAllObjects];
            }
            [self.commentArray addObjectsFromArray:[self.event getLatestCommentsOfNum:MAXNUM_OF_CMT_PER_LOAD andSkip:0]];
            
            [self.tableView reloadData];
            
        }
        else
            [self alertWithTitle:@"Opps!" andMsg:[error userInfo][@"error"]];
    }
    

}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}
- (IBAction)touchTextFieldOutside:(id)sender {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void) alertWithTitle:(NSString *)title andMsg:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
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
    //NSLog(@"RECIPIENT %@",self.recipient);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    if (self.commentArray.count > 0){
        [self.commentArray removeAllObjects];
    }
    NSString *eventid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserCurrentEventId"];
    if (eventid.length > 0) {
            self.event = [[Event alloc]initWithId:eventid];
    }
    if (self.event) {
        [self.commentArray addObjectsFromArray:[self.event getLatestCommentsOfNum:MAXNUM_OF_CMT_PER_LOAD andSkip:0]];
    }
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    if ([self.event.deathtime compare:[NSDate date]]== NSOrderedAscending || !self.event){
        //[self alertWithTitle:@"Oops!" andMsg:@"Feed Unavaible!"];
        self.view.userInteractionEnabled = NO;
     }
    else{
        self.view.userInteractionEnabled = YES;
    
    }
}


@end
