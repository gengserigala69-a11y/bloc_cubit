import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// THEME
import 'package:bloc_cubit/core/theme/theme_cubit.dart';

// COUNTER
import 'package:bloc_cubit/counter/cubit/counter_cubit.dart';
import 'package:bloc_cubit/counter/view/counter_page.dart';

// POSTS
import 'package:bloc_cubit/posts/bloc/post_bloc.dart';
import 'package:bloc_cubit/posts/bloc/post_event.dart';
import 'package:bloc_cubit/posts/view/posts_page.dart';

// HOME
import 'package:bloc_cubit/home/view/home_page.dart';

// LOGIN
import 'package:bloc_cubit/login/repository/login_repository.dart';
import 'package:bloc_cubit/login/bloc/login_bloc.dart';
import 'package:bloc_cubit/login/view/login_page.dart';

// REGISTER
import 'package:bloc_cubit/register/repository/register_repository.dart';
import 'package:bloc_cubit/register/bloc/register_bloc.dart';
import 'package:bloc_cubit/register/views/register_page.dart';

// PROFILE
import 'package:bloc_cubit/profile/repository/profile_repository.dart';
import 'package:bloc_cubit/profile/bloc/profile_bloc.dart';
import 'package:bloc_cubit/profile/view/profile_view.dart';
import 'package:bloc_cubit/profile/view/profile_edit.dart';

// DELETE ACCOUNT
import 'package:bloc_cubit/delete_account/repository/delete_account_repository.dart';
import 'package:bloc_cubit/delete_account/bloc/delete_account_bloc.dart';
import 'package:bloc_cubit/delete_account/view/delete_account_view.dart';

// CATEGORY CRUD
import 'package:bloc_cubit/category/view/category_view.dart';
import 'package:bloc_cubit/category/view/add_category_page.dart';
import 'package:bloc_cubit/category/view/edit_category_page.dart';

// PRODUCT CRUD
import 'package:bloc_cubit/product/view/product_view.dart';
import 'package:bloc_cubit/product/view/add_product_page.dart';
import 'package:bloc_cubit/product/view/edit_product_page.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => LoginRepository(httpClient: http.Client())),
        RepositoryProvider(create: (_) => RegisterRepository(httpClient: http.Client())),
        RepositoryProvider(create: (_) => ProfileRepository()),
        RepositoryProvider(create: (_) => DeleteAccountRepository(httpClient: http.Client())),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CounterCubit()),
          BlocProvider(create: (_) => PostBloc(httpClient: http.Client())..add(PostFetched())),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (context) => LoginBloc(loginRepository: context.read<LoginRepository>())),
          BlocProvider(create: (context) => RegisterBloc(registerRepository: context.read<RegisterRepository>())),
          BlocProvider(create: (context) => ProfileBloc(profileRepository: context.read<ProfileRepository>())),
          BlocProvider(create: (context) => DeleteAccountBloc(deleteAccountRepository: context.read<DeleteAccountRepository>())),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Bloc Cubit App',
              theme: ThemeData.light().copyWith(
                textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Poppins'),
              ),
              darkTheme: ThemeData.dark().copyWith(
                textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Poppins'),
              ),
              themeMode: themeMode,
              initialRoute: '/login',
              routes: {
                '/login': (_) => const LoginPage(),
                '/register': (_) => const RegisterPage(),
                '/home': (_) => const HomePage(),
                '/counter': (_) => const CounterPage(),
                '/posts': (_) => const PostsPage(),
                '/profile': (_) => const ProfileView(),
                '/update-profile': (_) => const ProfileEdit(),
                '/delete-account': (_) => const DeleteAccountView(),
                '/category': (_) => const CategoryView(),
                '/add-category': (_) => const AddCategoryPage(),
                '/edit-category': (_) => const EditCategoryPage(),
                '/product': (_) => const ProductView(),
                '/add-product': (_) => const AddProductPage(),
                '/edit-product': (_) => const EditProductPage(),
              },
            );
          },
        ),
      ),
    );
  }
}