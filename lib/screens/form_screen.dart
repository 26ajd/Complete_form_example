import 'package:flutter/material.dart';
import 'package:complete_form_example/models/form_data_model.dart';
import 'package:complete_form_example/screens/view_screen.dart';
import 'package:complete_form_example/services/hive_service.dart';
import 'package:complete_form_example/widgets/custom_text_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _hiveService = HiveService();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();

  String? _gender;
  String? _country;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  double _rating = 1;
  double _percentage = 50;
  RangeValues _priceRange = const RangeValues(10, 100);
  bool _notifications = false;
  bool _agreePolicy = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    super.dispose();
  }

  Widget formSectionTitle(
    String title, {
    Color color = Colors.blue,
    IconData icon = Icons.calendar_today,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState == null) return;

    if (_formKey.currentState!.validate()) {
      final formData = FormDataModel(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        password: _passCtrl.text,
        phone: _phoneCtrl.text,
        age: _ageCtrl.text,
        gender: _gender,
        country: _country,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime?.format(context),
        rating: _rating,
        percentage: _percentage,
        priceRangeStart: _priceRange.start,
        priceRangeEnd: _priceRange.end,
        notifications: _notifications,
        agreePolicy: _agreePolicy,
      );

      debugPrint('Submitting form: ${formData.toString()}');

      _hiveService.addData(formData).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data Saved Successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        debugPrint('Data Saved Successfully: ${formData.toString()}');
        FocusScope.of(context).unfocus();
        _formKey.currentState?.reset();
        _nameCtrl.clear();
        _emailCtrl.clear();
        _passCtrl.clear();
        _phoneCtrl.clear();
        _ageCtrl.clear();
        setState(() {
          _gender = null;
          _country = null;
          _selectedDate = null;
          _selectedTime = null;
          _rating = 1;
          _percentage = 50;
          _priceRange = const RangeValues(10, 100);
          _notifications = false;
          _agreePolicy = false;
        });
      });
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _selectedTime = t);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        title: const Text("Complete Form"),
        actions: [
          IconButton(
            icon: const Icon(Icons.data_usage),
            tooltip: "View Saved Data",
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ViewScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formSectionTitle(
                'Personal Information',
                color: Colors.green,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _nameCtrl,
                labelText: "Full Name",
                icon: Icons.person,
                validator: (v) => (v?.isEmpty ?? true) ? "Required" : null,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _emailCtrl,
                labelText: "Email",
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    !(v?.contains('@') ?? false) ? "Invalid Email" : null,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _passCtrl,
                labelText: "Password",
                icon: Icons.lock,
                obscureText: true,
                validator: (v) => (v?.length ?? 0) < 6 ? "Min 6 chars" : null,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _phoneCtrl,
                labelText: "Phone",
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (v) => (v?.length ?? 0) < 7 ? "Invalid Phone" : null,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: _ageCtrl,
                labelText: "Age",
                icon: Icons.cake,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),

              formSectionTitle(
                'Additional Information',
                color: Colors.purple,
                icon: Icons.info_outline,
              ),
              const SizedBox(height: 16),

              const Text(
                "Gender:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: const InputDecoration(
                  hintText: "Select Gender",
                  prefixIcon: Icon(
                    Icons.transgender_outlined,
                    color: Colors.greenAccent,
                  ),
                  border: OutlineInputBorder(),
                ),
                items: ["Male", "Female", "Other"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) => v == null ? 'Required' : null,
              ),

              const SizedBox(height: 16),

              const Text(
                "Country:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButtonFormField<String>(
                value: _country,
                decoration: const InputDecoration(
                  hintText: "Select Country",
                  prefixIcon: Icon(
                    Icons.location_on_sharp,
                    color: Colors.greenAccent,
                  ),
                  border: OutlineInputBorder(),
                ),
                items: ["Yemen", "Saudi Arabia", "Egypt", "USA"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _country = v),
                validator: (v) => v == null ? 'Required' : null,
              ),

              const SizedBox(height: 24),

              formSectionTitle(
                'Date & Time',
                color: Colors.blue,
                icon: Icons.calendar_today,
              ),
              const SizedBox(height: 16),

              Column(
                children: [
                  FormField<DateTime?>(
                    initialValue: _selectedDate,
                    validator: (v) => v == null ? 'Required' : null,
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.value == null
                                        ? "Select Date"
                                        : "Date: ${state.value!.toLocal().toString().split(' ')[0]}",
                                    style: TextStyle(
                                      color: state.value == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final d = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2100),
                                  );
                                  if (d != null) {
                                    state.didChange(d);
                                    setState(() => _selectedDate = d);
                                  }
                                },
                                icon: const Icon(Icons.date_range),
                                label: const Text("Pick Date"),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 6),
                            child: Text(
                              state.errorText ?? '',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  FormField<TimeOfDay?>(
                    initialValue: _selectedTime,
                    validator: (v) => v == null ? 'Required' : null,
                    builder: (state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.value == null
                                        ? "Select Time"
                                        : "Time: ${state.value!.format(context)}",
                                    style: TextStyle(
                                      color: state.value == null
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final t = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (t != null) {
                                    state.didChange(t);
                                    setState(() => _selectedTime = t);
                                  }
                                },
                                icon: const Icon(Icons.schedule),
                                label: const Text("Pick Time"),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(left: 12, top: 6),
                            child: Text(
                              state.errorText ?? '',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              formSectionTitle(
                'Preferences & Settings',
                color: Colors.orange,
                icon: Icons.settings,
              ),
              const SizedBox(height: 16),

              Text("Rating: ${_rating.toStringAsFixed(1)}"),
              Slider(
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toStringAsFixed(1),
                value: _rating,
                onChanged: (v) => setState(() => _rating = v),
              ),

              const SizedBox(height: 16),

              Text("Percentage: ${_percentage.toInt()}%"),
              Slider(
                min: 0,
                max: 100,
                divisions: 100,
                label: "${_percentage.toInt()}%",
                value: _percentage,
                onChanged: (v) => setState(() => _percentage = v),
              ),

              const SizedBox(height: 16),

              Text(
                "Price Range: ${_priceRange.start.toInt()} - ${_priceRange.end.toInt()}",
              ),
              RangeSlider(
                min: 0,
                max: 1000,
                divisions: 100,
                labels: RangeLabels(
                  "${_priceRange.start.toInt()}",
                  "${_priceRange.end.toInt()}",
                ),
                values: _priceRange,
                onChanged: (v) => setState(() => _priceRange = v),
              ),

              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text("Enable Notifications"),
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
              ),

              FormField<bool>(
                initialValue: _agreePolicy,
                validator: (v) =>
                    v == true ? null : 'You must agree to continue',
                builder: (state) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      title: const Text("I agree to the terms and policy"),
                      value: state.value,
                      onChanged: (v) {
                        final newVal = v ?? false;
                        state.didChange(newVal);
                        setState(() => _agreePolicy = newVal);
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 6),
                        child: Text(
                          state.errorText ?? '',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "Save Data",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
