import 'package:flutter/material.dart';
import 'package:memory_plant_application/providers/language_provider.dart';
import 'package:memory_plant_application/widgets/privacy.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isKorean =
        context.watch<LanguageProvider>().currentLanguage == Language.ko;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          isKorean ? "이용약관" : "Privacy Policy",
          style: const TextStyle(
              fontFamily: 'NanumFontSetup_TTF_SQUARE_ExtraBold'),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0, // 상단 패딩 줄임
              bottom: 0.0, // 하단 패딩 줄임
              left: 10.0, // 기존 가로 패딩 유지
              right: 10.0, // 기존 가로 패딩 유지
            ),
            child: Column(
              children: [
                Privacy(isKorean: isKorean),
                ListTile(
                  leading: const Icon(
                    Icons.security,
                  ),
                  title: Text(
                    isKorean ? "서비스 이용약관" : "Terms of Service",
                    style: const TextStyle(
                        fontFamily: 'NanumFontSetup_TTF_SQUARE', fontSize: 14),
                  ),
                  onTap: () async {
                    const url =
                        'https://respected-kayak-802.notion.site/18088391469b80479960f732188a589b';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.security_rounded,
                  ),
                  title: Text(
                    isKorean ? "개인정보 처리방침" : "Privacy Policy",
                    style: const TextStyle(
                        fontFamily: 'NanumFontSetup_TTF_SQUARE', fontSize: 14),
                  ),
                  onTap: () async {
                    const url =
                        'https://respected-kayak-802.notion.site/18088391469b80a89a20c60910e0882c?pvs=74';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ), // IntroCenter 위젯 사용
    );
  }
}
