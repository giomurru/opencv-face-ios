#import "FaceDetector.hpp"
#import <opencv2/videoio/cap_ios.h>
#import <opencv2/objdetect.hpp>

#import "ViewController.h"

using namespace cv;
using namespace gm;
@interface ViewController () <CvVideoCameraDelegate>
@property (nonatomic, strong) UIImageView *cameraView;
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@end

@implementation ViewController
{
    std::shared_ptr<FaceDetector> m_face_detector;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 288, 352)];
    self.cameraView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    [self.view addSubview:self.cameraView];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.cameraView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.delegate = self;
    
    NSString *xmlPath = [[NSBundle mainBundle ] pathForResource:@"haarcascade_frontalface_default"
                                                         ofType: @"xml"];
    m_face_detector = std::make_shared<FaceDetector>([xmlPath cStringUsingEncoding:NSUTF8StringEncoding]);
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.videoCamera start];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)processImage:(cv::Mat &)image
{
    CFTimeInterval t1 = CACurrentMediaTime();
    
    m_face_detector->processImage(image);
    
    CFTimeInterval deltaTime = CACurrentMediaTime() - t1;
    NSLog(@"delta time %.0fms", deltaTime*1000);
}

- (void)dealloc
{
    //cvReleaseHaarClassifierCascade( &_cascade);
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
