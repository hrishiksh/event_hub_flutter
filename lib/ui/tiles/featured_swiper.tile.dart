import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events_flutter/blocs/global_bloc.dart';
import 'package:events_flutter/blocs/global_provider.dart';
import 'package:events_flutter/ui/tiles/event_big_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class FeaturedSwiper extends StatefulWidget {
  @override
  _FeaturedSwiperState createState() => _FeaturedSwiperState();
}

class _FeaturedSwiperState extends State<FeaturedSwiper> {
  static int batchSize = 3;

  @override
  Widget build(BuildContext context) {
    GlobalBloc globalBloc = GlobalProvider.of(context);

    if (globalBloc.swiperEventListCache.isNotEmpty) {
      print("from list..");
      return Container(
        color: Theme.of(context).primaryColorLight,
        height: 250,
        child: Swiper.list(
          autoplay: true,
          autoplayDelay: 5000,
          viewportFraction: 0.9,
          list: globalBloc.swiperEventListCache,
          builder: (context, item, index) {
            return EventBigTile(item);
          },
        ),
      );
    } else {
      // fetch events and show loader
      //fetch
      fetchEvents(globalBloc);

      return Container(
        color: Colors.grey[200],
        height: 250,
      );
    }
  }

  void fetchEvents(GlobalBloc globalBloc) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('events_mini')
        .orderBy('date', descending: true)
        .limit(batchSize)
        .get();
    globalBloc.swiperEventListCache.addAll(snapshot.docs);
    if (this.mounted) {
      setState(() {});
    }
  }
}
