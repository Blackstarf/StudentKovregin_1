import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Умный дом',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const SmartHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SmartHomePage extends StatefulWidget {
  const SmartHomePage({super.key});

  @override
  State<SmartHomePage> createState() => _SmartHomePageState();
}

class _SmartHomePageState extends State<SmartHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Состояния для гостиной
  final Map<String, dynamic> _livingRoom = {
    'light': false,
    'thermostat': true,
    'temperature': 22.0,
    'tv': false,
    'blinds': true,
  };

  // Состояния для кухни
  final Map<String, dynamic> _kitchen = {
    'light': false,
    'thermostat': false,
    'temperature': 20.0,
    'fridge': true,
    'coffee': false,
  };

  // Состояния для спальни
  final Map<String, dynamic> _bedroom = {
    'light': false,
    'thermostat': true,
    'temperature': 21.0,
    'alarm': false,
    'blinds': false,
  };

  // Состояния для ванной
  final Map<String, dynamic> _bathroom = {
    'light': false,
    'heating': true,
    'temperature': 24.0,
    'water': false,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleDevice(String room, String device) {
    setState(() {
      if (room == 'livingRoom') {
        _livingRoom[device] = !_livingRoom[device];
      } else if (room == 'kitchen') {
        _kitchen[device] = !_kitchen[device];
      } else if (room == 'bedroom') {
        _bedroom[device] = !_bedroom[device];
      } else if (room == 'bathroom') {
        _bathroom[device] = !_bathroom[device];
      }
    });
  }

  void _changeTemperature(String room, double value) {
    setState(() {
      if (room == 'livingRoom') {
        _livingRoom['temperature'] = value;
      } else if (room == 'kitchen') {
        _kitchen['temperature'] = value;
      } else if (room == 'bedroom') {
        _bedroom['temperature'] = value;
      } else if (room == 'bathroom') {
        _bathroom['temperature'] = value;
      }
    });
  }

  Widget _buildRoomTab(String roomName, Map<String, dynamic> roomState) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      childAspectRatio: 0.9,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        // Освещение
        _DeviceCard(
          icon: Icons.lightbulb,
          label: 'Освещение',
          isActive: roomState['light'],
          onTap: () => _toggleDevice(roomName, 'light'),
          child: Column(
            children: [
              Icon(
                roomState['light'] ? Icons.power : Icons.power_off,
                size: 30,
                color: roomState['light'] ? Colors.yellow : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                roomState['light'] ? 'ВКЛ' : 'ВЫКЛ',
                style: TextStyle(
                  color: roomState['light'] ? Colors.yellow : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Термостат
        _DeviceCard(
          icon: Icons.thermostat,
          label: 'Термостат',
          isActive: roomState['thermostat'] ?? false,
          onTap: roomName != 'bathroom' 
              ? () => _toggleDevice(roomName, 'thermostat') 
              : null,
          child: Column(
            children: [
              Text(
                '${roomState['temperature'].toStringAsFixed(1)}°C',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (roomName != 'bathroom')
                Slider(
                  value: roomState['temperature'].toDouble(),
                  min: 15,
                  max: 30,
                  divisions: 15,
                  onChanged: roomState['thermostat'] 
                      ? (value) => _changeTemperature(roomName, value) 
                      : null,
                ),
            ],
          ),
        ),

        // Уникальные устройства для каждой комнаты
        if (roomName == 'livingRoom') ...[
          _DeviceCard(
            icon: Icons.tv,
            label: 'Телевизор',
            isActive: roomState['tv'],
            onTap: () => _toggleDevice(roomName, 'tv'),
            child: Column(
              children: [
                Icon(
                  roomState['tv'] ? Icons.tv : Icons.tv_off,
                  size: 30,
                  color: roomState['tv'] ? Colors.blue : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['tv'] ? 'ВКЛ' : 'ВЫКЛ',
                  style: TextStyle(
                    color: roomState['tv'] ? Colors.blue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _DeviceCard(
            icon: Icons.blinds,
            label: 'Шторы',
            isActive: roomState['blinds'],
            onTap: () => _toggleDevice(roomName, 'blinds'),
            child: Column(
              children: [
                Icon(
                  roomState['blinds'] ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 30,
                  color: roomState['blinds'] ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['blinds'] ? 'ОТКР' : 'ЗАКР',
                  style: TextStyle(
                    color: roomState['blinds'] ? Colors.green : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],

        if (roomName == 'kitchen') ...[
          _DeviceCard(
            icon: Icons.kitchen,
            label: 'Холодильник',
            isActive: roomState['fridge'],
            onTap: () => _toggleDevice(roomName, 'fridge'),
            child: Column(
              children: [
                Icon(
                  roomState['fridge'] ? Icons.ac_unit : Icons.ac_unit_outlined,
                  size: 30,
                  color: roomState['fridge'] ? Colors.lightBlue : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['fridge'] ? 'РАБОТАЕТ' : 'ВЫКЛ',
                  style: TextStyle(
                    color: roomState['fridge'] ? Colors.lightBlue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _DeviceCard(
            icon: Icons.coffee,
            label: 'Кофеварка',
            isActive: roomState['coffee'],
            onTap: () => _toggleDevice(roomName, 'coffee'),
            child: Column(
              children: [
                Icon(
                  roomState['coffee'] ? Icons.coffee : Icons.coffee_outlined,
                  size: 30,
                  color: roomState['coffee'] ? Colors.brown : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['coffee'] ? 'ВКЛ' : 'ВЫКЛ',
                  style: TextStyle(
                    color: roomState['coffee'] ? Colors.brown : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],

        if (roomName == 'bedroom') ...[
          _DeviceCard(
            icon: Icons.alarm,
            label: 'Будильник',
            isActive: roomState['alarm'],
            onTap: () => _toggleDevice(roomName, 'alarm'),
            child: Column(
              children: [
                Icon(
                  roomState['alarm'] ? Icons.alarm_on : Icons.alarm_off,
                  size: 30,
                  color: roomState['alarm'] ? Colors.orange : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['alarm'] ? 'ВКЛ' : 'ВЫКЛ',
                  style: TextStyle(
                    color: roomState['alarm'] ? Colors.orange : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _DeviceCard(
            icon: Icons.night_shelter,
            label: 'Ночной режим',
            isActive: !roomState['light'] && !roomState['blinds'],
            onTap: () {
              _toggleDevice(roomName, 'light');
              _toggleDevice(roomName, 'blinds');
            },
            child: Column(
              children: [
                Icon(
                  Icons.bedtime,
                  size: 30,
                  color: (!roomState['light'] && !roomState['blinds']) 
                      ? Colors.purple 
                      : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  'АКТИВИРОВАТЬ',
                  style: TextStyle(
                    color: (!roomState['light'] && !roomState['blinds']) 
                        ? Colors.purple 
                        : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],

        if (roomName == 'bathroom') ...[
          _DeviceCard(
            icon: Icons.heat_pump,
            label: 'Подогрев пола',
            isActive: roomState['heating'],
            onTap: () => _toggleDevice(roomName, 'heating'),
            child: Column(
              children: [
                Icon(
                  roomState['heating'] ? Icons.heat_pump : Icons.heat_pump_outlined,
                  size: 30,
                  color: roomState['heating'] ? Colors.red : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['heating'] ? 'ВКЛ' : 'ВЫКЛ',
                  style: TextStyle(
                    color: roomState['heating'] ? Colors.red : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _DeviceCard(
            icon: Icons.water_drop,
            label: 'Вода',
            isActive: roomState['water'],
            onTap: () => _toggleDevice(roomName, 'water'),
            child: Column(
              children: [
                Icon(
                  roomState['water'] ? Icons.water : Icons.water_drop_outlined,
                  size: 30,
                  color: roomState['water'] ? Colors.lightBlue : Colors.grey,
                ),
                const SizedBox(height: 8),
                Text(
                  roomState['water'] ? 'ВКЛ' : 'ВЫКЛ',
                  style: TextStyle(
                    color: roomState['water'] ? Colors.lightBlue : Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Умный дом'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.living), text: 'Гостиная'),
            Tab(icon: Icon(Icons.kitchen), text: 'Кухня'),
            Tab(icon: Icon(Icons.bed), text: 'Спальня'),
            Tab(icon: Icon(Icons.bathtub), text: 'Ванная'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRoomTab('livingRoom', _livingRoom),
          _buildRoomTab('kitchen', _kitchen),
          _buildRoomTab('bedroom', _bedroom),
          _buildRoomTab('bathroom', _bathroom),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Действие для кнопки
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final Widget child;

  const _DeviceCard({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: isActive ? Colors.blueGrey[800] : Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(icon, size: 36, color: isActive ? Colors.white : Colors.grey),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.white : Colors.grey,
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}