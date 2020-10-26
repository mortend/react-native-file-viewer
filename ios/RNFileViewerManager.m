
#import "RNFileViewerManager.h"
#import <QuickLook/QuickLook.h>
#import <React/RCTConvert.h>

#define OPEN_EVENT @"RNFileViewerDidOpen"
#define DISMISS_EVENT @"RNFileViewerDidDismiss"

@interface File: NSObject<QLPreviewItem>

@property(readonly, nullable, nonatomic) NSURL *previewItemURL;
@property(readonly, nullable, nonatomic) NSString *previewItemTitle;

- (id)initWithPath:(NSString *)file title:(NSString *)title;

@end

@interface RNFileViewer ()<QLPreviewControllerDelegate>
@end

@implementation File

- (id)initWithPath:(NSString *)file title:(NSString *)title {
    if(self = [super init]) {
        _previewItemURL = [NSURL fileURLWithPath:file];
        _previewItemTitle = title;
    }
    return self;
}

@end

@interface CustomQLViewController: QLPreviewController<QLPreviewControllerDataSource>

@property(nonatomic, strong) File *file;
@property(nonatomic, strong) NSNumber *invocation;

- (void)updateToolbar;

@end

@implementation CustomQLViewController

- (instancetype)initWithFile:(File *)file identifier:(NSNumber *)invocation {
    if(self = [super init]) {
        _file = file;
        _invocation = invocation;
        self.dataSource = self;
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return UIApplication.sharedApplication.isStatusBarHidden;
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{
    return self.file;
}

- (void)myAction:(UIView *)view {
    NSLog(@"myAction was called!");
}

- (void)listSubviewsOfView:(UIView *)view {

    NSString *className = NSStringFromClass([view class]);

    if ([className isEqualToString:@"_UIModernBarButton"]) {

        UIButton* button = (UIButton*) view;
        NSString* title = button.titleLabel.text;

        // The Share button is the only button without a label.
        if (title == nil) {

            UIView* parent1 = button.superview;
            UIView* parent2 = parent1.superview;
            UIView* parent3 = parent2.superview;
            UIView* parent4 = parent3.superview;

            [parent4 removeFromSuperview];

            return;

            //[button addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];

            //[button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];

            //[yourButton addTarget:self action:@selector(yourAction:) forControlEvents:UIControlEventTouchUpInside];

            //button = [UIButton buttonWithType:UIButtonTypeSystem];
            //[button.titleLabel setText:@"Export"];
            //[button sizeToFit];
            //[parent addSubview:button];

            //NSSet* targets = [button allTargets];

            //for (NSObject *target in targets) {
            //    NSLog(@"%@", target);
            //}

            //[button removeTarget:<#(nullable id)#> action:<#(nullable SEL)#> forControlEvents:<#(UIControlEvents)#>]

            //[[parent subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];


            //button.currentTitle = @"Export";

            //NSLog(@"%@", view);
        }
    }


    // Get the subviews of the view
    NSArray *subviews = [view subviews];

    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE

    for (UIView *subview in subviews) {

        // Do what you want to do with the subview
        //NSLog(@"%@", subview);

        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self listSubviewsOfView:self.view];

    //self.navigationItem.rightBarButtonItem = nil; //For ipads the share button becomes a rightBarButtonItem
    //[[self.navigationController toolbar] setHidden:YES]; //This hides the share item

    //UIBarButtonItem *rightRetain = self.navigationItem.rightBarButtonItem;

    //UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailPDF)];
    //NSArray *items = [NSArray arrayWithObject:item];
    //[previewController setToolbarItems:items animated:NO];

    //UIBarButtonItem *email = ...;

    //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nil];
    //[email release];
}

- (void)updateToolbar {

    //[self listSubviewsOfView:self.view];

    //UIBarButtonItem *rightRetain = self.navigationItem.rightBarButtonItem;

    //UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(emailPDF)];
    //NSArray *items = [NSArray arrayWithObject:item];
    //[previewController setToolbarItems:items animated:NO];

    //UIBarButtonItem *email = ...;

    //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nil];
    //[email release];

    // Create a toolbar to have the buttons at the right side of the navigationBar
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 180, 44.01)];
    [toolbar setTranslucent:YES];

    // Create the array to hold the buttons, which then gets added to the toolbar
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:4];


    // Create button 1
    UIBarButtonItem* button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(button1Pressed)];
    [buttons addObject:button1];

    // Create button 2
    UIBarButtonItem* button2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(button2Pressed)];
    [buttons addObject:button2];

    // Create button 3
    UIBarButtonItem* button3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(button3Pressed)];
    [buttons addObject:button3];

    // Create a action button
    UIBarButtonItem* openButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openWith)];
    [buttons addObject:openButton];

    // insert the buttons in the toolbar
    [toolbar setItems:buttons animated:NO];

    // and put the toolbar in the navigation bar
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:toolbar]];

}

@end

@implementation RNFileViewer

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

+ (UIViewController*)topViewController {
    UIViewController *presenterViewController = [self topViewControllerWithRootViewController:UIApplication.sharedApplication.keyWindow.rootViewController];
    return presenterViewController ? presenterViewController : UIApplication.sharedApplication.keyWindow.rootViewController;
}

+ (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)viewController {
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)viewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navContObj = (UINavigationController*)viewController;
        return [self topViewControllerWithRootViewController:navContObj.visibleViewController];
    }
    if (viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed) {
        UIViewController* presentedViewController = viewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    for (UIView *view in [viewController.view subviews]) {
        id subViewController = [view nextResponder];
        if ( subViewController && [subViewController isKindOfClass:[UIViewController class]]) {
            if ([(UIViewController *)subViewController presentedViewController]  && ![subViewController presentedViewController].isBeingDismissed) {
                return [self topViewControllerWithRootViewController:[(UIViewController *)subViewController presentedViewController]];
            }
        }
    }
    return viewController;
}

- (void)previewControllerDidDismiss:(CustomQLViewController *)controller {
    [self sendEventWithName:DISMISS_EVENT body: @{@"id": controller.invocation}];
}

RCT_EXPORT_MODULE()

- (NSArray<NSString *> *)supportedEvents {
    return @[OPEN_EVENT, DISMISS_EVENT];
}

RCT_EXPORT_METHOD(open:(NSString *)path invocation:(nonnull NSNumber *)invocationId
    options:(NSDictionary *)options)
{
    NSString *displayName = [RCTConvert NSString:options[@"displayName"]];
    File *file = [[File alloc] initWithPath:path title:displayName];

    CustomQLViewController *controller = [[CustomQLViewController alloc] initWithFile:file identifier:invocationId];
    controller.delegate = self;

    typeof(self) __weak weakSelf = self;
    [[RNFileViewer topViewController] presentViewController:controller animated:YES completion:^{
        [weakSelf sendEventWithName:OPEN_EVENT body: @{@"id": invocationId}];
        [controller updateToolbar];
    }];
}

@end
