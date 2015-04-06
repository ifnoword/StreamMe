//
//  LoginViewController.m
//  StreamMe
//
//  Created by Andros, Braden R on 4/5/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)enterPressed:(id)sender;


@end

@implementation LoginViewController

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)logInBtnPressed:(id)sender {
    NSString *namestr = self.usernameTextField.text;
    NSString *pwdstr = self.passwordTextField.text;
    
    NSError *err = [User logInWithUsername:namestr andPassword:pwdstr];
    if(!err){
        [self performSegueWithIdentifier:@"tryLogIn" sender:self];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[err userInfo][@"error"] delegate:self cancelButtonTitle:@"Try Again" otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)viewtTapped:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)enterPressed:(id)sender {
    
}
@end
