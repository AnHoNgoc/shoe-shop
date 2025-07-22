import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_shop_flutter/components/text_home.dart';
import 'package:shoe_shop_flutter/constants/app_colors.dart';

import '../components/carousel.dart';
import '../components/category_list.dart';
import '../components/product_list.dart';
import '../components/search_bar_and_filter.dart';
import '../data/repository/product_repository.dart';
import '../data/source/product_source.dart';
import '../data/viewModel/category_view_model.dart';
import '../data/viewModel/product_view_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imageUrls = [
    'https://img.freepik.com/free-psd/new-collection-fashion-sale-web-banner-template_120329-1507.jpg',
    'https://w7.pngwing.com/pngs/861/818/png-transparent-shoe-shop-facebook-banner.png',
    'https://i.pinimg.com/736x/09/82/69/098269da6311c75108a953ba8e4758d0.jpg',
  ];

  int selectedIndex = 0;
  int currentPage = 1;
  String nameSearch = '';
  double? minPrice;
  double? maxPrice;

  late ProductViewModel _productViewModel;

  @override
  void initState() {
    super.initState();


    _productViewModel = ProductViewModel(
      repository: ProductRepositoryImpl(ProductSource()),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final categoryVM = context.read<CategoryViewModel>();
      categoryVM.loadCategories();
      _productViewModel.loadProductData(page: currentPage);
    });
  }

  @override
  void dispose() {

    _productViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                SearchBarAndFilter(
                  onSearch: (searchText, newMinPrice, newMaxPrice) {
                    setState(() {
                      nameSearch = searchText;
                      minPrice = newMinPrice;
                      maxPrice = newMaxPrice;
                    });
                    _productViewModel.loadProductData(
                      page: 1,
                      categoryId: selectedIndex + 1,
                      nameSearch: nameSearch,
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                    );
                  },
                ),
                SizedBox(height: 20.h),
                Carousel(imageUrls: imageUrls),
                SizedBox(height: 15.h),
                TextHome(text: "Category"),
                SizedBox(height: 10.h),
                Consumer<CategoryViewModel>(
                  builder: (context, viewModel, _) {
                    final categories = viewModel.categories;

                    if (categories == null || categories.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return CategoryList(
                      selectedIndex: selectedIndex,
                      onSelect: (index) {
                        setState(() {
                          selectedIndex = index;
                          nameSearch = '';    // Reset lại search
                          minPrice = null;    // Reset lại minPrice
                          maxPrice = null;    // Reset lại maxPrice
                          currentPage = 1;    // Reset lại page về 1
                        });
                        _productViewModel.loadProductData(
                          page: 1,
                          categoryId: index + 1,
                          nameSearch: '',
                          minPrice: null,
                          maxPrice: null,
                        );
                      },
                      categories: categories,
                    );
                  },
                ),
                SizedBox(height: 15.h),
                TextHome(text: "Product"),
                SizedBox(height: 10.h),
                ProductList(
                  productStream: _productViewModel.productStream.stream,
                  totalPagesStream: _productViewModel.totalPagesStream.stream,
                  currentPage: currentPage,
                  onPageChanged: (newPage) {
                    setState(() {
                      currentPage = newPage;
                    });
                    _productViewModel.loadProductData(
                      page: newPage,
                      categoryId:  selectedIndex+1,
                      nameSearch: nameSearch,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

