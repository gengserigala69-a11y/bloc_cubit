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



class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // LOGIN
        RepositoryProvider(
          create: (_) => LoginRepository(httpClient: http.Client()),
        ),

        // REGISTER
        RepositoryProvider(
          create: (_) => RegisterRepository(httpClient: http.Client()),
        ),

        // PROFILE
        RepositoryProvider(
          create: (_) => ProfileRepository(),
        ),

        // DELETE ACCOUNT
        RepositoryProvider(
          create: (_) =>
              DeleteAccountRepository(httpClient: http.Client()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // COUNTER
          BlocProvider(
            create: (_) => CounterCubit(),
          ),

          // POSTS
          BlocProvider(
            create: (_) =>
                PostBloc(httpClient: http.Client())..add(PostFetched()),
          ),

          // THEME
          BlocProvider(
            create: (_) => ThemeCubit(),
          ),

          // LOGIN
          BlocProvider(
            create: (context) =>
                LoginBloc(loginRepository: context.read<LoginRepository>()),
          ),

          // REGISTER
          BlocProvider(
            create: (context) => RegisterBloc(
                registerRepository: context.read<RegisterRepository>()),
          ),

          // PROFILE
          BlocProvider(
            create: (context) =>
                ProfileBloc(profileRepository: context.read<ProfileRepository>()),
          ),

          // DELETE ACCOUNT
          BlocProvider(
            create: (context) => DeleteAccountBloc(
                deleteAccountRepository:
                    context.read<DeleteAccountRepository>()),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Bloc Cubit App',
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              themeMode: themeMode,
              initialRoute: '/login',
              routes: {
                // LOGIN
                '/login': (_) => const LoginPage(),

                // REGISTER
                '/register': (_) => const RegisterPage(),

                // HOME
                '/home': (_) => const HomePage(),

                // COUNTER
                '/counter': (_) => const CounterPage(),

                // POSTS
                '/posts': (_) => const PostsPage(),

                // PROFILE
                '/profile': (_) => const ProfileView(),

                // UPDATE PROFILE
                '/update-profile': (_) => const ProfileEdit(),

                // DELETE ACCOUNT
                '/delete-account': (_) => const DeleteAccountView(),

                // CATEGORY CRUD
                '/category': (_) => const CategoryView(),
                '/add-category': (_) => const AddCategoryPage(),
                '/edit-category': (_) => const EditCategoryPage(),


              },
            );
          },
        ),
      ),
    );
  }
}