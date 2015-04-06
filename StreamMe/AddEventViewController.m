//
//  AddEventViewController.m
//  StreamMe
//
//  Created by MEI C on 4/17/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "AddEventViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface AddEventViewController ()<UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *addrField;
@property (weak, nonatomic) IBOutlet UITextField *durationField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;


@end

@implementation AddEventViewController

- (IBAction)viewTapped:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
-(void)viewWillAppear:(BOOL)animated{
    //Style the textview to be like textField
    NSLog(@"======%@",self.currentLocation);
    [self.descriptionField.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.2] CGColor]];
    [self.descriptionField.layer setBorderWidth:1.0];
    self.descriptionField.layer.cornerRadius = 5;
    self.descriptionField.clipsToBounds = YES;
    
    //reverse locatio to address and fill the location field
    GMSGeocoder *geocoder = [[GMSGeocoder alloc] init];
    [geocoder reverseGeocodeCoordinate:self.currentLocation.coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        if([response firstResult]){
            GMSAddress *addr = [response firstResult];
            if (addr.thoroughfare) {
                self.addrField.text = [[NSString alloc] initWithFormat:@"At %@",addr.thoroughfare];
            }
            else {
                NSString *addrLines = @"At ";
                for (NSString *line in addr.lines) {
                    [addrLines stringByAppendingString:line];
                }
                self.addrField.text = addrLines;
            }
        }
    }];
    
}
- (IBAction)createBtnPressed {
    // 0.0001~0.0000 01
    NSLog(@"===current:%@",self.currentLocation);
    
    //Shift the event location a little bit to avoid overlap.
    CLLocation *eventlocation;
    if ([self randomVar]>0.5) {
        CGFloat newLat = self.currentLocation.coordinate.latitude + [self randomVar]*0.0000001;
        eventlocation = [[CLLocation alloc]initWithLatitude:newLat  longitude:self.currentLocation.coordinate.longitude];
        NSLog(@"===shift on LAT:%@",eventlocation);
    }
    else{
        CGFloat newLong = self.currentLocation.coordinate.longitude + [self randomVar]*0.0000001;
        eventlocation = [[CLLocation alloc]initWithLatitude:self.currentLocation.coordinate.latitude longitude:newLong];
        NSLog(@"===shift on LONG:%@",eventlocation);
    }
    
    //check duration
    if ([self.durationField.text floatValue] <= 0.0f) {
        [self alertWithTitle:@"Oops!" andMsg:@"Duration time should > 0 and < 24!"];
    }
    else{
        Event *newEvent = [[Event alloc]initWithTitle:self.titleField.text text:self.descriptionField.text image:self.photoView.image location:eventlocation address:self.addrField.text andDuration:[self.durationField.text floatValue]];
        NSError *error = [newEvent save];
        if (error) {
            [self alertWithTitle:@"Oops!" andMsg:[error userInfo][@"error"]];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(CGFloat)randomVar{
    int N = 101;
    return (CGFloat)arc4random_uniform(N)/(N-1);
    
}

- (IBAction)addPhotoPressed {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.photoView.image = image;
    
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Describe your event";
        textView.textColor = [UIColor groupTableViewBackgroundColor];
    }
    [textView resignFirstResponder];
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"Describe your event"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void) alertWithTitle:(NSString *)title andMsg:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
