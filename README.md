#cell的封装与功能扩展
##背景
***
cell是IOS开发中最常用的控件，主要分/Users/nuomi/Desktop/经验案例/help.md为UITableViewCell和UICollectionViewCell.Cell的使用过程主要分为两步：1、注册cell信息 2、复用cell。一个工程往往包含大量的cell，甚至一个界面都有好几种不同的cell，如果都按常规的先注册、再复用得去写将会产生大量的重复代码。重复写相同的代码是一个十分枯燥而且痛苦的过程，因此将相同的代码封装很有必要。本文将介绍如何更加优雅地将cell的生成封装成一行代码，并且以cell自动计算高度功能为例子，介绍如果扩展cell的功能。
##封装与扩展前提
***
由于我们的项目主要使用xib加autolayout编辑cell界面，因此本文只介绍在下面条件下进行的封装与扩展。

* 使用nib生成cell
* 使用autolayout对cell进行布局约束

##Demo & Github
[https://github.com/NBaby/NMAutoHeightCellDemo](https://github.com/NBaby/NMAutoHeightCellDemo)
##cell的封装

###cell的初始化封装
***
我们先看看原来cell是怎么生成的：

![原本的cell.png](http://upload-images.jianshu.io/upload_images/2368050-3cb4aaa6e0a86a45.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

不难看出原来的cell和tableView是根据cellIdentifier关联起来的，而cell和xib是根据cellName关联起来的，大致关系如下：

![关系图.png](http://upload-images.jianshu.io/upload_images/2368050-56d06918ab2e5aff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如果我们使用cellName作为identifier，那么三者关系就变为：

![新关系图.png](http://upload-images.jianshu.io/upload_images/2368050-6edf9819b4029c44.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


也就是说，这样值需要传入一个参数cellName，tableView就能得到cell,cell也可以找到对应的xib界面。再来思考下cellName是否满足identifier唯一性的要求。cellName是类名，如果一个工程中存在两个相同的类，那么编译就不会通过，因此cellName可以顶替identifier作为cell的唯一标识。

下面就要思考这个封装起来的“公用”代码应该放在什么位置？答案是放在UITableView的类别中。因为cell时注册在tableView上，其生命周期应该与UItableView对象一致，如果tableView消失，其注册也应该失效，因此我选择放在UITableView的类别中，并且取名为：hs_customCellWithCellName:

![cell的生成.png](http://upload-images.jianshu.io/upload_images/2368050-c657d9e82f966235.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


值得注意的是，我给UITableViewCell添加了一个属性hs_tableView，是一个weak类型指针。也就是说，用该方法生成的cell都会保留一个tableView的指针，只要得到cell就能找到其所注册对应的tableView，为了后续功能扩展提供便捷。

###cell赋值的封装
对于cell的封装，我希望适用于所有cell，并且尽量不要干预适用者原有的cell的功能，因此我选择生成基类，基类的名称为`HSAutoHeightTableCell`，采用“继承”的关系。赋值的函数命名为

-(void)setInfo:(id)info;

info就是model对象，就是数据源。只有一个入参的目的其一是为了建议使用者养成适用“对象编程”的思想，将所有零零散散的入参都封装成一个model对象，然后将该对象传入cell中，减少参数少传、误传的概率。其二是规范赋值函数，为后续扩展作准备。

![cell基类.png](http://upload-images.jianshu.io/upload_images/2368050-9c10b789e0d1eac6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###封装的最终结果
封装前：

![原本的cell.png](http://upload-images.jianshu.io/upload_images/2368050-3cb4aaa6e0a86a45.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


封装后：
![封装结果.png](http://upload-images.jianshu.io/upload_images/2368050-c72bab7495677c82.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


将原来的三四行代码精简到一行代码，并且配上赋值代码，简单明了。如果配合上XCode的Code Snippets功能，使用起来更方便。

##cell自动计算高度功能扩展
***
cell高度适配是很多界面都需要用到的功能，也是很常见的功能之一。然而想要把它封装起来，并准确无误地使用并不是一件容易的事，因为有很多难点，也有很多细节需要设计。下面我大概从下面几个方面来叙述怎么完成一个自动计算高度的cell的封装。

* 设计方案，以及实现原理分析
* 高度缓存设计
* 基类Model NMAutoHeightModel的设计
* 缓存高度的key值如何生成
* 如何判断class的属性为int、float等基本类型

###设计方案，以及实现原理分析
我们知道，计算一个label的文字高度可以使用：

-(CGSize)sizeThatFits:(CGSize)size;

只要设置好字体，然后传入label的“最大宽度”，然后调用该方法就能获得其高度。根据这个原理，最笨拙的实现方法就是用该方法将cell中label的高度全部算出来，然后依次加上中间空隙的高度，就是cell的高度。但是，这种方法在cell纵向有很多label的时候就变得很笨拙，并且不通用。

当然，到了autolayout时代，我们完全可以把计算的事情交给电脑。与上面的方法类似，autolayout生成的cell也有办法自动获取高度，就是调用该方法：

-(CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize NS_AVAILABLE_IOS(6_0);

![cell撑开.png](http://upload-images.jianshu.io/upload_images/2368050-c46e8a993b75caf1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


与文字的计算高度类似，只要设置好label的最大宽大，再将cell中的控件的上下左右都设置好约束。这些约束就像小支架，将整个cell撑开来，然后调用systemLayoutSizeFittingSize:方法就能获得该cell根据label文字适配后的size,从而获得高度。该方法支持任意多个label，但是与高度有关的label都要设置最大宽度，并且不要忘记设置label的line为0；

下面是设置label最大宽度的方法：

![设置label的最大宽度.png](http://upload-images.jianshu.io/upload_images/2368050-70e62106c69655f7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####小技巧
这里有个小技巧，想要快速获得label的最大宽度有条公式：

**最大宽度 = 屏幕宽度 - cellXib宽度 + 当前xib中label的宽度**

原理也很简单，屏幕宽度是会变化的，但是label与cell的左右间距是固定的，因此屏幕变化的宽度的差值直接加在label的宽度上就好了。

###高度缓存设计
我们获得cell的高度实际上是用在`- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath`方法中。然而这个方法会在tableView初始化计算contentSize的时候和屏幕上下滚动的时候调用多次，如果每次都重新计算会浪费很多性能。与`sizeThatFits `类似，`systemLayoutSizeFittingSize:`的性能并不理想，如果暴力得每次都计算高度，会在数据量大的时候滑动卡顿甚至卡屏。因此需要将计算好的缓存记录下来，然后每次调用的时候快速获取高度。

缓存采用的是NSCache记录，因为希望该缓存的生命周期与tableView挂钩，所以在上面封装的`UITableView(HSCustomTableView)`的类别中添加属性`cellHeightCache`。使用NSCache的好处是其会自动根据内存情况释放，不会导致内存溢出。然后在HSAutoHeightTableCell添加获取高度的方法 `- (CGFloat)getHeightWithInfo:(id)info`,目的是希望在外面只要调用该方法就能获得高度，缓存机制写在该方法里面，info和上文一致传model。

思路的流程图如下：

![缓存高度流程图.png](http://upload-images.jianshu.io/upload_images/2368050-a094d3f418e54da1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###基类Model NMAutoHeightModel的设计
根据项目经验，传入到cell中model应该有很多属性，然后很多属性其实并不用计算到，比如远程图片路径，纵向高度无关的label的值，小图标等，有一些旧的工程还会很多界面用同一个model,因此里面的属性有很多冗余，因此计算高度中根据model生成key的方法里没必要在意所有的属性，我们只把注意力放在与cell高度有关的几个属性就好。

因此，我们打算设计一个Model的基类，目的是采用继承的关系不破坏原有model的结构，并且设计一个类似于“白名单”的功能，将关注的属性添加到里面，key值会根据该“白名单”计算出来。

![白名单.png](http://upload-images.jianshu.io/upload_images/2368050-affa3bf9c5c8809f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


如图所示，我添加了一个属性autoHeightProperty，子类重载该get方法，将需要关注的属性用数组加字符串的形式传入，然后返回该数组，后续计算高度key值会先判断Info是否为NMAutoHeightModel的子类，然后根据该数组中的属性字符串生成key值。
### 缓存高度的key值如何生成
key值的确定是本文最大的难点，它是某一特定情况下获取高度缓存的钥匙，直接挂钩缓存的可靠性。由于我设计的NSCache是放在UITableView中，每个tableView独立分开，因此只要考虑tableView层面以下的情况。经过思考，大致分为以下几种情况：

* 不同类型的cell，传入相同的info需要生成不同的key
* 相同类型的cell，传入不同的info需要生成不同的key

关于第一点，我们只需要将cell的类名用字符串的形式记录下来，作为前缀，也就是说所有的Key都前面都是以"XXXcell+"开头就能区分，所以重点在于后面一点。

关于第二点，我曾经尝试过MD5,sha1等方法，将传进来info的值编程唯一标示，确保key的唯一性，但是由于MD5、sha1本身就耗性能，每次计算高度前还要计算一次算法反而得不偿失。因此为采用了类似于"JSON字符串"的字符串拼接方法，得益于上面设计的`NMAutoHeightModel`的model设计，减少了很多干扰的属性，并且`autoHeightProperty`数组的顺序是固定的，不用担心“json字符串键值对前后顺序不一致，但是生成的model相同”的问题。虽然字符串拼接不能保证key值的唯一性，但是在实际开发中由于字符串拼接变化莫测，如果不是刻意去生成“特定数据”，很难出现key一样info不一样的情况，因此该方案应该是可靠的。

还有一种情况需要考虑，就是传入的info中的属性含有`NMAutoHeightModel`类型，或者info中的属性中的array或者dictiongary含有`NMAutoHeightModel`类型，这是生成json字符串就要包含下一级里面的所有`autoHeightProperty`属性，和json的拼接很类似，于是我设计一种递归的方案去编写代码。

大致流程图如下：

![大致流程图.png](http://upload-images.jianshu.io/upload_images/2368050-1b79294166cde64e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###如何判断class的属性为int、float等基本类型
判断一个属性是否为基本类型的方法是根据YYModel源码参考而来，相信在后续功能扩展中将会有很大的用处。

基本思想是利用runtime相关方法获取class对应属性的`objc_property_t`,然后再获取每一个`objc_property_t`的`objc_property_attribute_t`描述数组，不同属性的描述不一样，其中有一个Key值为“T”的描述可以区分是那种类型。

下面是我测试时的打印数据：
![测试打印数据.png](http://upload-images.jianshu.io/upload_images/2368050-a3f67849f9af8046.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


根据“T”的不同的值获取类型的方法：

![属性获取.png](http://upload-images.jianshu.io/upload_images/2368050-d7f5029ea564434f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

