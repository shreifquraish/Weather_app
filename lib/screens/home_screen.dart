import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_forecast/models/weather_model.dart';
import 'package:weather_forecast/screens/login_screen.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../cubits/weather_cubit/weather_cubit.dart';
import '../cubits/weather_cubit/weather_state.dart';
import '../services/api_service.dart';
import '../services/local_storage_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/favorite_city_card.dart';
import '../core/utils/helpers.dart';
import '../models/city_model.dart';
import 'forecast_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService _apiService;
  late LocalStorageService _storageService;
  late WeatherCubit _weatherCubit;
  
  List<CityModel> _favoriteCities = [];
  String _currentCity = 'Cairo';

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _storageService = LocalStorageService();
    _weatherCubit = WeatherCubit(apiService: _apiService);
    
    _loadFavoriteCities();
    _weatherCubit.getWeatherAndForecast(_currentCity);
  }

  Future<void> _loadFavoriteCities() async {
    final cities = await _storageService.getFavoriteCities();
    setState(() {
      _favoriteCities = cities;
    });
  }

  Future<void> _addFavoriteCity() async {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة مدينة مفضلة'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'اسم المدينة',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final cityName = controller.text.trim();
              if (cityName.isNotEmpty) {
                await _storageService.addFavoriteCity(cityName);
                await _loadFavoriteCities();
                Navigator.pop(context);
                Helpers.showSnackBar(context, 'تمت إضافة $cityName');
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeFavoriteCity(String cityName) async {
    await _storageService.removeFavoriteCity(cityName);
    await _loadFavoriteCities();
    Helpers.showSnackBar(context, 'تم حذف $cityName');
  }

  void _logout() async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('تسجيل الخروج'),
      content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
            await context.read<AuthCubit>().logout();

            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('تسجيل خروج'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _weatherCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Weather Forecast'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WeatherAndForecastLoaded) {
              return _buildBody(state.weather);
            } else if (state is WeatherError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _weatherCubit.getWeatherAndForecast(_currentCity);
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('مرحباً بك'));
          },
        ),
      ),
    );
  }

  Widget _buildBody(WeatherModel weather) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          WeatherCard(weather: weather),
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المدن المفضلة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _addFavoriteCity,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('إضافة مدينة'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          if (_favoriteCities.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'لا توجد مدن مفضلة\nاضغط على إضافة مدينة',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _favoriteCities.length,
              itemBuilder: (context, index) {
                final city = _favoriteCities[index];
                return FutureBuilder(
                  future: _apiService.getCurrentWeather(city.name),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final temp = snapshot.data!.temp;
                      return FavoriteCityCard(
                        cityName: city.name,
                        temp: temp.toInt(),
                        onTap: () {
                          setState(() {
                            _currentCity = city.name;
                          });
                          _weatherCubit.getWeatherAndForecast(city.name);
                        },
                        onDelete: () => _removeFavoriteCity(city.name),
                      );
                    } else if (snapshot.hasError) {
                      return FavoriteCityCard(
                        cityName: city.name,
                        temp: 0,
                        onTap: () {},
                        onDelete: () => _removeFavoriteCity(city.name),
                      );
                    }
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                );
              },
            ),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ForecastScreen(cityName: _currentCity),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('توقعات الأيام القادمة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}