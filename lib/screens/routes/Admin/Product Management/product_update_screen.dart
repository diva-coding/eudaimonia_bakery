import 'dart:io';

import 'package:eudaimonia_bakery/dto/product_category_model.dart';
import 'package:eudaimonia_bakery/dto/product_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Dashboard/admin_home_page.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductUpdateScreen extends StatefulWidget {
  final Product productToUpdate;

  const ProductUpdateScreen({super.key, required this.productToUpdate});

  @override
  State<ProductUpdateScreen> createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  File? _imageFile;
  final picker = ImagePicker();
  int? _selectedCategoryId; // Changed to int for category_id
  List<ProductCategory> _productCategories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.productToUpdate.name;
    _descriptionController.text = widget.productToUpdate.description;
    _priceController.text = widget.productToUpdate.price.toString();
    _stockController.text = widget.productToUpdate.stock.toString();
    _selectedCategoryId = widget.productToUpdate.categoryId;
    _fetchProductCategories();
  }

  Future<void> _fetchProductCategories() async {
    try {
      final data = await ProductDataService.fetchProductCategory();

      setState(() {
        _productCategories = data;
        _isLoading = false;
      });
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  List<_ProductCategoryItem> _getAllProductCategory() {
    final allCategory = _productCategories;

    return allCategory
        .map((data) => _ProductCategoryItem(data.productCategoryId, data.name))
        .toList();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickFromOtherGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path!);
      });
    }
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Other Gallery Apps'),
                onTap: () {
                  _pickFromOtherGallery();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadImageAndUpdateProduct(
      BuildContext context, int productToUpdateId) async {
    try {
      final url = Uri.parse('${Endpoints.productUpdate}/$productToUpdateId');
      var request = http.MultipartRequest('PUT', url);

      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['price'] = _priceController.text;
      request.fields['stock'] = _stockController.text;
      request.fields['category_id'] =
          _selectedCategoryId.toString(); // Convert to String

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imageFile!.path),
        );
      }

      request.send().then((response) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
          _nameController.clear();
          _descriptionController.clear();
          _priceController.clear();
          _stockController.clear();
          setState(() {
            _imageFile = null;
            _selectedCategoryId = null;
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminHomePage(
                  initialIndex: 0), // Set initialIndex to 1 for Products tab
            ),
            (route) => false,
          );
        } else {
          _showErrorSnackBar(
              'Failed to updated product. Status code: ${response.statusCode}');
        }
      });
    } catch (e) {
      _showErrorSnackBar('An error occurred: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
        backgroundColor: Constants.secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                child: Image.file(
                  _imageFile!,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                child: Image.network(
                  '${Endpoints.baseAPI}${widget.productToUpdate.imageUrl}',
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: const Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () => _showPicker(context),
              child: const Text('Choose Image'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<int>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Category'),
                    items: _getAllProductCategory().map((data) {
                      return DropdownMenuItem(
                        value: data.value,
                        child: Text(data.label),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedCategoryId = newValue;
                      });
                    },
                    validator: (newValue) =>
                        newValue == null ? 'Please select a category' : null,
                  ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _isLoading
                    ? null
                    : _uploadImageAndUpdateProduct(
                        context, widget.productToUpdate.id);
              },
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCategoryItem {
  final int value; // ID of the category
  final String label; // User-friendly display label

  _ProductCategoryItem(this.value, this.label);
}
