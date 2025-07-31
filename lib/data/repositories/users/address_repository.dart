import 'package:healplus_panel/data/repositories/authentication/authentication_repository.dart';
import 'package:healplus_panel/features/shop/models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddressRepository extends GetxController {
  static AddressRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  Future<List<AddressModel>> fetchUserAddresses(String userId) async {
    try {
      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .get();
      return result.docs
          .map(
            (documentSnapshot) =>
                AddressModel.fromDocumentSnapshot(documentSnapshot),
          )
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching Address Information. Try again later';
    }
  }

  Future<void> updateSelectedField(String addressId, bool selected) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .update({'SelectedAddress': selected});
    } catch (e) {
      throw 'Unable to update your address selection. Try again later';
    }
  }

  Future<String> addAddress(AddressModel address) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .add(address.toJson());
      return currentAddress.id;
    } catch (e) {
      throw 'Something went wrong while saving Address Information. Try again later';
    }
  }

  Future<void> updateAddress(String addressId, AddressModel address) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .update(address.toJson());
    } catch (e) {
      throw 'Unable to update your address. Try again later';
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .doc(addressId)
          .delete();
    } catch (e) {
      throw 'Unable to delete your address. Try again later';
    }
  }

  Future<AddressModel> getSelectedAddress() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .where('SelectedAddress', isEqualTo: true)
          .get();

      if (result.docs.isEmpty) {
        throw 'No selected address found';
      }

      return AddressModel.fromDocumentSnapshot(result.docs.first);
    } catch (e) {
      throw 'Something went wrong while fetching selected address. Try again later';
    }
  }

  Future<void> clearSelectedAddresses() async {
    try {
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final addresses = await _db
          .collection('Users')
          .doc(userId)
          .collection('Addresses')
          .where('SelectedAddress', isEqualTo: true)
          .get();

      for (final doc in addresses.docs) {
        await doc.reference.update({'SelectedAddress': false});
      }
    } catch (e) {
      throw 'Unable to clear selected addresses. Try again later';
    }
  }
}
