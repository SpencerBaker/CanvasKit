//
//  CKLocalUser+Networking.m
//  CanvasKit
//
//  Created by rroberts on 9/13/13.
//  Copyright (c) 2013 Instructure. All rights reserved.
//

#import "CKLocalUser+Networking.h"
#import "CKClient.h"
#import "Constants.h"
#import "CKLoginViewController.h"

@implementation CKLocalUser (Networking)

- (void)fetchAttributesWithsuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure
{
    NSString *path = [[self path] stringByAppendingPathComponent:@"profile"];
    
    [[CKClient sharedClient] GET:path parameters:0 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        CKLocalUser *user = [MTLJSONAdapter modelOfClass:[CKLocalUser class] fromJSONDictionary:responseObject error:nil];
        [[CKLocalUser sharedUser] mergeValuesForKeysFromModel:user];
        
        if (success)
            success();
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)performLoginWithSuccess:(void(^)(void))success failure:(void(^)(NSError *error))failure
{
    CKClient *sharedClient = [CKClient sharedClient];
    
    if (! sharedClient.clientId || ! sharedClient.sharedSecret) {
        failure([NSError errorWithDomain:kCKErrorDomain code:kCKErrorCodeNotPreparedForOAuth userInfo:@{NSLocalizedDescriptionKey: @"Client ID and shared secret must be set prior to authentication. See CanvasKit.h prepare methods."}]);
        return;
    }
    
    CKLoginViewController *loginViewController = [[CKLoginViewController alloc] initWithSuccess:^{
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:loginViewController action:@selector(cancelOAuth)];
    [loginViewController.navigationItem setRightBarButtonItem:button];
    
    UIViewController *presentingViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    [presentingViewController presentViewController:navigationController animated:YES completion:nil];
    
}

@end
