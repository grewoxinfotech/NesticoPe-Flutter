import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contact/model/contact_model.dart';
import 'package:nesticope_app/data/network/contact/service/contact_service.dart';

class ContactController extends GetxController {
  final _service = ContactService();
  final RxBool isLoading = false.obs;
  final Rxn<ContactItem> contact = Rxn<ContactItem>();
  final RxString primaryPhone = ''.obs;
  final RxList<ContactItem> items = <ContactItem>[].obs;
  final RxInt page = 1.obs;
  final int limit = 10;
  final RxBool hasMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadContacts(reset: true);
  }

  Future<void> loadContacts({bool reset = false}) async {
    try {
      isLoading.value = true;
      if (reset) {
        page.value = 1;
        items.clear();
      }
      final PaginationResponse<ContactItem> res =
          await _service.fetchContactsPaged(page: page.value, limit: limit);
      items.addAll(res.items);
      hasMore.value = res.meta.hasMore;

      if (items.isNotEmpty && primaryPhone.value.isEmpty) {
        final first = items.first;
        contact.value = first;
        if (first.phones.isNotEmpty) {
          primaryPhone.value = first.phones.first;
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoading.value || !hasMore.value) return;
    page.value = page.value + 1;
    await loadContacts(reset: false);
  }
}
