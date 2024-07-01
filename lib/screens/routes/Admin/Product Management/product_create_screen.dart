import 'dart:io';

import 'package:eudaimonia_bakery/dto/product_category_model.dart';
import 'package:eudaimonia_bakery/endpoints/endpoints.dart';
import 'package:eudaimonia_bakery/screens/routes/Admin/Dashboard/admin_home_page.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:eudaimonia_bakery/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ProductCreateScreen extends StatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  State<ProductCreateScreen> createState() => _ProductCreateScreenState();
}

class _ProductCreateScreenState extends State<ProductCreateScreen> {
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
        .map((data) =>
            _ProductCategoryItem(data.productCategoryId, data.name))
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

  Future<void> _uploadImageAndCreateProduct(BuildContext context) async {
    if (_imageFile == null || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image and category')),
      );
      return;
    }

    try {
      final url = Uri.parse(Endpoints.productCreate);
      var request = http.MultipartRequest('POST', url);

      request.fields['name'] = _nameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['price'] = _priceController.text;
      request.fields['stock'] = _stockController.text;
      request.fields['category_id'] = _selectedCategoryId.toString(); // Convert to String

      request.files.add(
        await http.MultipartFile.fromPath('image', _imageFile!.path),
      );

      request.send().then((response) {
        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product created successfully')),
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
          _showErrorSnackBar('Failed to create product. Status code: ${response.statusCode}');
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
        title: const Text('Create Product'),
        backgroundColor: Constants.secondaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_imageFile == null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Text(
                      'No Image Selected',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Adjust the radius as needed
                child: Image.file(
                  _imageFile!,
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
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
                    items: _getAllProductCategory()
                        .map((data) { return DropdownMenuItem(
                              value: data.value,
                              child: Text(data.label),
                            );
                          })
                        .toList(),
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
              onPressed: () { _isLoading ? null : _uploadImageAndCreateProduct(context);},
              child: const Text('Create Product'),
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
