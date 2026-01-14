import 'package:repalogic_messanger/utilities/common_exports.dart';

class Routes {
  static const String splashScreen = "/";
  static const String loginScreen = "/login";
  static const String chatRoomsScreen = "/chatRooms";
  static const String createChatRoomScreen = "/createChatRoom";
  static const String chatScreen = "/chat";
  static const String inviteUsersScreen = "/inviteUsers";
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext get context => navigatorKey.currentContext!;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.chatRoomsScreen:
        return MaterialPageRoute(builder: (_) => const ChatRoomsScreen());
      case Routes.createChatRoomScreen:
        return MaterialPageRoute(builder: (_) => const CreateChatRoomScreen());
      case Routes.chatScreen:
        final chatRoom = settings.arguments as ChatRoomModel;
        return MaterialPageRoute(
          builder: (_) => ChatScreen(chatRoom: chatRoom),
        );
      case Routes.inviteUsersScreen:
        final chatRoom = settings.arguments as ChatRoomModel;
        return MaterialPageRoute(
          builder: (_) => InviteUsersScreen(chatRoom: chatRoom),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
