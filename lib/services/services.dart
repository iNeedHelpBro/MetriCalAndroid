import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:metrical/Dumps/dumps.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/auth/supabase_auth.dart';

class Services {
  static Services services = Services();
  final appLink = AppLinks();

  void sessionUniLink() {
    appLink.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final sess = SupabaseAuth.client.auth.currentSession;
        //check the current user
        print(sess?.user.id);
        if (sess == null) {
          SupabaseAuth.client.auth.getSessionFromUrl(uri);
          //try to retrive the uri link
          print(uri);
        } else {
          States.instance.pushAndReplaceName('login');
          States.instance.showtheSnackbar(
              title: 'Authentication finish!', color: yellowScheme);
        }
      }
    });
  }

  void forgotPasswordUniLinks(StreamSubscription<Uri> sub) async {
    sub = appLink.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.path == '/reset-password') {
        try {
          States.instance.pushAndReplaceName('forgotpass');
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
