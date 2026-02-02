import 'package:get/get.dart';

import '../data/content_repository.dart';
import '../domain/portfolio_models.dart';

class ContentController extends GetxController {
  ContentController({required ContentRepository repository})
    : _repository = repository;

  final ContentRepository _repository;

  final Rxn<PortfolioContent> content = Rxn<PortfolioContent>();
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  @override
  void onInit() {
    super.onInit();
    load(forceRefresh: false);
    Future.microtask(forceReload);
  }

  Future<void> load({required bool forceRefresh}) async {
    loading.value = true;
    error.value = null;
    update();

    try {
      final c = await _repository.load(forceRefresh: forceRefresh);
      content.value = c;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
      update();
    }
  }

  Future<void> reload({bool forceRefresh = false}) =>
      load(forceRefresh: forceRefresh);

  Future<void> forceReload() => load(forceRefresh: true);
}
