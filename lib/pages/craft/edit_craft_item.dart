import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CraftEdit extends StatefulWidget {

  const CraftEdit({required this.craftUser, super.key});
  final CraftModel craftUser;

  @override
  State<CraftEdit> createState() => _CraftEditState();
}

class _CraftEditState extends State<CraftEdit> {
  dynamic _image;
  final picker = ImagePicker();
  final craftKey = GlobalKey<FormState>();

  TextEditingController craftID = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  Future chooseImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => _image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future chooseImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() => _image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future updateImage() async {
    final uri = Uri.parse('http://$iPAddress/Hope/admin_edit_craft_item.php');
    final request = http.MultipartRequest('POST', uri);
    request.fields['id'] = widget.craftUser.id;
    request.fields['price'] = price.text;
    request.fields['craft_id'] = craftID.text;
    request.fields['name'] = name.text;
    request.fields['description'] = description.text;
    print(request.fields['name']);
    if (_image != null) {
      final pic = await http.MultipartFile.fromPath('image', _image.path);
      print('**********************');
      print(_image);
      request.files.add(pic);
    }
    final response = await request.send();
    print(response);

    if (response.statusCode == 200) {
      print('Image Uploded');
      price.clear();
      name.clear();
      craftID.clear();
      description.clear();
      final snackBar = SnackBar(
        content: const Text('Updated Successfully!'),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }

  @override
  void initState() {
    name = TextEditingController(text: widget.craftUser.name);
    price = TextEditingController(text: widget.craftUser.price);
    craftID = TextEditingController(text: widget.craftUser.craftID);
    description = TextEditingController(text: widget.craftUser.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'EDIT CRAFT ITEM',
        ),
      ),
      body: Form(
        key: craftKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TFF(
                hintText: 'Craft ID',
                controller: craftID,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Craft ID cannot be empty';
                  }
                },
              ),
              TFF(
                hintText: 'Craft Item name',
                controller: name,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Craft Item cannot be empty';
                  }
                },
              ),
              TFF(
                hintText: 'Item price',
                controller: price,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Item price cannot be empty';
                  }
                },
              ),
              TFF(
                hintText: 'Item description',
                controller: description,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Description cannot be empty';
                  }
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Choose Image',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.photo_outlined,
                      size: 35,
                    ),
                    onPressed: chooseImageGallery,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      size: 35,
                    ),
                    onPressed: chooseImageCamera,
                  ),
                ],
              ),
              Center(
                child: SizedBox(
                  height: 100,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _image != null
                        ? Image.file(
                            _image,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            widget.craftUser.image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ELB(
                onPressed: () async {
                  setState(() {});
                  if (craftKey.currentState!.validate()) {
                    await updateImage();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                text: 'Update',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
