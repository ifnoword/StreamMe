//
//  SignUpViewController.m
//  StreamMe
//
//  Created by Andros, Braden R on 4/5/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "SignUpViewController.h"
#import "User.h"
@interface SignUpViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordComfirmField;
@property (weak, nonatomic) IBOutlet UITextField *zipTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic) NSMutableArray *capturedImages;

@end

@implementation SignUpViewController

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)tapView:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
}
- (IBAction)submitBtnPressed:(id)sender {
    if ([self.passwordTextField.text isEqualToString:self.passwordComfirmField.text]) {
            NSString *emailstr = self.emailAddressTextField.text;
            NSString *pwdstr = self.passwordTextField.text;
            NSString *usrnmstr = self.usernameTextField.text;
            NSString *zpstr = self.zipTextField.text;
        
            NSError *err = [User signUpWithEmail:emailstr andPassword:pwdstr andUsername:   usrnmstr andZipcode:zpstr andAvatar:self.profileImage.image];
            //NSError *err = [User signUpWithEmail:@"mei@tect.com" andPassword:@"123456" andUsername:@"mei" andZipcode:@"52240" andAvatar:NULL];
            if (!err)
                [self performSegueWithIdentifier:@"trySignUp" sender:self];
            else
                [self alertWithMsg:[err userInfo][@"error"]];

    }
    else
        [self alertWithMsg:@"Different Passwords"];
    
}
- (void) alertWithMsg:(NSString*) alertMsg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:alertMsg delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
    [alert show];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)chooseImagePressed:(id)sender {

    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.profileImage.image = image;
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
