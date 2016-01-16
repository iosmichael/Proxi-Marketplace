
#import "CameraViewController.h"
#import "PostItemDetailViewController.h"
#import "LoginViewController.h"


@interface CameraViewController () <CACameraSessionDelegate>

@property (nonatomic, strong) CameraSessionView *cameraView;
@property (nonatomic,strong) UIImage *captureImage;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:36/255.0 green:104/255.0 blue:156/255.0 alpha:1.0];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self launchCamera];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.cameraView removeFromSuperview];
}

- (void)launchCamera{
    
    //Set white status bar
    [self setNeedsStatusBarAppearanceUpdate];
    //Instantiate the camera view & assign its frame
    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
    
    //Set the camera view's delegate and add it as a subview
    _cameraView.delegate = self;
    
    //Apply animation effect to present the camera view
    CATransition *applicationLoadViewIn =[CATransition animation];
    [applicationLoadViewIn setDuration:0.6];
    [applicationLoadViewIn setType:kCATransitionReveal];
    [applicationLoadViewIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [[_cameraView layer]addAnimation:applicationLoadViewIn forKey:kCATransitionReveal];
    
    [self.view addSubview:_cameraView];
    
    //[_cameraView setTopBarColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha: 0.64]];
    [_cameraView hideFlashButton]; //On iPad flash is not present, hence it wont appear.
    [_cameraView hideCameraToogleButton];
    [_cameraView hideDismissButton];
}

-(void)didCaptureImage:(UIImage *)image {
    NSLog(@"CAPTURED IMAGE");
    
    //Check if User is logged in
    
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"username"]) {
        UIStoryboard *storyboard1 = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard1 instantiateViewControllerWithIdentifier:@"LoginID"];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }else{
        
    
    self.captureImage =[self centerCropImage:image];
    PostItemDetailViewController *postItemViewController = [[PostItemDetailViewController alloc]init];
    
    postItemViewController.image = self.captureImage;
//        [self presentViewController:postItemViewController animated:YES completion:nil];
    [self.navigationController pushViewController:postItemViewController animated:YES];
    }

   // [self.cameraView removeFromSuperview];
}

-(void)didCaptureImageWithData:(NSData *)imageData {

    UIImage *image = [[UIImage alloc] initWithData:imageData];
    self.captureImage = image;
    
}

- (UIImage *)centerCropImage:(UIImage *)image
{
    CGFloat screen_width = [[UIScreen mainScreen]bounds].size.width;
    CGFloat screen_height = [[UIScreen mainScreen]bounds].size.height;
    
    UIImage *resizedImage = [self resizeImage:image width:screen_width  height:screen_height];
    // Center the crop area
    
#warning change the width and the height and change the 20 
    CGRect clippedRect = CGRectMake(0, (screen_height-screen_width)/2, screen_width, screen_width);
    
    // Crop logic
    CGImageRef imageRef = CGImageCreateWithImageInRect([resizedImage CGImage], clippedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef scale:1 orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    return croppedImage;
}

-(UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizeWidth height:(CGFloat)resizeHeight{
    UIGraphicsBeginImageContext(CGSizeMake(resizeWidth, resizeHeight));
    [image drawInRect:CGRectMake(0, 0, resizeWidth, resizeHeight)];
    UIImage *resizedImage =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}




@end
