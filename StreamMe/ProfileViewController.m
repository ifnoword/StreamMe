//
//  ProfileViewController.m
//  StreamMe
//
//  Created by MEI C on 4/7/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
@interface ProfileViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeField;
@property (weak, nonatomic) IBOutlet UIButton *photoUploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong,nonatomic) User *currentUser;

@end

@implementation ProfileViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)logoutBtnPressed:(id)sender {
    [User logOut];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserCurrentEventId"];
    [self performSegueWithIdentifier:@"tryLogOut" sender:self];
    
}

-(void) viewWillAppear:(BOOL)animated {
    self.currentUser = [[User alloc] initWithCurrentUser];
    [self.nameField setEnabled:NO];
    self.nameField.text = self.currentUser.username;
    self.emailField.text = self.currentUser.email;
    self.zipcodeField.text = self.currentUser.zipcode;
    self.photoView.image = [self.currentUser loadAvatar];
    if (!self.photoView.image) {
        self.photoView.image = [UIImage imageNamed:@"default_head"];
    }
    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
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
- (IBAction)restoreBtnPressed:(id)sender {
    [self.nameField setEnabled:NO];
    self.nameField.text = self.currentUser.username;
    self.emailField.text = self.currentUser.email;
    self.zipcodeField.text = self.currentUser.zipcode;
    self.photoView.image = [self.currentUser loadAvatar];
}
- (IBAction)submitBtnPressed:(id)sender {
    NSString *emailstr = self.emailField.text;
    NSString *zpstr = self.zipcodeField.text;
    
    NSError *error=[User updateProfileWithEmail:emailstr andZipcode:zpstr andImage:self.photoView.image];
    if (error)
    {
        [self alertWithTitle:@"Oops!" andMsg:[error userInfo][@"error"]];
    }
    else {
        self.currentUser.email = self.emailField.text;
        self.currentUser.zipcode = self.zipcodeField.text;
        self.currentUser.avatar  = self.photoView.image;
        [self alertWithTitle:@"Done!" andMsg:@"Profile Updated!"];
        
    }

}
- (void) alertWithTitle:(NSString *)title andMsg:(NSString*)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
- (IBAction)tapView:(id)sender {
        [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)uploadPhotoPressed:(id)sender {
    
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.photoView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
