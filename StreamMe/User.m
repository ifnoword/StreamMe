//
//  User.m
//  StreamMe
//
//  Created by Zhang, Xinmei on 4/3/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import "User.h"
#import <CommonCrypto/CommonDigest.h>
#import <Parse/Parse.h>

@interface User()
@property (strong,nonatomic) PFUser *userObj;
//@property (strong, nonatomic,readwrite) NSString *email;
@end
#define PHOTO_MAX_SIZE 1 //max iamge size 1 m
@implementation User

+(NSString *) encodePassword:(NSString *)pwdString{
    const char *cstr = [pwdString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:pwdString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

//initialize a User object with current user's data.
//Check if userId is Nil before using
//OR use isLoggedIn to check if current user exist.
-(instancetype) initWithCurrentUser{
    self = [super init];
    self.userObj = [PFUser currentUser];
    if(self.userObj){
        self.userId = self.userObj.objectId;
        self.username = self.userObj.username;
        self.email = self.userObj.email;
        self.zipcode = self.userObj[@"zipcode"];
    }
    return self;
}
-(UIImage *) loadAvatar{
    UIImage *image;
    PFFile *userImageFile = self.userObj[@"avatar"];
    NSData *imageData = [userImageFile getData];
    if (imageData) {
        image = [UIImage imageWithData:imageData];
    }
    
    self.avatar = image;
    return image;
}
+(BOOL) isLoggedIn{
    if ([PFUser currentUser]) {
        return YES;
    }
    else return NO;
}

+(NSError *) logInWithUsername:(NSString *)username andPassword:(NSString *)pwdString{
    NSError *error;
    //send query to Parse to verify account;
    
    [PFUser logInWithUsername:username password:[self encodePassword:pwdString ] error:&error];
    
    //Fail, return NO
    return error;
}

+(void) logOut{
    [PFUser logOut];
    
}
+(NSError *) signUpWithEmail:(NSString *)email
                 andPassword:(NSString *)pwdString
                 andUsername:(NSString *)nickname
                  andZipcode:(NSString *)zip
                   andAvatar:(UIImage *)photo{
    NSError *error;
    
    PFUser *newuser = [PFUser user];
    //Set built-in properties
    newuser.username = nickname;
    newuser.email = email;
    newuser.password = [self encodePassword:pwdString];
    
    //Set customized properties;
    newuser[@"zipcode"] = zip;
    
    //For an image, creat a PFFile and save it separatly;
    //Then plug it in to User
    if (photo) {
        NSData *imagedata = UIImagePNGRepresentation(photo);
        
        PFFile *imgfile = [PFFile fileWithData:imagedata];
        [imgfile saveInBackground];
        newuser[@"avatar"] = imgfile;
    
    }
    [newuser signUp:&error];
    return error;
}

+(NSError *) updateProfileWithEmail:(NSString *)emailString andZipcode:(NSString *)zipcodeString andImage:(UIImage *)profileImage{
    
    PFUser *updateUser = [PFUser currentUser];
    
    updateUser.email = emailString;
    updateUser[@"zipcode"] = zipcodeString;
    
    if (profileImage) {
        NSData *imagedata = UIImagePNGRepresentation(profileImage);
        PFFile *imgfile = [PFFile fileWithData:imagedata];
        [imgfile saveInBackground];
        updateUser[@"avatar"] = imgfile;
    }
    
    NSError *error;
    [updateUser save:&error];
    return error;
    
}
@end
