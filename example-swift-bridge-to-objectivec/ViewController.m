//
//  ViewController.m
//  example-swift-bridge-to-objectivec
//
//  Created by Shunsuke Kondo on 2023/03/02.
//

#import "ViewController.h"


/* import the bridging header for Ditto */
#import "example_swift_bridge_to_objectivec-Swift.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    NSString *dittoSDKVersion = DittoManager.shared.dittoSDKVersion;

    NSLog(dittoSDKVersion, "%@");

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemsUpdated:)
                                                 name:@"ditto_items_updated"
                                               object:nil];

    [DittoManager.shared upsertItemWithId:@"001" name:@"item001"];

}

-(void)itemsUpdated:(NSNotification*)notification{
    NSArray *items = notification.userInfo[@"items"];

    // Use items to update UI
}



@end
