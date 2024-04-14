import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lazy_listview_with_bloc/core/model/post_model.dart';
import 'package:flutter_lazy_listview_with_bloc/core/post_bloc/bloc/post_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        centerTitle: true,
      ),
      body: BlocProvider<PostBloc>(
        create: (context) =>
            PostBloc(client: HttpClient())..add(const PostFechEvent()),
        child: const HomeBody(),
      ),
    );
  }
}

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrool);
    super.initState();
  }

  void _onScrool() {
    if (_isBottom) context.read<PostBloc>().add(const PostFechEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScrool = _scrollController.position.maxScrollExtent;
    final crrentScroolPos = _scrollController.offset;
    return crrentScroolPos >= (maxScrool * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController.removeListener(_onScrool);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, postState) {
        switch (postState.status) {
          case PostStatus.failure:
            return const Center(
              child: Text('Something went wrong!'),
            );
          case PostStatus.success:
            if (postState.posts.isEmpty) {
              return const Center(
                child: Text(' Posts Not found!'),
              );
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: postState.hasReachedMax
                  ? postState.posts.length
                  : postState.posts.length + 1,
              itemBuilder: (context, index) {
                return index >= postState.posts.length
                    ? const ProgressIndicator()
                    : PostListItem(
                        post: postState.posts[index],
                      );
              },
            );

          default:
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('...Loading'),
                  CircularProgressIndicator(
                    strokeWidth: 1.5,
                  )
                ],
              ),
            );
        }
      },
    );
  }
}

class PostListItem extends StatelessWidget {
  const PostListItem({
    super.key,
    required this.post,
  });
  final PostModel post;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text(
          '${post.id}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        title: Text(
          post.title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        subtitle: Text(
          post.body,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        isThreeLine: true,
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(
            strokeAlign: 1.5,
          )),
    );
  }
}
