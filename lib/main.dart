import 'package:repalogic_messanger/utilities/common_exports.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().light,
      initialRoute: Routes.splashScreen,
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: NavigationService.generateRoute,
    );
  }
}
