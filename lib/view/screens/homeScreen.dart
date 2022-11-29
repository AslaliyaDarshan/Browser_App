import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../../provider/homeProvider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InAppWebViewController? _inAppWebViewController;
  PullToRefreshController? _pullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  HomeProvider? HPT;
  HomeProvider? HPF;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).txtSearch =
        TextEditingController(
            text: Provider.of<HomeProvider>(context, listen: false).url);
  }

  @override
  Widget build(BuildContext context) {
    HomeProvider HPT = Provider.of<HomeProvider>(context, listen: true);
    HomeProvider HPF = Provider.of<HomeProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Column(
            children: [
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 45,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _inAppWebViewController!.goBack();
                      },
                      child: const Icon(Icons.arrow_back, size: 25),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        _inAppWebViewController!.goForward();
                      },
                      child: const Icon(Icons.arrow_forward, size: 25),
                    ),
                    InkWell(
                      onTap: () {
                        _inAppWebViewController!.reload();
                      },
                      child: const Icon(Icons.refresh, size: 25),
                    ),
                    Expanded(
                      child: TextField(
                        controller: HPT.txtSearch,
                        keyboardType: TextInputType.url,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _inAppWebViewController!.loadUrl(
                          urlRequest: URLRequest(
                            url: Uri.parse("https://${HPF.txtSearch.text}"),
                          ),
                        );
                      },
                      child: const Icon(Icons.search, size: 30),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              LinearProgressIndicator(
                value: HPT.progressLine.toDouble(),
              ),
              Expanded(
                child: InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: Uri.parse(HPT.url),
                    ),
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    initialOptions: options,
                    onLoadStart: (controller, url) {
                      HPF.changeUrl(
                        url.toString(),
                      );
                      _inAppWebViewController = controller;
                      HPT.txtSearch =
                          TextEditingController(text: url.toString());
                    },
                    onLoadError: (controller, url, code, message) {
                      HPF.changeUrl(
                        url.toString(),
                      );

                      _inAppWebViewController = controller;
                      HPT.txtSearch =
                          TextEditingController(text: url.toString());
                    },
                    onLoadStop: (controller, url) {
                      HPF.changeUrl(
                        url.toString(),
                      );
                      _inAppWebViewController = controller;
                      HPT.txtSearch =
                          TextEditingController(text: url.toString());
                    },
                    onProgressChanged: (controller, progress) {
                      _inAppWebViewController = controller;
                      HPF.progressBar(progress);
                    },
                    pullToRefreshController: PullToRefreshController(
                      options: PullToRefreshOptions(
                          color: Colors.blue,
                          backgroundColor: Colors.white,
                          size: AndroidPullToRefreshSize.LARGE),
                      onRefresh: () {
                        _inAppWebViewController!.reload();
                      },
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
