import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Utils {
  static Future _launchUrl(String url) async {
    await canLaunch(url) ? launch(url) : print('Cannot launch url');
  }

  static Future openLink({
    @required link,
  }) =>
      _launchUrl(link);
  static Future openEmail({
    @required toEmail,
    @required subject,
    @required body,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(subject)}';

    await _launchUrl(url);
  }
}
