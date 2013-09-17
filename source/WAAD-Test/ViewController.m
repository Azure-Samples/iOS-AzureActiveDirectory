//
//  ViewController.m
//  WAAD-Test
//
//  Created by Chris Risner on 9/10/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import "URLParser.h"
#import "NSDictionary+Extensions.h"
#import "NSData+Base64.h"


@interface ViewController ()

@property (strong, nonatomic) NSString *authCode;
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *expiresIn;
@property (strong, nonatomic) NSString *expiresOn;
@property (strong, nonatomic) NSString *idToken;
@property (strong, nonatomic) NSString *refreshToken;
@property (strong, nonatomic) NSString *userImpersonation;
@property (strong, nonatomic) NSString *resource;
@property (strong, nonatomic) NSString *scope;
@property (strong, nonatomic) NSString *tokenType;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tappedAuthenticate:(id)sender {
    
    WebViewController *webVC = [[WebViewController alloc] initWithCompletion:^(NSString *result) {
        NSLog(@"Result: %@", result);
        self.lblInfo.text = result;
        
        //Pull the code paramter out of the query string
        URLParser *parser = [[URLParser alloc] initWithURLString:result];
        self.authCode = [parser valueForVariable:@"code"];
        
        //Provided we received a code, change the UI to enable
        //fetching a token
        if (![self.authCode isEqualToString:@""]) {
            self.lblInfo.text = self.authCode;
            self.lblUser.text = @"Fetch & decode token to see user";
            [self.btnGetToken setHidden:NO];
            [self.btnAddItem setHidden:YES];
            [self.btnFetchItems setHidden:YES];
            [self.txtTodo setHidden:YES];
        } else {
            self.lblInfo.text = @"Code not found, check debug logs";
            [self.btnGetToken setHidden:YES];
            [self.btnAddItem setHidden:YES];
            [self.btnFetchItems setHidden:YES];
            [self.txtTodo setHidden:YES];
        }
    }];
    
    [self presentViewController:webVC animated:YES completion:^{
    }];
}

- (IBAction)tappedGetToken:(id)sender {
    if ([self.authCode isEqualToString:@""])
        return;
    //Create our url to match http://<login_url>/<AD_domain>/oauth2/token
    NSString *urlString = [WAAD_LOGIN_URL stringByAppendingFormat:@"%@/oauth2/token", WAAD_DOMAIN];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //We're sending over form url encoded values
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    //Build out key value pairs
    NSDictionary *bodyData = @{ @"client_id" : WAAD_CLIENT_ID ,
                                @"code" : self.authCode,
                                @"grant_type" : @"authorization_code",
                                @"redirect_uri" : WAAD_REDIRECT_URI
                            };
    //Encode the keyvalue pairs and set that to the request body
    NSData *data = [[bodyData URLFormEncode] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //Create an async request
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse
                       *response, NSData *data, NSError *error) {
        if (response)
            NSLog(@"reponse: %@", response);
        if (error) {
            NSLog(@"error: %@", error);
            return;
        }
    
        //Attempt to pull out the JSON response
        NSError   *jsonError  = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonObject) {
            NSLog(@"Token Response: %@", jsonObject);
            NSDictionary *responseDict = (NSDictionary *)jsonObject;
            //get values out of the response
            self.accessToken = [responseDict objectForKey:@"access_token"];
            self.expiresIn = [responseDict objectForKey:@"expires_in"];
            self.expiresOn = [responseDict objectForKey:@"expires_on"];
            self.idToken = [responseDict objectForKey:@"id_token"];
            self.refreshToken = [responseDict objectForKey:@"refresh_token"];
            self.resource = [responseDict objectForKey:@"resource"];
            self.scope = [responseDict objectForKey:@"scope"];
            self.tokenType = [responseDict objectForKey:@"token_type"];
            
            //Trigger an update of the UI on the main thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.btnFetchItems setHidden:NO];
                    [self.btnAddItem setHidden:NO];
                    [self.txtTodo setHidden:NO];
                    [self.btnDecodeToken setHidden:NO];
                });
            });
        }
    }];
}
- (IBAction)tappedFetchItems:(id)sender {    
    //Build URL to match http://<our_service>/<endpoint>
    NSString *urlString = [WAAD_RESOURCE stringByAppendingFormat:@"%@", WAAD_SERVICE_ENDPOINT];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    //Build auth header:  Bearer <token>
    NSString *authHeader = [@"Bearer " stringByAppendingFormat:@"%@", self.accessToken];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    //Create async request to fetch todo items
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse
            *response, NSData *data, NSError *error) {
        if (response)
            NSLog(@"response: %@", response);
        if (error) {
            NSLog(@"error: %@", error);
            return;
        }
        //Attempt to read the JSON Data
        NSError   *jsonError  = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        __block NSString  *output = @"Data not found";
        if (jsonObject) {
            NSLog(@"Todo list: %@", jsonObject);
            NSArray *items = (NSArray *)jsonObject;
            output = @"";
            for (NSDictionary *item in items) {
                output = [output stringByAppendingFormat:@"%@,",
                 [item valueForKey:@"Title"]];
            }
        }
        //Update the UI on the main thread
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{                
                self.lblInfo.text = [@"Data received: \n" stringByAppendingFormat:@"%@", output];
            });
        });
    }];
}
- (IBAction)tappedAddItem:(id)sender {
    //Build URL to match http://<our_service>/<endpoint>
    NSString *urlString = [WAAD_RESOURCE stringByAppendingFormat:@"%@", WAAD_SERVICE_ENDPOINT];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];    
    //Build auth header:  Bearer <token>
    NSString *authHeader = [@"Bearer " stringByAppendingFormat:@"%@", self.accessToken];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    //Create our key value pairs and encode them
    NSDictionary *bodyData = @{ @"Title" : self.txtTodo.text};
    NSData *data = [[bodyData URLFormEncode] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //Send async request
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse
            *response, NSData *data, NSError *error) {
        if (response)
            NSLog(@"response: %@", response);
        if (error) {
            NSLog(@"error: %@", error);
            return;
        }
//        
//        NSError   *jsonError  = nil;
//        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//        if (jsonObject) {
//
//        }
    }];
}

//This method looks at the claims that were returned for the token and
//attempts to decode them.  You could then pass these to the graph API
//for more information on them
- (IBAction)tappedDecodeToken:(id)sender {
    //Pulls the claims out of the token (content between 2nd and 3rd periods
    NSRange firstIndex = [self.accessToken rangeOfString:@"."];
    NSRange lastIndex = [self.accessToken rangeOfString:@"." options:NSBackwardsSearch];
    NSString *claims = [self.accessToken substringWithRange:NSMakeRange(firstIndex.location+1, (lastIndex.location- firstIndex.location - 1))];
    NSLog(@"Claims:%@", claims);
    //Create data from Base64 URL String (how the claims are encoded)
    NSData *data = [NSData dataFromBase64URLString:claims];
    //Get decoded string from the 
    NSString *decoded = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];    
    NSError *error;
    //Put the claims in a dictionary
    NSDictionary *claimsDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //Pull the username out of the claims to display to the user
    self.lblUser.text = [@"Logged in as " stringByAppendingFormat:@"%@", [claimsDictionary objectForKey:@"unique_name"]];
    NSLog(@"Decoded: %@", decoded);
    self.lblInfo.text = decoded;

}
@end
