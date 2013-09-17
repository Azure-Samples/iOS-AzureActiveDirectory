//
//  WebViewController.m
//  WAAD-Test
//
//  Created by Chris Risner on 9/10/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, strong) CompletionBlockWithString authCallback;

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCompletion:(CompletionBlockWithString)completion {
    self = [super init];
    self.authCallback = completion;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView = webView;
    self.webView.delegate = self;
    NSString *url = [WAAD_LOGIN_URL stringByAppendingFormat:@"%@/oauth2/authorize?response_type=code&resource=%@&client_id=%@&redirect_uri=%@", WAAD_DOMAIN, WAAD_RESOURCE, WAAD_CLIENT_ID, WAAD_REDIRECT_URI];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate Protocol

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestURL = [request.URL absoluteString];
    NSLog(@"URL: %@", requestURL);
    
    if ( [requestURL hasPrefix:WAAD_REDIRECT_URI] ) {
        NSLog(@"Code returned!");
        self.authCallback(requestURL);
        [self dismissViewControllerAnimated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

@end
