import 'package:gb/common/routes/app_routes.dart';
import 'package:gb/main.dart';
import 'package:gb/pages/edit_profile/edit_profile.dart';
import 'package:gb/pages/login/login_view.dart';
import 'package:gb/pages/me/me_view.dart';
import 'package:gb/pages/my_comment/my_comment.dart';
import 'package:gb/pages/my_opinion/my_opinion.dart';
import 'package:gb/pages/my_post/my_post.dart';
import 'package:gb/pages/signin/sign_in_view.dart';
import 'package:gb/pages/splash/splash_view.dart';
import 'package:gb/pages/topic_detail/topic_detail.dart';
import 'package:gb/pages/topic_list/topic_list.dart';
import 'package:gb/pages/upload_game/upload_game_view.dart';
import 'package:gb/pages/upload_topic/upload_topic.dart';
import 'package:get/get.dart';

class AppPages {
  AppPages._();
  static const initial = AppRoutes.pathSplash;
  static final List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.pathToHome,
      page: () => const MyHomePage(),
    ),
    GetPage(
      name: AppRoutes.pathSplash,
      page: () =>const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.pathToLogin, 
      page: () => const LoginPage()),
    GetPage(
      name: AppRoutes.pathToSignIn,
      page: () => const SignInPage()),
 
    GetPage(
      name: AppRoutes.pathMe, 
      page: ()=>const MePage()),
    GetPage(
      name: AppRoutes.pathToUpload, 
      page: ()=>const UploadGamePage()),
      GetPage(
      name: AppRoutes.pathToTopicList, 
      page: ()=>const TopicListPage()),
      GetPage(
      name: AppRoutes.pathToUploadTopic, 
      page: ()=>  UploadTopicPage()),
       GetPage(
      name: AppRoutes.pathToTopicDetail, 
      page: ()=>const  TopicDetailPage()),
      GetPage(
      name: AppRoutes.pathToMyPost, 
      page: ()=>const  MyPostPage()),
      GetPage(
      name: AppRoutes.pathToMyOpinion, 
      page: ()=>const  MyOpinionPage()),
      GetPage(
      name: AppRoutes.pathToMyComment, 
      page: ()=>const  MyCommentPage()),
      GetPage(
      name: AppRoutes.pathToEditProfile, 
      page: ()=>const  EditProfilePage()),
  ];
}
