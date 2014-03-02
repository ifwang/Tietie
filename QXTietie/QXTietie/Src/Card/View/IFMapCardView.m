//
//  IFMapCardView.m
//  QXTietie
//
//  Created by ifwang on 14-3-3.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFMapCardView.h"
#import "IFCardButton.h"
CGFloat const kMapCardViewHeight = 150;

@interface IFMapCardView()<MKMapViewDelegate>

@property (nonatomic, strong) FUIButton *addBtn;


@property (nonatomic, strong) MKMapView *mapView;

@property (nonatomic, strong) UILabel *locationLbl;

@end

@implementation IFMapCardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isLocated = NO;
        [self initView];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)initView
{
    FUIButton *button = [IFCardButton button];
    button.frame = CGRectMake(15, 15, 290, 120);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *addImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Plus"]];
    addImg.frame = CGRectMake(125, 40, 40, 40);
    addImg.userInteractionEnabled = NO;
    [button addSubview:addImg];
    self.addBtn = button;
    [self addSubview:button];
    
}

- (void)btnAction:(id)sender
{
    if(!_isLocated)
    {
        if (_mapView == nil)
        {
            self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(5, 5, 280, 95)];
            _mapView.delegate = self;
            _mapView.showsUserLocation = YES;
            _mapView.alpha = 0;
            [_addBtn addSubview:_mapView];
            
            self.locationLbl = [[UILabel alloc] initWithFrame:CGRectMake(5, 102, 280, 16)];
            _locationLbl.font = [UIFont flatFontOfSize:14];
            _locationLbl.backgroundColor = [UIColor clearColor];
            _locationLbl.textColor = HEXCOLOR(0x272727);
            _locationLbl.alpha = 0;
            [_addBtn addSubview:_locationLbl];
            
            
            [UIView animateWithDuration:0.5 animations:^{
                _mapView.alpha = 1;
                _locationLbl.alpha = 1;
            }];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //CLLocationCoordinate2D coords = userLocation.location.coordinate;
    CLLocation * newLocation = userLocation.location;
    self.location = newLocation.coordinate;
    // NSLog(@"2::::::%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //    //解析并获取当前坐标对应得地址信息
    
    
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            self.locationLbl.text = placeMark.name;
            _locationText = placeMark.name;
        }
    };
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
    _isLocated = YES;
    
}

@end
