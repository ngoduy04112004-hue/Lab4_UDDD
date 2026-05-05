import 'package:flutter/material.dart';

import '../controllers/crud_services.dart';

class UpdateContact extends StatefulWidget {
  final String docID;
  final String name;
  final String phone;
  final String email;

  const UpdateContact({
    super.key,
    required this.docID,
    required this.name,
    required this.phone,
    required this.email,
  });

  @override
  State<UpdateContact> createState() => _UpdateContactState();
}

class _UpdateContactState extends State<UpdateContact> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    emailController = TextEditingController(text: widget.email);
  }

  Future<void> updateContact() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    await CRUDService().updateContact(
      nameController.text.trim(),
      phoneController.text.trim(),
      emailController.text.trim(),
      widget.docID,
    );

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact Updated")),
    );

    Navigator.pop(context);
  }

  Future<void> deleteContact() async {
    setState(() {
      isLoading = true;
    });

    await CRUDService().deleteContact(widget.docID);

    setState(() {
      isLoading = false;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Contact Deleted")),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff7f3),
      appBar: AppBar(
        title: const Text("Update Contact"),
        backgroundColor: const Color(0xfffff7f3),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Phone cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email cannot be empty";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 18),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : updateContact,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Update"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: isLoading ? null : deleteContact,
                  child: const Text("Delete"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}