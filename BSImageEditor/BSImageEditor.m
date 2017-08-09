//
//  BSImageEditor.m
//  WiseAPP
//
//  Created by 1vanFan on 2017/7/3.
//  Copyright © 2017年 SHYouChi. All rights reserved.
//

#import "BSImageEditor.h"
#import "BSImageDrawView.h"
#import "BSImageOval.h"
#import "BSImageArrow.h"
#import "UIImage+BSBundle.h"

#define kButtonWH       44

@interface BSImageEditor () <BSImageDrawViewDelegate, BSImageItemDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, strong) UIImageView     *imageView;
@property (nonatomic, strong) BSImageDrawView *drawView;
///<<<<<<<<<<<<< 工具栏
@property (nonatomic, strong) UIView   *topBar;         //!< 顶部导航栏
@property (nonatomic, strong) UIView   *toolBar;        //!< 底部工具栏
@property (nonatomic, strong) UIButton *ovalButton;     //!< 圆形工具
@property (nonatomic, strong) UIButton *arrowButton;    //!< 箭头工具
@property (nonatomic, strong) UIButton *deleteButton;   //!< 删除按钮
@property (nonatomic, strong) UIButton *widthButton;    //!< 线宽选择按钮
@property (nonatomic, strong) UIView   *widthView;
@property (nonatomic, strong) UIButton *widthThinButton;
@property (nonatomic, strong) UIButton *widthDefaultButton;
@property (nonatomic, strong) UIButton *widthThickButton;

@property (nonatomic, strong) BSImageItem     *selectItem;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation BSImageEditor

- (instancetype)initWithImage:(UIImage *)image delegate:(id<BSImageEditorDelegate>)delegate
{
    self = [super init];
    if (self) {
        _originImage = image;
        _delegate    = delegate;
        
        self.autoDismiss = YES;
    }
    
    return self;
}

- (UIModalTransitionStyle)modalTransitionStyle
{
    return UIModalTransitionStyleCrossDissolve;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor blackColor];
    
    // 顶部菜单
    [self createTopBar];
    
    // 编辑菜单
    [self createToolBar];
    
    // 创建画板
    [self createImageView];
    
    // 创建线宽选择器
    [self createLineWidthView];
}

- (void)createTopBar
{
    _topBar = [[UIView alloc] init];
    _topBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 64);
    [self.view addSubview:_topBar];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, _topBar.frame.size.height -kButtonWH, kButtonWH, kButtonWH);
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:backButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(_topBar.frame.size.width - kButtonWH -10, _topBar.frame.size.height -kButtonWH, kButtonWH, kButtonWH);
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_topBar addSubview:doneButton];
}

- (void)createToolBar
{
    _toolBar = [[UIView alloc] init];
    _toolBar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    [self.view addSubview:_toolBar];
    
    _ovalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ovalButton setImage:[UIImage bs_bundleImageNamed:@"editor_oval"] forState:UIControlStateNormal];
    [_ovalButton setImage:[UIImage bs_bundleImageNamed:@"editor_oval_select"] forState:UIControlStateSelected];
    [_ovalButton addTarget:self action:@selector(ovalButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_ovalButton];
    
    _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_arrowButton setImage:[UIImage bs_bundleImageNamed:@"editor_arrow"] forState:UIControlStateNormal];
    [_arrowButton setImage:[UIImage bs_bundleImageNamed:@"editor_arrow_select"] forState:UIControlStateSelected];
    [_arrowButton addTarget:self action:@selector(arrowButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_arrowButton];
    
    _widthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_widthButton setImage:[UIImage bs_bundleImageNamed:@"editor_menu"] forState:UIControlStateNormal];
    [_widthButton addTarget:self action:@selector(widthButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_widthButton];
    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteButton setImage:[UIImage bs_bundleImageNamed:@"editor_delete"] forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton setEnabled:NO];
    [_toolBar addSubview:_deleteButton];
    
    CGFloat leading = 20;
    CGFloat space = (_toolBar.frame.size.width - leading *2 - kButtonWH *4) /3;
    CGFloat buttonY = (_toolBar.frame.size.height - kButtonWH) /2;
    _ovalButton.frame = CGRectMake(leading, buttonY, kButtonWH, kButtonWH);
    _arrowButton.frame = CGRectMake(leading + kButtonWH + space, buttonY, kButtonWH, kButtonWH);
    _widthButton.frame = CGRectMake(leading + kButtonWH *2 + space *2, buttonY, kButtonWH, kButtonWH);
    _deleteButton.frame = CGRectMake(leading + kButtonWH *3 + space *3, buttonY, kButtonWH, kButtonWH);
}

- (void)createImageView
{
    // 图片
    _imageView = [[UIImageView alloc] initWithImage:_originImage];
    _imageView.frame = CGRectMake(0, CGRectGetMaxY(_topBar.frame), self.view.frame.size.width, CGRectGetMinY(_toolBar.frame) - CGRectGetMaxY(_topBar.frame));
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.imageView addGestureRecognizer:tap];
    
    // 绘制区域
    _drawView = [[BSImageDrawView alloc] init];
    _drawView.frame = _imageView.frame;
    _drawView.delegate = self;
    _drawView.hidden   = YES;
    [self.view addSubview:_drawView];
}

- (void)createLineWidthView
{
    CGFloat space = 10;
    _widthView = [[UIView alloc] init];
    _widthView.frame = CGRectMake(0, CGRectGetMinY(_toolBar.frame) -kButtonWH -1, kButtonWH *3 + space *2, kButtonWH);
    CGPoint center = _widthView.center;
    center.x = _widthButton.center.x;
    _widthView.center = center;
    _widthView.hidden = YES;
    _widthView.layer.cornerRadius = 4;
    _widthView.clipsToBounds = YES;
    _widthView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_widthView];
    
    _widthThinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_widthThinButton setImage:[UIImage bs_bundleImageNamed:@"editor_width_thin"] forState:UIControlStateNormal];
    [_widthThinButton setImage:[UIImage bs_bundleImageNamed:@"editor_width_thin_select"] forState:UIControlStateSelected];
    [_widthThinButton addTarget:self action:@selector(thinButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_widthView addSubview:_widthThinButton];
    
    _widthDefaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _widthDefaultButton.selected = YES;
    [_widthDefaultButton setImage:[UIImage bs_bundleImageNamed:@"editor_width_default"] forState:UIControlStateNormal];
    [_widthDefaultButton setImage:[UIImage bs_bundleImageNamed:@"editor_width_default_select"] forState:UIControlStateSelected];
    [_widthDefaultButton addTarget:self action:@selector(defaultButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_widthView addSubview:_widthDefaultButton];
    
    _widthThickButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_widthThickButton setImage:[UIImage bs_bundleImageNamed: @"editor_width_thick"] forState:UIControlStateNormal];
    [_widthThickButton setImage:[UIImage bs_bundleImageNamed: @"editor_width_thick_select"] forState:UIControlStateSelected];
    [_widthThickButton addTarget:self action:@selector(thickButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_widthView addSubview:_widthThickButton];
    
    _widthThinButton.frame = CGRectMake(0, 0, kButtonWH, kButtonWH);
    _widthDefaultButton.frame = CGRectMake(kButtonWH + space, 0, kButtonWH, kButtonWH);
    _widthThickButton.frame = CGRectMake(kButtonWH *2 + space *2, 0, kButtonWH, kButtonWH);
}

#pragma mark - top bar action

- (void)backButtonClick
{
    if ([self.delegate respondsToSelector:@selector(bs_imageEditorDidCancel:)]) {
        [self.delegate bs_imageEditorDidCancel:self];
    }
    if (self.autoDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doneButtonClick
{
    if (_selectItem) [_selectItem setSelect:NO];
    
    UIImageView *imgV = [[UIImageView alloc] initWithImage:_imageView.image];
    
    CGFloat ratio = 1,
    lateralDeviation = 0,   // 横向留白
    longitudinalDeviation = 0;// 纵向留白
    if (_imageView.image.size.width / _imageView.image.size.height > _imageView.frame.size.width / _imageView.frame.size.height) {
        // 图片充满imageView左右
        ratio = _imageView.image.size.width / _imageView.frame.size.width;
        longitudinalDeviation = (_imageView.frame.size.height * ratio - _imageView.image.size.height) /2;
    }
    else {
        // 图片充满imageView上下
        ratio = _imageView.image.size.height / _imageView.frame.size.height;
        lateralDeviation = (_imageView.frame.size.width * ratio - _imageView.image.size.width) /2;
    }
    
    for (BSImageItem *item in self.itemArray) {
        if ([item isKindOfClass:[BSImageOval class]]) {
            CGFloat x = (item.frame.origin.x + kTouchWH/2) * ratio - lateralDeviation;
            CGFloat y = (item.frame.origin.y + kTouchWH/2) * ratio - longitudinalDeviation;
            CGFloat width  = (item.frame.size.width - kTouchWH) * ratio;
            CGFloat height = (item.frame.size.height - kTouchWH) * ratio;
            
            BSImageOval *oval = [[BSImageOval alloc] initWithFrame:CGRectMake(x, y, width, height)];
            [oval changeLineWidth: item.lineWidth * fabs(ratio)];
            [oval showEditPoints:NO];
            [imgV addSubview:oval];
        }
        
        if ([item isKindOfClass:[BSImageArrow class]]) {
            BSImageArrow *origin = (BSImageArrow *)item;
            CGPoint tailPoint = CGPointMake(origin.linePoint.x * ratio - lateralDeviation, origin.linePoint.y * ratio - longitudinalDeviation);
            CGPoint tipPoint = CGPointMake(origin.arrowPoint.x * ratio - lateralDeviation, origin.arrowPoint.y * ratio - longitudinalDeviation);
            BSImageArrow *arrow = [[BSImageArrow alloc] initWithTailPoint:tailPoint tipPoint:tipPoint];
            [arrow changeLineWidth: origin.lineWidth * fabs(ratio)];
            [arrow showEditPoints:NO];
            [imgV addSubview:arrow];
        }
    }
    
    UIGraphicsBeginImageContextWithOptions(imgV.image.size, NO, imgV.image.scale);
    [imgV.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if ([self.delegate respondsToSelector:@selector(bs_imageEditor:didFinishEditWithImage:)]) {
        [self.delegate bs_imageEditor:self didFinishEditWithImage:image];
    }
    
    if (self.autoDismiss) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - tool bar action

- (void)ovalButtonClick
{
    _ovalButton.selected  = YES;
    _arrowButton.selected = NO;
    _widthView.hidden = YES;
    
    if (_selectItem) {
        [_selectItem setSelect:NO];
        _deleteButton.enabled = NO;
    }
    
    self.drawView.imageType = BSImageTypeOval;
    self.drawView.hidden    = NO;
}

- (void)arrowButtonClick
{
    _widthView.hidden = YES;
    _ovalButton.selected  = NO;
    _arrowButton.selected = YES;
    
    if (_selectItem) {
        [_selectItem setSelect:NO];
        _deleteButton.enabled = NO;
    }
    
    self.drawView.imageType = BSImageTypeArrow;
    self.drawView.hidden    = NO;
}

- (void)widthButtonClick
{
    _widthView.hidden = !_widthView.hidden;
    if (!_widthView.hidden) {
        [self.view bringSubviewToFront:self.toolBar];
    }
}

- (void)deleteButtonClick
{
    if (_selectItem) {
        [_selectItem removeFromSuperview];
        [self.itemArray removeObject:_selectItem];
        _selectItem = nil;
        _deleteButton.enabled = NO;
    }
}

#pragma mark - width view action

- (void)thinButtonClick
{
    _widthThinButton.selected    = YES;
    _widthDefaultButton.selected = NO;
    _widthThickButton.selected   = NO;
    
    self.lineWidth = kWidthThin;
    self.drawView.lineWidth = kWidthThin;

    if (_selectItem) {
        [_selectItem changeLineWidth:self.lineWidth];
    }
}

- (void)defaultButtonClick
{
    _widthThinButton.selected    = NO;
    _widthDefaultButton.selected = YES;
    _widthThickButton.selected   = NO;
    
    self.lineWidth = kWidthDefault;
    self.drawView.lineWidth = kWidthDefault;
    
    if (_selectItem) {
        [_selectItem changeLineWidth:self.lineWidth];
    }
}

- (void)thickButtonClick
{
    _widthThinButton.selected    = NO;
    _widthDefaultButton.selected = NO;
    _widthThickButton.selected   = YES;
    
    self.lineWidth = kWidthThick;
    self.drawView.lineWidth = kWidthThick;
    
    if (_selectItem) {
        [_selectItem changeLineWidth:self.lineWidth];
    }
}

#pragma mark - draw view delegate

- (void)bs_imageDrawView:(BSImageDrawView *)drawView didDrawOvalInRect:(CGRect)rect
{
    _ovalButton.selected = NO;
    // 移走画板
    self.drawView.hidden = YES;
    
    // 插入相应的标注View
    BSImageOval *item = [[BSImageOval alloc] initWithFrame:rect];
    [item changeLineWidth:self.lineWidth];
    item.delegate = self;
    [self.imageView addSubview:item];
    
    [self.itemArray addObject:item];
    [self selectItem: item];
}

- (void)bs_imageDrawView:(BSImageDrawView *)drawView didDrawArrowTailPoint:(CGPoint)tailPoint tipPoint:(CGPoint)tipPoint
{
    _arrowButton.selected = NO;
    // 移走画板
    self.drawView.hidden = YES;
    
    // 插入相应的标注View
    BSImageArrow *item = [[BSImageArrow alloc] initWithTailPoint:tailPoint tipPoint:tipPoint];
    [item changeLineWidth:self.lineWidth];
    item.delegate = self;
    [self.imageView addSubview:item];
    
    [self.itemArray addObject:item];
    [self selectItem: item];
}

#pragma mark - image item delegate

- (void)imageEditorSelectItem:(BSImageItem *)item
{
    [self selectItem: item];
}

#pragma mark - touch action

- (void)selectItem:(BSImageItem *)sitem
{
    _selectItem = sitem;
    
    for (BSImageItem *item in self.itemArray) {
        if (item != _selectItem) {
            [item setSelect: NO];
        }
        else {
            [item setSelect:YES];
            [self.imageView bringSubviewToFront:item];
        }
    }
    
    [_deleteButton setEnabled:(_selectItem != nil)];
}

- (void)tapImageView:(UITapGestureRecognizer *)sender
{
    CGPoint gesPoint = [sender locationInView:self.view];
    
    CGRect contentRect = _imageView.frame;
    if (CGRectContainsPoint(contentRect, gesPoint)) {
        CGRect itemRect = [_selectItem convertRect:_selectItem.bounds toView:self.view];
        if (!CGRectContainsPoint(itemRect, gesPoint)) {
            [self selectItem:nil];
        }
    }
}

#pragma mark - lazy loading

- (NSMutableArray *)itemArray
{
    if (_itemArray == nil) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (CGFloat)lineWidth
{
    if (_lineWidth == 0) {
        _lineWidth = kWidthDefault;
    }
    return _lineWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
