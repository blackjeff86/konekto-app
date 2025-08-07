import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import '../widgets/bottom_buttons.dart';

class ScheduleScreen extends StatefulWidget {
  final String serviceTitle;
  final String serviceDescription;
  final String imagePath;

  const ScheduleScreen({
    super.key,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.imagePath,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  String? _selectedTime;
  final List<String> _availableTimes = [
    '09:00', '10:00', '11:00', '12:00', '13:00',
    '14:00', '15:00', '16:00', '17:00', '18:00',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  // Novo método para construir a grade de dias
  List<Widget> _buildDaysGrid() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday;

    List<Widget> days = [];

    // Adiciona placeholders para os dias da semana anteriores ao primeiro dia do mês
    for (int i = 0; i < startWeekday - 1; i++) {
      days.add(const SizedBox());
    }

    // Adiciona os dias do mês
    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(_focusedDay.year, _focusedDay.month, i);
      final isSelected = _selectedDay != null && day.day == _selectedDay!.day && day.month == _selectedDay!.month && day.year == _selectedDay!.year;
      final isToday = day.day == now.day && day.month == now.month && day.year == now.year;

      days.add(
        InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedDay = null;
              } else {
                _selectedDay = day;
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : (isToday ? AppColors.accent.withOpacity(0.2) : AppColors.background),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primaryText,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomHeader(
          title: 'Agendamento',
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.primaryText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: const SizedBox.shrink(),
        ),
      ),
      body: ListView(
        children: [
          ImageBanner(
            imagePath: widget.imagePath,
            height: 250,
            gradientText: widget.serviceTitle,
          ),
          _buildScheduleContent(context),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: BottomButtons(
        text: 'Agendar agora',
        onPressed: () {
          if (_selectedDay != null && _selectedTime != null) {
            debugPrint('Serviço ${widget.serviceTitle} agendado para o dia $_selectedDay às $_selectedTime');
          } else {
            debugPrint('Por favor, selecione um dia e um horário.');
          }
        },
      ),
    );
  }

  Widget _buildScheduleContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            widget.serviceDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Datas disponíveis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildCalendarSection(context),
          const SizedBox(height: 24),
          Text(
            'Horários disponíveis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildTimeSlotsSection(),
        ],
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.primaryText),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                  });
                },
              ),
              Text(
                '${DateFormat('MMMM', 'pt_BR').format(_focusedDay)} ${_focusedDay.year}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.primaryText),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeekdayText('Seg'), _buildWeekdayText('Ter'), _buildWeekdayText('Qua'),
              _buildWeekdayText('Qui'), _buildWeekdayText('Sex'), _buildWeekdayText('Sáb'),
              _buildWeekdayText('Dom'),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // Desativa a rolagem da grade
            crossAxisCount: 7,
            children: _buildDaysGrid(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeekdayText(String text) {
    return SizedBox(
      width: 32,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTimeSlotsSection() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _availableTimes.map((time) {
        final bool isSelected = _selectedTime == time;
        return _buildTimeChip(time, isSelected);
      }).toList(),
    );
  }

  Widget _buildTimeChip(String time, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          if (_selectedTime == time) {
            _selectedTime = null;
          } else {
            _selectedTime = time;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderColor,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}