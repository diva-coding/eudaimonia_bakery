import 'package:eudaimonia_bakery/dto/product_category_model.dart';
import 'package:eudaimonia_bakery/services/product_data_service.dart';
import 'package:flutter/material.dart';

class ProductCategoryListScreen extends StatefulWidget {
  const ProductCategoryListScreen({super.key});

  @override
  State<ProductCategoryListScreen> createState() =>
      _ProductCategoryListScreenState();
}

class _ProductCategoryListScreenState extends State<ProductCategoryListScreen> {
  List<ProductCategory> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchProductCategories();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _fetchProductCategories() async {
    try {
      final categoriesData = await ProductDataService.fetchProductCategories();
      setState(() {
        categories = categoriesData
            .map((data) => ProductCategory.fromJson(data))
            .toList();
      });
    } catch (e) {
      _showErrorSnackBar('Error fetching product categories: $e');
    }
  }

  Future<void> _addProductCategory(String name) async {
    try {
      await ProductDataService.addProductCategory(
          name); // Use the data service here
      _fetchProductCategories(); // Refresh after adding
    } catch (e) {
      _showErrorSnackBar('Error adding category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Categories'),
      ),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

          return Column(
            children: [
              ListTile(
                title: Text(category.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditDialog(category),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        // Show a confirmation dialog before deleting
                        bool confirmDelete = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: Text(
                                    'Are you sure you want to delete ${category.name}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            ) ??
                            false;

                        if (confirmDelete) {
                          // Show loading indicator (using StatefulBuilder for dynamic rebuild)
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              bool isLoading = true;
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: const Text('Deleting Category'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (isLoading)
                                          const LinearProgressIndicator(),
                                        if (isLoading)
                                          const Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text("Deleting category..."),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );

                          // Perform the delete operation
                          try {
                            await ProductDataService.deleteProductCategory(
                                category.productCategoryId);
                            // Refresh the category list and show success snackbar
                            await _fetchProductCategories();
                            _showErrorSnackBar('Category deleted successfully');
                          } catch (e) {
                            // Show error snackbar
                            _showErrorSnackBar('Error deleting category: $e');
                          } finally {
                            // Dismiss the loading indicator
                            Navigator.of(context).pop();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showEditDialog(ProductCategory category) {
    final TextEditingController nameController =
        TextEditingController(text: category.name);
    bool isLoading = false; // Loading state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'New Name'),
                    enabled: !isLoading,
                  ),
                  if (isLoading)
                    const LinearProgressIndicator(), // Use LinearProgressIndicator for consistency
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text("Updating category..."), // Added text
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: !isLoading
                      ? () => Navigator.pop(context)
                      : null, // Disable Cancel button during loading
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final newName = nameController.text;
                          if (newName.isNotEmpty) {
                            setState(() => isLoading = true);
                            try {
                              await ProductDataService.updateProductCategory(
                                  category.productCategoryId, newName);
                              Navigator.of(context).pop(); // Close dialog
                              _fetchProductCategories(); // Refresh categories after updating
                              _showErrorSnackBar(
                                  "Category updated successfully");
                            } catch (e) {
                              _showErrorSnackBar('Error updating category: $e');
                            } finally {
                              setState(() => isLoading = false);
                            }
                          } else {
                            // ... (Error dialog for empty category name)
                          }
                        },
                  child:
                      isLoading ? const Text('Saving...') : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddDialog() {
    final TextEditingController nameController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing while loading
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: 'Category Name'),
                    enabled: !isLoading,
                  ),
                  if (isLoading) const LinearProgressIndicator(),
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Text("Adding category..."),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: !isLoading
                      ? () => Navigator.pop(context)
                      : null, // Disable Cancel button during loading
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final newName = nameController.text;
                          if (newName.isNotEmpty) {
                            setState(() => isLoading = true);
                            try {
                              await _addProductCategory(newName);
                              Navigator.of(context).pop(); // Close dialog
                              _showErrorSnackBar('Category added successfully');
                            } catch (e) {
                              _showErrorSnackBar('Error adding category: $e');
                            } finally {
                              setState(() => isLoading = false);
                            }
                          } else {
                            // ... (Error dialog for empty category name)
                          }
                        },
                  child:
                      isLoading ? const Text('Adding...') : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
