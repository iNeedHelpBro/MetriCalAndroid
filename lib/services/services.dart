import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:metrical/Notices/states.dart';
import 'package:metrical/auth/supabase_auth.dart';

class Services {
  static Services services = Services();
  final appLink = AppLinks();

  void initUniLinks() {
    appLink.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final sess = SupabaseAuth.client.auth.currentSession;
        print(sess?.user.id);
        if (sess == null) {
          SupabaseAuth.client.auth.getSessionFromUrl(uri);
          print(uri);
        } else {
          States.instance.pushAndReplaceName('login');
          print('Authentication finish');
        }
      }
    });
  }
}
