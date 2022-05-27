import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:infinite_scrolling/list_page_provider.dart';
import 'package:provider/provider.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListPageProvider()..fetchItems(),
      child: const ListPageView(),
    );
  }
}

class ListPageView extends StatefulWidget {
  const ListPageView({Key? key}) : super(key: key);

  @override
  State<ListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  late final _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<ListPageProvider>(
          builder: (context, provider, _) {
            return (provider.items.isEmpty && provider.isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : NotificationListener(
                    onNotification: (notification) {
                      if (notification is ScrollEndNotification &&
                          _scrollController.position.pixels >=
                              _scrollController.position.maxScrollExtent *
                                  0.7) {
                        log("Reached End of Scroll View");
                        context.read<ListPageProvider>().fetchItems();
                      }
                      return true;
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        return (index < provider.items.length)
                            ? ListTile(
                                title: Text(
                                  provider.items[index],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(height: 8.0);
                      },
                      itemCount: provider.items.length + 1,
                    ),
                  );
          },
        );
      },
    );
  }
}
