import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class EventEditPage extends StatefulWidget {
  final dynamic event;

  const EventEditPage({super.key, required this.event});

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _feeController;
  late TextEditingController _maxParticipantsController;
  
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final event = widget.event;
    _titleController = TextEditingController(text: event['title']);
    _descriptionController = TextEditingController(text: event['description']);
    _locationController = TextEditingController(text: event['location']);
    _feeController = TextEditingController(text: event['fee'].toString());
    _maxParticipantsController = TextEditingController(text: event['max_participants'].toString());
    
    DateTime initialDate = DateTime.tryParse(event['playing_date']) ?? DateTime.now();
    _selectedDate = initialDate;
    _selectedTime = TimeOfDay(hour: initialDate.hour, minute: initialDate.minute);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _feeController.dispose();
    _maxParticipantsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();
      
      final playingDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final response = await request.postJson(
        '${dotenv.env["BACKEND_URL"]}/community-events/${widget.event['id_event']}/edit-flutter/',
        jsonEncode({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'playing_date': playingDateTime.toIso8601String(),
          'location': _locationController.text,
          'fee': _feeController.text,
          'max_participants': _maxParticipantsController.text,
        }),
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event berhasil diperbarui!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Gagal memperbarui event')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Judul Event', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Judul wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Deskripsi', border: OutlineInputBorder()),
                      maxLines: 3,
                      validator: (v) => v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            title: const Text('Tanggal'),
                            subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                            trailing: const Icon(Icons.calendar_today),
                            onTap: _pickDate,
                            tileColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ListTile(
                            title: const Text('Waktu'),
                            subtitle: Text(_selectedTime.format(context)),
                            trailing: const Icon(Icons.access_time),
                            onTap: _pickTime,
                            tileColor: Colors.grey[100],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(labelText: 'Lokasi', border: OutlineInputBorder()),
                      validator: (v) => v == null || v.isEmpty ? 'Lokasi wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _feeController,
                            decoration: const InputDecoration(labelText: 'Fee (Rp)', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Fee wajib diisi' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _maxParticipantsController,
                            decoration: const InputDecoration(labelText: 'Max Peserta', border: OutlineInputBorder()),
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Simpan Perubahan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
