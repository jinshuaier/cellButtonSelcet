//
//  ViewController.m
//  全选和单选
//
//  Created by 胡高广 on 2017/9/18.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "ViewController.h"

#import "HggProductTableViewCell.h"
#import "UILabel+MyLable.h"
#import "HggProduct.h"

#define WIDTH ([UIScreen  mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(100)]

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    //数据得数据源
    NSMutableArray *dataArray;
    
    //全选按钮
    UIButton *selectAll;
    
    //是否全选
    BOOL isSelect;
    
    //已选的商品合集
    NSMutableArray *selectGoods;
}

@property (nonatomic, strong) UITableView *hggTableView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    //每次进入购物车的时候把选择的置空
    [selectGoods removeAllObjects];
    isSelect = NO;
    selectAll.selected = NO;
    //加载数据
    [self creatData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化数组
    dataArray = [[NSMutableArray alloc] init];
    selectGoods = [[NSMutableArray alloc] init];
   
    //配置导航条
    [self setNav];
    
    //配置tableView
    [self createTableView];
    // Do any additional setup after loading the view, typically from a nib.
}

//配置tableView
- (void)createTableView
{
    self.hggTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.hggTableView.delegate =self;
    self.hggTableView.dataSource = self;
    self.hggTableView.showsVerticalScrollIndicator = NO;
    self.hggTableView.separatorStyle = 0;
    self.hggTableView.rowHeight = 50;
    [self.view addSubview:self.hggTableView];
    
    //创建头部视图
    [self createTopView];
}
//headView
- (void)createTopView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
    UILabel *label = [UILabel initWithText:@"全部选中" withFontSize:20 WithFontColor:[UIColor blueColor] WithMaxSize:CGSizeMake(100, 20)];
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(15, 20, 220, 20);
    [topView addSubview:label];
    
    //全选按钮
    selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    selectAll.frame = CGRectMake(15, 10, WIDTH - 30, 30);
    [selectAll setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    //    selectAll.backgroundColor = [UIColor lightGrayColor];
    [selectAll setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    [selectAll setTitle:@"        " forState:UIControlStateNormal];
    selectAll.imageEdgeInsets = UIEdgeInsetsMake(0,WIDTH - 50,0,selectAll.titleLabel.bounds.size.width);
    [topView addSubview:selectAll];
    
    
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line];
    
    self.hggTableView.tableHeaderView = topView;
}

#pragma mark -- 全选按钮的点击事件
- (void)selectAllBtnClick:(UIButton *)button
{
    //点击全选时，把之前已选择的全部删除
    [selectGoods removeAllObjects];
    
    button.selected = !button.selected;
    isSelect = button.selected;
    
    //如果选择了
    if (isSelect) {
        for (HggProduct *model in dataArray) {
            [selectGoods addObject:model];
        }
    }
    else
    {
        [selectGoods removeAllObjects];
    }
    
    //刷新
    [self.hggTableView reloadData];
}


#pragma mark -- tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"hggCell";
    HggProductTableViewCell *hggCell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (hggCell == nil) {
        hggCell = [[HggProductTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    hggCell.selectionStyle = UITableViewCellSelectionStyleNone;
    hggCell.isSelected = isSelect;
    
    //是否被选中
    if ([selectGoods containsObject:[dataArray objectAtIndex:indexPath.row]])
    {
        hggCell.isSelected = YES;
    }
    
    //block的实现方法
    hggCell.cartBlock = ^(BOOL isSelec){
        
        //选中就加入到数组
        if (isSelec) {
            [selectGoods addObject:[dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            //移除
            [selectGoods removeObject:[dataArray objectAtIndex:indexPath.row]];
        }
        
        //全选了
        if (selectGoods.count == dataArray.count) {
            selectAll.selected = YES;
        }
        else
        {
            selectAll.selected = NO;
        }
        
    };
    
    //实现方法
    [hggCell reloadDataWith:[dataArray objectAtIndex:indexPath.row]];
    
    return hggCell;
}
//增加的数据
-(void)creatData
{
    for (int i = 0; i < 10; i++) {
        HggProduct *model = [[HggProduct alloc]init];
        model.nameStr = MJRandomData;
        [dataArray addObject:model];
    }
    
}


#pragma mark ---配置导航条
- (void)setNav{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *additionBtn = [[UIButton alloc] init];
    [additionBtn setTitle:@"保存" forState:UIControlStateNormal];
    additionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [additionBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [additionBtn addTarget:self action:@selector(saveClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    additionBtn.frame = CGRectMake(0, 0, 40, 25);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:additionBtn];
}


- (void)saveClickBtn:(UIButton *)btn {
    NSLog(@"保存");

    NSMutableArray * array1 = [NSMutableArray array]; // create a Mutable array

    
    for (int i = 0; i < selectGoods.count ; i++) {
        HggProduct *model = [[HggProduct alloc]init];
        model = selectGoods[i];
        
        [array1 addObject:model.nameStr];
    }
    NSString *joinedString = [array1 componentsJoinedByString:@","];
    
    NSLog(@"joinedString is %@", joinedString);

    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"保存结果：%@", joinedString] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:true completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
