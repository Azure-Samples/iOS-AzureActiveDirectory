//
//  Constants.h
//  WAAD-Test
//
//  Created by Chris Risner on 9/11/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

#define WAAD_LOGIN_URL @"https://login.windows.net/"
#define WAAD_DOMAIN @"christesttwo.onmicrosoft.com"
#define WAAD_CLIENT_ID @"fa94de18-3636-447e-8986-99db18aeac85"
#define WAAD_REDIRECT_URI @"com.cmr.waadtest://authorize"
#define WAAD_RESOURCE @"http://win8webapp.azurewebsites.net/"
#define WAAD_SERVICE_ENDPOINT @"api/todolist"

typedef void (^CompletionBlock) ();
typedef void (^CompletionBlockWithString) (NSString *string);

@end
