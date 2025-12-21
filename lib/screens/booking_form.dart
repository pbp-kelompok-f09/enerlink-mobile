import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/venue_service.dart';
import '../models/venue.dart';

class BookingFormPage extends StatefulWidget {
  final String venueId;

  const BookingFormPage({super.key, required this.venueId});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  Future<Venue>? _venueFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadVenue();
  }

  void _loadVenue() {
    setState(() {
      _venueFuture = VenueService.getVenueDetail(widget.venueId);
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
        if (_endTime != null && _endTime!.hour <= _startTime!.hour) {
          _endTime = null;
        }
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          _endTime ??
          TimeOfDay(
            hour: _startTime != null
                ? (_startTime!.hour + 1)
                : TimeOfDay.now().hour + 1,
            minute: 0,
          ),
    );
    if (picked != null) {
      if (_startTime != null && picked.hour <= _startTime!.hour) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('End time must be after start time'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final bookingDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final startTimeStr =
          '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}:00';
      final endTimeStr =
          '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}:00';

      await VenueService.createBooking(
        venueId: widget.venueId,
        bookingDate: bookingDate,
        startTime: startTimeStr,
        endTime: endTimeStr,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Booking created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Book Venue',
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0D47A1)),
      ),
      body: FutureBuilder<Venue>(
        future: _venueFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Error loading venue:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Venue not found."));
          } else {
            final venue = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Venue Info Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              venue.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Rp ${venue.sessionPrice.toStringAsFixed(0)}/hour',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Date Picker
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Booking Date',
                        hintText: _selectedDate == null
                            ? 'Select date'
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        prefixIcon: const Icon(Icons.calendar_today),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: _selectDate,
                      validator: (value) {
                        if (_selectedDate == null) {
                          return 'Please select a date';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Start Time Picker
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Start Time',
                        hintText: _startTime == null
                            ? 'Select start time'
                            : _startTime!.format(context),
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: _selectStartTime,
                      validator: (value) {
                        if (_startTime == null) {
                          return 'Please select start time';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // End Time Picker
                    TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'End Time',
                        hintText: _endTime == null
                            ? 'Select end time'
                            : _endTime!.format(context),
                        prefixIcon: const Icon(Icons.access_time),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onTap: _selectEndTime,
                      validator: (value) {
                        if (_endTime == null) {
                          return 'Please select end time';
                        }
                        if (_startTime != null &&
                            _endTime!.hour <= _startTime!.hour) {
                          return 'End time must be after start time';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Price Calculation
                    if (_selectedDate != null &&
                        _startTime != null &&
                        _endTime != null)
                      Card(
                        color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Estimated Price',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              FutureBuilder<double>(
                                future: _calculatePrice(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      'Rp ${snapshot.data!.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    );
                                  }
                                  return const Text('Calculating...');
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                'Confirm Booking',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<double> _calculatePrice() async {
    if (_selectedDate == null ||
        _startTime == null ||
        _endTime == null ||
        _venueFuture == null) {
      return 0.0;
    }

    try {
      final venue = await _venueFuture!;
      final start = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _startTime!.hour,
        _startTime!.minute,
      );
      final end = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _endTime!.hour,
        _endTime!.minute,
      );
      final duration = end.difference(start);
      final hours = duration.inMinutes / 60.0;
      return venue.sessionPrice * hours;
    } catch (e) {
      return 0.0;
    }
  }
}
