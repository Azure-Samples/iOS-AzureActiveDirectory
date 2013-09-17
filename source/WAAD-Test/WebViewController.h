//
//  WebViewController.h
//  WAAD-Test
//
//  Created by Chris Risner on 9/10/13.
//  Copyright (c) 2013 cmr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
    @property (weak, nonatomic) IBOutlet UIWebView *webView;

- (id)initWithCompletion:(CompletionBlockWithString)completion;

@end
