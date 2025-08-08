import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_theme_data.dart';
import '../widgets/custom_header.dart';
import '../widgets/image_banner.dart';
import '../widgets/bottom_buttons.dart';

class ScheduleScreen extends StatefulWidget {
  final String serviceTitle;
  final String serviceDescription;
  final String imagePath;
  final AppThemeData appColors;

  const ScheduleScreen({
    super.key,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.imagePath,
    required this.appColors,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  String? _selectedTime;
  final List<String> _availableTimes = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  List<Widget> _buildDaysGrid() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final daysInMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday;

    List<Widget> days = [];

    for (int i = 0; i < startWeekday - 1; i++) {
      days.add(const SizedBox());
    }

    for (int i = 1; i <= daysInMonth; i++) {
      final day = DateTime(_focusedDay.year, _focusedDay.month, i);
      final isSelected = _selectedDay != null &&
          day.day == _selectedDay!.day &&
          day.month == _selectedDay!.month &&
          day.year == _selectedDay!.year;
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
              color: isSelected
                  ? widget.appColors.primary
                  : (isToday ? widget.appColors.accent.withOpacity(0.2) : widget.appColors.background),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: isSelected ? widget.appColors.background : widget.appColors.primaryText,
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
      backgroundColor: widget.appColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomHeader(
          title: 'Agendamento',
          leading: IconButton(
            icon: Icon(Icons.close, color: widget.appColors.primaryText),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: const SizedBox.shrink(),
          appColors: widget.appColors, // ADICIONADO: Passa a paleta de cores para o CustomHeader
        ),
      ),
      body: ListView(
        children: [
          ImageBanner(
            imagePath: widget.imagePath,
            height: 250,
            gradientText: widget.serviceTitle,
            appColors: widget.appColors, // ADICIONADO: Passa a paleta de cores para o ImageBanner
          ),
          _buildScheduleContent(context),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: BottomButtons(
        text: 'Agendar agora',
        appColors: widget.appColors, // ADICIONADO: Passa a paleta de cores para o BottomButtons
        onPressed: () {
          if (_selectedDay != null && _selectedTime != null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: widget.appColors.background,
                  title: Text(
                    'Agendamento Confirmado!',
                    style: TextStyle(color: widget.appColors.primaryText),
                  ),
                  content: Text(
                    'Seu agendamento para ${DateFormat('dd/MM/yyyy', 'pt_BR').format(_selectedDay!)} às $_selectedTime foi realizado com sucesso. Aguardamos você!',
                    style: TextStyle(color: widget.appColors.secondaryText),
                  ),
                  actions: [
                    TextButton(
                      child: Text('OK', style: TextStyle(color: widget.appColors.primary)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Por favor, selecione a data e o horário.',
                  style: TextStyle(color: widget.appColors.background),
                ),
                backgroundColor: widget.appColors.error,
              ),
            );
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
                  color: widget.appColors.secondaryText,
                ),
          ),
          const SizedBox(height: 24),
          Text(
            'Datas disponíveis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: widget.appColors.primaryText,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 12),
          _buildCalendarSection(context),
          const SizedBox(height: 24),
          Text(
            'Horários disponíveis',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: widget.appColors.primaryText,
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
        color: widget.appColors.background,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: widget.appColors.shadowColor,
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
                icon: Icon(Icons.chevron_left, color: widget.appColors.primaryText),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
                  });
                },
              ),
              Text(
                '${DateFormat('MMMM', 'pt_BR').format(_focusedDay)} ${_focusedDay.year}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: widget.appColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: widget.appColors.primaryText),
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
              _buildWeekdayText('Seg'),
              _buildWeekdayText('Ter'),
              _buildWeekdayText('Qua'),
              _buildWeekdayText('Qui'),
              _buildWeekdayText('Sex'),
              _buildWeekdayText('Sáb'),
              _buildWeekdayText('Dom'),
            ],
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: widget.appColors.primaryText),
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
          color: isSelected ? widget.appColors.primary : widget.appColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? widget.appColors.primary : widget.appColors.borderColor,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? widget.appColors.background : widget.appColors.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}