import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:knaw_news/mixin/data.dart';
import 'package:knaw_news/model/emojis_model.dart';
import 'package:knaw_news/model/post_model.dart';
import 'package:knaw_news/services/dio_service.dart';
import 'package:knaw_news/util/dimensions.dart';
import 'package:knaw_news/util/images.dart';
import 'package:knaw_news/util/styles.dart';
import 'package:knaw_news/view/base/custom_snackbar.dart';
import 'package:knaw_news/view/base/loading_dialog.dart';
import 'package:knaw_news/view/screens/comment/comment.dart';
import 'package:knaw_news/view/screens/home/widget/report_dialog.dart';
import 'package:knaw_news/view/screens/home/widget/user_info.dart';
import 'package:knaw_news/view/screens/home/widget/vertical_tile.dart';
import 'package:like_button/like_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';



import '../../../base/no_data_screen.dart';


class FullTransition extends StatefulWidget {
  int? cateID;
  List<GetEmojis>? getemojies;
  List<PostDetail> postDetail = [];
  FullTransition({Key? key, this.cateID, PostDetail? postDetail, }) : super(key: key);

  @override
  State<FullTransition> createState() => _FullTransitionState();
}

class _FullTransitionState extends State<FullTransition> {
  bool isComment=false;
  List<UpperCategories>? getUpperList;
  List<LowerCategories>? getLowerList;
  List<PostDetail> postDetail = [];
  ScrollController scrollController=ScrollController();
  int totalPost=-1;
  int? extendedIndex;
  bool isTapped = false;


  // bool isReadMore=false;
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      // translate();
    });
    loadPosts(widget.cateID!);

  }
  _launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  Future<void> loadPosts(int cateID) async {

    // _tabController!.index=selected-1;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      openLoadingDialog(context, 'loading');
    });

    var response;
    var data = {
      "usersId" : AppData().userdetail!.usersId,
      "categoryId": cateID,
      "userCountry": AppData().userdetail!.country,
    };
    response = await DioService.post('emoji_posts', data);

    print(response);
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      postDetail=  jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList();
      print('----------postDetail.first.categories-----------------------');

      totalPost = postDetail.length;
    }
    else{
      totalPost=0;
    }
    setState (() {} );
     Navigator.pop(context);

  }
  Future<void> loadEmojis(int cateID) async {

    // _tabController!.index=selected-1;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // openLoadingDialog(context, 'loading');
    });

    var response;
    var data = {
      "usersId" : AppData().userdetail!.usersId,
      "categoryId": cateID,
      "userCountry": AppData().userdetail!.country,
    };
    response = await DioService.post('emoji_posts', data);

    print(response);
    if(response['status']=='success'){
      var jsonData= response['data'] as List;
      postDetail=  jsonData.map<PostDetail>((e) => PostDetail.fromJson(e)).toList();
      print('----------postDetail.first.categories-----------------------');

      totalPost = postDetail.length;
    }
    else{
      totalPost=0;
    }
    setState (() {} );
    // Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    return  postDetail.isNotEmpty ?Container(
      width: MediaQuery.of(context).size.width*0.9,
      child: ListView.builder(
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: postDetail.length,
          itemBuilder: (context,index){
           return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Wrap(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*9,
                    margin: EdgeInsets.only(top: 10,left: 5,right: 5,bottom: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              spreadRadius: 1
                          ),
                        ]
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// User Detail
                        UserInfo(postDetail: postDetail[index],),
                        /// Post Title
                        Container(
                          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.01,),
                          width: MediaQuery.of(context).size.width*0.9,
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [

                            ],
                          ),
                        ),

                        /// Upper emoji list
                        Container(
                          height: 75,
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: postDetail[index].uppercategories!.length,
                            itemBuilder: (context, index1) {
                              return  GestureDetector(
                                onTap: (){
                                //   addEmojiToPost(postDetail[index].newsPostId,postDetail[index].uppercategories![index1].id);
                                // loadPosts(widget.cateID!);
                                  },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.112,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 12,),
                                          Container(
                                            child: SvgPicture.asset('assets/emojis/${postDetail[index].uppercategories![index1].path}',height: 25),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(postDetail[index].uppercategories![index1].count.toString(),style: TextStyle(color: Colors.black,fontSize: 14),),

                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 1,
                                      left:0,
                                      child: LikeButton(
                                        onTap: (value) async {
                                          await addEmojiToPost(postDetail[index].newsPostId,postDetail[index].uppercategories![index1].id);
                                          loadEmojis(widget.cateID!);
                                          return !value;
                                        },
                                        animationDuration: Duration(seconds: 3),
                                        size: 45,
                                        likeBuilder: (isTapped){
                                          return Icon(Icons.circle,
                                            color: isTapped? Colors.transparent:Colors.transparent,
                                          );
                                        },

                                      ),
                                    ),

                                  ],

                                ),
                              );
                            },
                          ),
                        ),
                        /// News Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            children: [
                              Text(
                                postDetail[index].description!,
                                // maxLines: isReadMore?100:3,
                                style: openSansRegular.copyWith(fontSize: Dimensions.fontSizeSmall+1,color: Colors.black,overflow: TextOverflow.fade),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          height: 75,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: postDetail[index].lowercategories!.length,
                            itemBuilder: (context, index2) {
                              return  GestureDetector(
                                onTap: (){
                                  // addEmojiToPost(postDetail[index].newsPostId,postDetail[index].lowercategories![index2].id);
                                  // loadEmojis(widget.cateID!);
                                  },
                                child:Stack(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width*0.13,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 12,),
                                          Container(
                                            child: SvgPicture.asset('assets/emojis/${postDetail[index].lowercategories![index2].path}',height: 25),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(postDetail[index].lowercategories![index2].count.toString(),style: TextStyle(color: Colors.black,fontSize: 14),)
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left:0,
                                      child: LikeButton(
                                        onTap: (value) async {
                                          await  addEmojiToPost(postDetail[index].newsPostId,postDetail[index].lowercategories![index2].id);
                                          loadEmojis(widget.cateID!);
                                          return !value;
                                        },
                                        animationDuration: Duration(seconds: 3),
                                        size: 50,
                                        likeBuilder: (isTapped){
                                          return Icon(Icons.circle,
                                            color: isTapped? Colors.transparent:Colors.transparent,
                                          );
                                        },

                                      ),
                                    ),

                                  ],

                                ),

                              );
                            },
                          ),
                        ),

                        Container(
                          // margin: EdgeInsets.symmetric(vertical: 5),
                          height: 1.3,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.4),
                        ),

                        ///Post Image

                        SizedBox(height: 8,),
                        /// Action Bar
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              VerticalTile(icon:  postDetail[index].isBookmarked=="true"?Images.bookmark_bold:Images.bookmark,
                                title: "",
                                onTap: (){
                                bookmarkPost(postDetail[index].newsPostId);
                                loadPosts(widget.cateID!);
                                },
                              ),
                              VerticalTile(icon: Images.comment, title: '(${ postDetail[index].totalComments.toString()})',isBlack: true,
                                  onTap: (){
                                isComment=!isComment;
                                setState(() {

                                });
                              }),
                              InkWell(
                                  onTap: () async {
                                    Share.share(postDetail[index].description.toString());

                                  },
                                  child: Icon(Icons.share,size:25,color: Colors.grey.withOpacity(0.5),)),
                              InkWell(
                                onTap: () {
                                  Get.dialog(ReportDialog(postDetail:  postDetail[index]));

                                },
                                child: Icon(Icons.info_outline,size: 25,color: Colors.grey.withOpacity(0.5),),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                      ],
                    ),
                  ),
                  // Comments on post
                  isComment?Container(child: CommentScreen(postDetail:  postDetail[index],)):SizedBox()
                ],
              ),
            );
          }
      ),
    ):Center(child: NoDataScreen());

  }
  // void translate() async {
  //   var translation=await widget.postDetail!.title!.translate(to: AppData().language!.languageCode);
  //   var translator=await widget.postDetail!.description!.translate(to: AppData().language!.languageCode);
  //   if(mounted){
  //     widget.postDetail!.title=translation.text;
  //     widget.postDetail!.description=translator.text;
  //     setState(() {});
  //   }
  // }
  Future<void> bookmarkPost(postId) async {
    // openLoadingDialog(context, "Loading");
    var response;
    response = await DioService.post('bookmark_news_post', {
      "usersId" : AppData().userdetail!.usersId,
      "newsPostId" : postId,

    });
    if(response['status']=='success'){
      //print(postDetail![0].toJson());
      // widget.postDetail!.isBookmarked=="true"?widget.postDetail!.isBookmarked="false":widget.postDetail!.isBookmarked="true";
      // Navigator.pop(context);
      setState(() {

      });
      print('book mark ---------------------');
      print(response);
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['message']);

    }
  }


  Future<void> viewPost() async {
    //openLoadingDialog(context, "Loading");
    var response;

    response = await DioService.post('view_post', {
      "usersId" : AppData().userdetail!.usersId,
      // "newsPostId" : widget.postDetail!.newsPostId
    });
    if(response['status']=='success'){
      //Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['data'],isError: false);
    }
    else{
      //Navigator.pop(context);
      setState(() {

      });
      //showCustomSnackBar(response['message']);

    }
  }

  Future<void> addEmojiToPost(postID,cateID) async {
    // openLoadingDialog(context, "Loading");
    var response;
    var data = {
      "usersId" : AppData().userdetail!.usersId,
      "newsPostId": postID,
      "categoryId":cateID,
    };
    response = await DioService.post('add_emoji_to_post', data);
    print(response);
    print('--------------------------------------------');
    print(data);
    if(response['status']=='success'){
      setState(() {

      });
      // Navigator.pop(context);

    }
    else{
      showCustomSnackBar('You cannot add more than three emoji to the post');
      setState(() {});
      // Navigator.pop(context);

    }
  }


}
