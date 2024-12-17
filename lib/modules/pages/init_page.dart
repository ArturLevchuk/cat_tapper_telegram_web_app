import 'dart:async';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:cat_tapper_telegram_web_app/constants/cats_list.dart';
import 'package:cat_tapper_telegram_web_app/modules/models/account_state.dart';
import 'package:cat_tapper_telegram_web_app/modules/vms/account_controller.dart';
import 'package:cat_tapper_telegram_web_app/services/telegram_service.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class InitPage extends StatefulWidget {
  const InitPage(
      {super.key, required this.navigationShell, required this.children});
  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: widget.navigationShell,
      body: AnimatedBranchContainer(
        currentIndex: widget.navigationShell.currentIndex,
        children: widget.children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.navigationShell.currentIndex,
        selectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) {
          widget.navigationShell.goBranch(
            newIndex,
            initialLocation: newIndex == widget.navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.ads_click),
            label: "Tap tap",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Shop",
          ),
        ],
      ),
    );
    // return ValueListenableBuilder(
    //   valueListenable: pageValueListenable,
    //   builder: (context, value, child) {
    //     return Scaffold(
    //       body: IndexedStack(
    //         index: value,
    //         children: const [
    //           CatTapPage(),
    //           CatMarketPage(),
    //         ],
    //       ),
    //       bottomNavigationBar: BottomNavigationBar(
    //         currentIndex: value,
    //         selectedItemColor: Colors.white,
    //         type: BottomNavigationBarType.fixed,
    //         onTap: (newIndex) {
    //           pageValueListenable.value = newIndex;
    //         },
    //         items: const [
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.ads_click),
    //             label: "Tap tap",
    //           ),
    //           BottomNavigationBarItem(
    //             icon: Icon(Icons.shopping_cart),
    //             label: "Shop",
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }
}

class AnimatedBranchContainer extends StatelessWidget {
  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer(
      {super.key, required this.currentIndex, required this.children});

  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: children.mapIndexed(
      (int index, Widget navigator) {
        // return AnimatedOpacity(
        //   opacity: index == currentIndex ? 1 : 0,
        //   duration: const Duration(milliseconds: 400),
        //   child: _branchNavigatorWrapper(index, navigator),
        // );
        return AnimatedSlide(
          offset: index == currentIndex
              ? Offset.zero
              : Offset(currentIndex < index ? 1 : -1, 0),
          duration: const Duration(milliseconds: 400),
          child: _branchNavigatorWrapper(index, navigator),
        );
      },
    ).toList());
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}

class CatTapPage extends StatefulWidget {
  const CatTapPage({super.key});

  @override
  State<CatTapPage> createState() => _CatTapPageState();
}

class _CatTapPageState extends State<CatTapPage> {
  final audioPlayer = AudioPlayer();
  final StreamController tappingController = StreamController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    audioPlayer.setAsset("assets/sounds/meow.mp3");
    tappingController.stream
        .debounce((event) => TimerStream(true, const Duration(seconds: 1)))
        .listen(
      (_) async {
        await GetIt.I.get<AccountController>().saveAccount();
      },
    );
  }

  Future<void> playSound(bool playScarySound) async {
    try {
      if (playScarySound) {
        await audioPlayer.setAsset("assets/sounds/angry-cat-meow.mp3");
      } else {
        await audioPlayer.setAsset("assets/sounds/meow.mp3");
      }
      await audioPlayer.pause();
      await audioPlayer.seek(Duration.zero);
      await audioPlayer.play();
    } catch (err) {
      dev.log(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AccountController accountController =
        GetIt.I.get<AccountController>();
    final TelegramService telegramService = GetIt.I.get<TelegramService>();
    return Scaffold(
      body: StreamBuilder<AccountState>(
        stream: accountController.stream,
        builder: (context, snapshot) {
          final state = accountController.state;
          if (state.loadStatus == AccountStateLoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.loadStatus == AccountStateLoadStatus.initial) {
            accountController.init();
          }
          return SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (telegramService.telegramData != null &&
                    telegramService.telegramData!.isNotEmpty) ...[
                  // SizedBox(height: 20.h),
                  SizedBox(height: 20),

                  Text(
                    "Meow ${telegramService.telegramData?['user']?['first_name']}!",
                    style: const TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  const Spacer(),
                ] else
                  const Spacer(),
                Text(
                  "Meow count: ${state.coins}",
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    // accountController.tapCoin(1);
                    final random = Random().nextInt(10);

                    bool rare = random == 4;
                    if (rare) {
                      accountController.tapCoin(10);
                    } else {
                      accountController.tapCoin(1);
                    }

                    playSound(rare);
                    tappingController.add("tap");
                  },
                  child: SizedBox(
                    height: 300,
                    child: Image.asset(
                        "assets/images/cat_${state.selectedCat.index}.png"),
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CatMarketPage extends StatefulWidget {
  const CatMarketPage({super.key});

  @override
  State<CatMarketPage> createState() => _CatMarketPageState();
}

class _CatMarketPageState extends State<CatMarketPage> {
  @override
  Widget build(BuildContext context) {
    final AccountController accountController =
        GetIt.I.get<AccountController>();
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: StreamBuilder<Object>(
            stream: accountController.stream,
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: catsList.entries.map(
                    (e) {
                      return Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 180,
                              child: Image.asset(
                                  "assets/images/cat_${e.key.index}.png"),
                            ),
                            Builder(
                              builder: (context) {
                                final catNumber = e.key;
                                final bool isSelected = catNumber ==
                                    accountController.state.selectedCat;
                                final bool alreadyPurchased = accountController
                                    .state.cats
                                    .contains(catNumber);
                                if (isSelected) {
                                  return FilledButton(
                                    onPressed: () {},
                                    child: const Text("Selected"),
                                  );
                                } else if (alreadyPurchased) {
                                  return FilledButton(
                                    onPressed: () async {
                                      await accountController.setCat(catNumber);
                                    },
                                    child: const Text("Select"),
                                  );
                                } else {
                                  final bool availableToBuy =
                                      accountController.state.coins >=
                                          catsList[catNumber]!;
                                  return FilledButton(
                                    onPressed: availableToBuy
                                        ? () async {
                                            accountController.buyCat(catNumber);
                                          }
                                        : null,
                                    child: Text("${catsList[catNumber]} Meow"),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              );
            }),
      ),
    );
  }
}
