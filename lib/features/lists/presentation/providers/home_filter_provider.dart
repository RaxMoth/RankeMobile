import 'package:flutter_riverpod/flutter_riverpod.dart';

enum HomeFilter { owned, joined, saved }

final homeFilterProvider = StateProvider<HomeFilter>((ref) => HomeFilter.owned);
