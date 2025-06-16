import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hope_orphanage/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CraftAdd extends StatefulWidget {
  const CraftAdd({super.key});

  @override
  State<CraftAdd> createState() => _CraftAddState();
}

class _CraftAddState extends State<CraftAdd> {
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

  Future uploadImage() async {
    final uri = Uri.parse('http://$iPAddress/Hope/admin_add_craft_item.php');
    final request = http.MultipartRequest('POST', uri);
    request.fields['price'] = price.text;
    request.fields['craft_id'] = craftID.text;
    request.fields['name'] = name.text;
    request.fields['description'] = description.text;
    final pic = await http.MultipartFile.fromPath('image', _image.path);
    request.files.add(pic);
    final response = await request.send();
    print(response);

    if (response.statusCode == 200) {
      print('Image Uploded');

      price.clear();
      name.clear();
      craftID.clear();
      description.clear();

      if (!mounted) return;
      CSB.show(context, 'Craft Added Successfully');
      if (!mounted) return;
    } else {
      print('Image Not Uploded');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'ADD CRAFT SHOP ITEM',
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
                textCapitalization: TextCapitalization.sentences,
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
                textCapitalization: TextCapitalization.sentences,
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
                        : Center(
                            child: Text(
                              'No image selected',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red[900],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ELB(
                onPressed: () async {
                  if (craftKey.currentState!.validate()) {
                    await uploadImage();
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                text: 'Submit',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
