import 'dart:io';
import 'dart:math';

import 'package:fitgym/Models/dbmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../Controller/global_controller.dart';
import '../../utility/color.dart';


class CreateExercise extends StatefulWidget {
  const CreateExercise({super.key});

  @override
  State<CreateExercise> createState() => _CreateExerciseState();
}

class _CreateExerciseState extends State<CreateExercise> {
  final GlobalDataManagementController _globalDataManagementController= Get.put(GlobalDataManagementController());
  final ImageController _imageController = Get.put(ImageController());
  final DropdownController dropdownController = Get.put(DropdownController());
  final _formKey = GlobalKey<FormState>();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  List<String> category = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var args = Get.arguments;
    var category1 = _globalDataManagementController.exerciseCategory;
    for (var element in category1) {
      category.add(element["name"].toString().toUpperCase());
    }


    dropdownController.addList(category, args["index"]-1);
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = ((Get.width - 50) / 150).floor();
    crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close_outlined,
              color: Colors.white,
              size: 28,
            )),
        backgroundColor: customColor.light_red_shed1,
        title: const Text(
          "Add Custom Exercise",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                if(_formKey.currentState!.validate()){
                  String exerciseTitle = title.text;
                  String exerciseDescription = description.text;
                  int exerciseCategory = category.indexOf(dropdownController.selectedCategory.value)+1;
                  List<String> imagesList = _imageController.imageUrls;
                  print("Title : $exerciseTitle");
                  print("Description : $exerciseDescription");
                  print("ExerciseCategory : $exerciseCategory");
                  print("Images List : ${imagesList}");
                  Directory appDirectory = await getApplicationDocumentsDirectory();
                  Directory imageDir = Directory('${appDirectory.path}/assets/ExtraImages');

                  if (!imageDir.existsSync()) {
                    imageDir.createSync(recursive: true);
                  }
                  int count =1;
                  String rand = getRandomString();
                  try{
                    for(String url in imagesList){
                      File originalImage = File(url);
                      String newImagePath = "${appDirectory.path}/assets/ExtraImages/${exerciseTitle.trim()}$rand$count.png";
                      if (!originalImage.existsSync()) {
                        print("❌ Source file not found: $url");
                        continue;
                      }
                      print(newImagePath);
                      count++;
                      originalImage.copy(newImagePath);
                    }
                  }
                  catch(e){
                    print(e);
                  }

                  int? id_exercise = await DatabaseHelper.instance.getMaxExerciseId();
                  id_exercise = id_exercise != null? id_exercise+1:1;
                  await DatabaseHelper.instance.insertCustomExercise(id_type: exerciseCategory, name: exerciseTitle, descreption: exerciseDescription, custom: 1, id_exercise: id_exercise);
                  await DatabaseHelper.instance.insertCustomImage(name: exerciseTitle.trim()+rand, number: count-1, id_exercise: id_exercise);
                  _globalDataManagementController.updateDataExerciseList();
                  _globalDataManagementController.updateDataExtraImage();
                  Get.offAllNamed("/");
                }

              },
              icon: const Icon(
                Icons.check,
                color: Colors.white,
                size: 28,
              )),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(
          spacing: 10,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    _imageController.addImages(await getImage());
                  },
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 60,
                    color: customColor.light_red_shed1,
                  ),
                ),
                Obx(
                      () => _imageController.imageUrls.isEmpty
                      ? Text(
                    "No image selected",
                  )
                      : SizedBox(
                    width: Get.width - 100,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 2.0,
                        children: [
                          for (String image in _imageController.imageUrls)
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Image.file(
                                  File(image),
                                  width: 145,
                                  height: 145,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  child: IconButton(
                                    onPressed: () {
                                      _imageController.removeImage(image);
                                    },
                                    icon: Icon(
                                      Icons.close_outlined,
                                    ),
                                  ),
                                  right: 2.0,
                                  top: 2.0,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Column(
                spacing: 10.0,
                children: [
                  Row(
                    spacing: 5.0,
                    children: [
                      Text("Title"),
                      Expanded(
                        child: TextFormField(
                          controller: title,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 5.0,
                    children: [
                      Text("Description"),
                      Expanded(
                        child: TextFormField(
                          controller: description,
                          decoration: InputDecoration(
                            border:
                            OutlineInputBorder(), // Add a border around the TextField
                          ),
                          maxLines:
                          5, // Set the number of lines for the textarea
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    spacing: 5.0,
                    children: [
                      Text("Category"),
                      Obx(
                            () => Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                            value: dropdownController.selectedCategory.value,
                            onChanged: (String? newValue) {
                              print(dropdownController.selectedCategory.value);
                              dropdownController.selectedCategory.value =
                              newValue!;
                            },
                            items: dropdownController.category
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),),
      ),
    );
  }
  String getRandomString() {
    const String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"; // Alphabet set
    Random random = Random();

    return "${letters[random.nextInt(letters.length)]}${letters[random.nextInt(letters.length)]}";
  }
  Future<List<String>> getImage() async {
    final picker = ImagePicker();
    final List<XFile>? images =
        await picker.pickMultiImage(requestFullMetadata: true);

    if (images == null) {
      return [];
    }
    List<String> imagesUrl = [];
    images.forEach(
      (element) {
        imagesUrl.add(element.path);
        print("${element.path} and name: ${element.name}");
      },
    );

    return imagesUrl;
  }
}

class DropdownController extends GetxController {
  List<String> category = [];
  RxString selectedCategory = "".obs;

  void addList(List<String> list, int index) {
    category.addAll(list);
    selectedCategory.value = list[index];
  }
}

class ImageController extends GetxController {
  RxList<String> imageUrls = <String>[].obs;
  void addImages(List<String> list) {
    imageUrls.addAll(list);
  }

  void removeImage(String url) {
    imageUrls.remove(url);
  }
}
