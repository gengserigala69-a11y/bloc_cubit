import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../models/product_model.dart';
import 'package:bloc_cubit/category/models/category_model.dart';
import 'package:bloc_cubit/category/repository/category_repository.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _stockController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _available = true;
  DateTime? _expiredDate;
  CategoryModel? _selectedCategory;
  List<CategoryModel> _categories = [];
  bool _loadingCategories = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final repo = CategoryRepository();
      final data = await repo.getCategories();
      setState(() {
        _categories = data;
        _loadingCategories = false;
      });
    } catch (_) {
      setState(() => _loadingCategories = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiredDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 10),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFD32F2F),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _expiredDate = picked);
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(),
      child: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductCreateSuccess) {
            Navigator.pop(context, true);
          } else if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is ProductLoading;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tambah Produk',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Nama Produk
                    _buildLabel('Nama produk', required: true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _nameController,
                      hint: 'Masukkan nama produk',
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    // Deskripsi
                    _buildLabel('Deskripsi', required: true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _descController,
                      hint: 'Masukkan deskripsi',
                      maxLines: 4,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    // Pilih Kategori
                    _buildLabel('Pilih Kategori', required: true),
                    const SizedBox(height: 8),
                    _buildDropdown(),
                    const SizedBox(height: 20),

                    // Stok
                    _buildLabel('Stok', required: true),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: _stockController,
                      hint: 'Masukkan jumlah stok',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Stok wajib diisi';
                        if (int.tryParse(v) == null) return 'Stok harus angka';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Expired Date
                    _buildLabel('Tanggal Kadaluarsa', required: true),
                    const SizedBox(height: 8),
                    _buildDatePicker(),
                    const SizedBox(height: 20),

                    // Available toggle
                    _buildLabel('Available', required: true),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Switch(
                          value: _available,
                          onChanged: (v) => setState(() => _available = v),
                          activeColor: const Color(0xFF4CAF50),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Produk tersedia untuk dijual',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedCategory == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pilih kategori terlebih dahulu'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  if (_expiredDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Pilih tanggal kadaluarsa'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  context.read<ProductBloc>().add(
                                        ProductCreate(
                                          product: ProductModel(
                                            id: 0,
                                            name: _nameController.text.trim(),
                                            description: _descController.text.trim(),
                                            stock: int.parse(_stockController.text.trim()),
                                            available: _available,
                                            expired:
                                                '${_formatDate(_expiredDate!)}T00:00:00.000Z',
                                            idCategory: _selectedCategory!.id,
                                          ),
                                        ),
                                      );
                                }
                              },
                        icon: isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 20),
                        label: const Text(
                          'Tambah Produk',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD32F2F),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          disabledBackgroundColor:
                              const Color(0xFFD32F2F).withOpacity(0.6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        if (required)
          const Text(' *', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 14)),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD32F2F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD32F2F)),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    if (_loadingCategories) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Center(
          child: SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
                color: Color(0xFFD32F2F), strokeWidth: 2),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CategoryModel>(
          isExpanded: true,
          value: _selectedCategory,
          hint: const Text(
            'Pilih Kategori',
            style: TextStyle(color: Colors.black38, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: Colors.black54),
          items: _categories
              .map(
                (cat) => DropdownMenuItem(
                  value: cat,
                  child: Text(cat.name,
                      style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectedCategory = v),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded,
                size: 18, color: Colors.black38),
            const SizedBox(width: 10),
            Text(
              _expiredDate != null
                  ? _formatDate(_expiredDate!)
                  : 'Pilih tanggal kadaluarsa',
              style: TextStyle(
                fontSize: 14,
                color:
                    _expiredDate != null ? Colors.black87 : Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}