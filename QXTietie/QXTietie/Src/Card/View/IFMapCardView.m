//
//  IFMapCardView.m
//  QXTietie
//
//  Created by ifwang on 14-3-3.
//  Copyright (c) 2014年 ifwang. All rights reserved.
//

#import "IFMapCardView.h"
#import "IFCardButton.h"
#import "IFLocationAnnotion.h"
#import <MapKit/MapKit.h>
CGFloat const kMapCardViewHeight = 150;

@interface IFMapCardView()<MKMapViewDelegate>

@property (nonatomic, strong) FUIButton *addBtn;


@property (nonatomic, strong) UILabel *locationLbl;

@property (nonatomic, strong) MKMapView *mapView;

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
    if (_mapView == nil)
    {
        [self startMaping];
    }
}

- (void)startMaping
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(20, 20, 280, 110)];
    [self addSubview:_mapView];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.scrollEnabled = NO;
    _mapView.alpha = 0;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 30)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [_mapView addSubview:backView];
    
    
    self.locationLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, 280, 16)];
    _locationLbl.font = [UIFont flatFontOfSize:14];
    _locationLbl.textColor = HEXCOLOR(0xFFFFFF);
    _locationLbl.backgroundColor = [UIColor clearColor];
    [_mapView addSubview:_locationLbl];

    [UIView animateWithDuration:1 animations:^{
        _mapView.alpha = 1;
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    //CLLocationCoordinate2D coords = userLocation.location.coordinate;
    
    
    CLLocation * newLocation = userLocation.location;
    _mapView.centerCoordinate = newLocation.coordinate;
    self.location = newLocation;
    
    MKCoordinateSpan  span=MKCoordinateSpanMake(0.01,0.01);
    MKCoordinateRegion  region=MKCoordinateRegionMake(newLocation.coordinate,span);
    [_mapView setRegion:region animated:YES];
    
    IFLocationAnnotion *ano = [[IFLocationAnnotion alloc] initWithLatitue:newLocation.coordinate.latitude
                                                                longitude:newLocation.coordinate.longitude];
    [_mapView addAnnotation:ano];
    
    
     NSLog(@"2::::::%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    //    //解析并获取当前坐标对应得地址信息
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            self.locationText = [NSString stringWithFormat:@"%@,%@,%@,%@",placeMark.name,placeMark.thoroughfare,placeMark.locality,placeMark.country];
            NSLog(@"位置信息:%@",_locationText);
            _locationLbl.text = _locationText;
            _mapView.showsUserLocation = NO;
        }
    };
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    // Initialize each view
    for (MKPinAnnotationView *mkaview in views)
    {
        // 当前位置 的大头针设为紫色，并且没有右边的附属按钮
        
        mkaview.pinColor = MKPinAnnotationColorPurple;
        mkaview.rightCalloutAccessoryView = nil;
        mkaview.animatesDrop = YES;
        mkaview.canShowCallout=NO;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *ano = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if(ano == nil)
    {
        ano = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    }
    ano.annotation = annotation;
    
    return ano;
}


@end
