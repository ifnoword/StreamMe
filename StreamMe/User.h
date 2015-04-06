//
//  User.h
//  StreamMe
//
//  Created by Zhang, Xinmei on 4/3/14.
//  Copyright (c) 2014 StreamMeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject
@property (strong,nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *username;//nickname for login
@property (strong, nonatomic) NSString *email; //for log in
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) UIImage *avatar; ///profile picture


//Encode password with SHA1;
-(instancetype) initWithCurrentUser;
-(UIImage *) loadAvatar;
+(NSString *) encodePassword:(NSString *)pwdString;

+(NSError *) logInWithUsername:(NSString *)username andPassword:(NSString *)pwdString;

+(void)logOut;

+(BOOL) isLoggedIn;

+(NSError *) signUpWithEmail:(NSString *)email
                 andPassword:(NSString *)pwdString
                 andUsername:(NSString *)nickname
                  andZipcode:(NSString *)zip
                   andAvatar:(UIImage *)photo;

+(NSError *) updateProfileWithEmail:(NSString *)emailString andZipcode:(NSString *)zipcodeString andImage:(UIImage *)profileImage;
@end
