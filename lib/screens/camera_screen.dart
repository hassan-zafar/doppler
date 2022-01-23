import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dopplerv1/consts/collections.dart';
import 'package:dopplerv1/models/users.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Upload extends StatefulWidget {
  final AppUserModel? currentUser;

  Upload({this.currentUser});

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload>
    with AutomaticKeepAliveClientMixin<Upload> {
  TextEditingController captionController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TextEditingController locationController = TextEditingController();
  File? file;
  bool isUploading = false;
  String postId = const Uuid().v4();
  // Position position;

  selectImage(parentContext) {
    return showDialog(
      context: parentContext,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Choose one"),
          children: <Widget>[
            SimpleDialogOption(
                child: const Text("Photo with Camera"),
                onPressed: handleImageFromCamera),
            SimpleDialogOption(
                child: const Text("Image from Gallery"),
                onPressed: handleImageFromGallery),
            SimpleDialogOption(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  Container buildSplashScreen() {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  child: const Text(
                    "Upload Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  onPressed: () => selectImage(context)),
            ),
          ),
        ],
      ),
    );
  }

  clearImage() {
    setState(() {
      file = null;
    });
  }

  // compressImage() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final path = tempDir.path;
  //   Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
  //   final compressedImageFile = File('$path/img_$postId.jpg')
  //     ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));
  //   setState(() {
  //     file = compressedImageFile;
  //   });
  // }

  handleImageFromCamera() async {
    Navigator.pop(context);
    var picker = await ImagePicker().pickImage(source: ImageSource.camera);
    File? file;
    file = File(picker!.path);
    setState(() {
      this.file = file;
    });
  }

  handleImageFromGallery() async {
    Navigator.pop(context);
    var picker = await ImagePicker().getImage(source: ImageSource.gallery);
    File? file;
    print(file.toString());
    file = File(picker!.path);
    setState(() {
      this.file = file;
    });
  }

  Future<String> uploadImage(imageFile) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('posts/$postId.jpg');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);

    String? downloadUrl;
    await uploadTask.whenComplete(() async {
      downloadUrl = await firebaseStorageRef.getDownloadURL();
    });

    return downloadUrl!;
  }

  createPostInFirestore(
      {String? mediaUrl, String? location, String? description}) {
    imageRef.doc(postId).set({
      "postId": postId,
      "ownerId": currentUser!.id,
      "username": currentUser!.name,
      "mediaUrl": mediaUrl,
    });
  }

  handleSubmit() async {
    setState(() {
      isUploading = true;
    });
    // file != null ? await compressImage() : null;
    String postMediaUrl = file != null
        ? await uploadImage(file).catchError((onError) {
            isUploading = false;
            // BotToast.showText(text: "Couldn't connect to servers!!");
          })
        : "";
    createPostInFirestore(
      mediaUrl: postMediaUrl,
      location: locationController.text,
      description: captionController.text,
    );
    captionController.clear();
    locationController.clear();
    setState(() {
      file = null;
      isUploading = false;
      postId = const Uuid().v4();
    });
  }

  Scaffold buildUploadForm() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        actions: [
          FlatButton(
            onPressed: isUploading
                ? null
                : () {
                    handleSubmit();
                  },
            child: const Text(
              "Upload To Detect",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          isUploading ? const LinearProgressIndicator() : const Text(""),
          SizedBox(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: FileImage(file!),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),

          const Divider(),
          // Container(
          //   width: 200.0,
          //   height: 100.0,
          //   alignment: Alignment.center,
          //   child: RaisedButton.icon(
          //     label: Text(
          //       "Use Current Location",
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30.0),
          //     ),
          //     color: Colors.blue,
          //     onPressed:
          //     getUserLocation,
          //     icon: Icon(
          //       Icons.my_location,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // getUserLocation() async {
  //   LocationPermission permission = await Geolocator.requestPermission();
  //   Position _position = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   setState(() {
  //     position = _position;
  //   });
  //   List<Placemark> placeMarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placeMarks[0];
  //   String completeAddress =
  //       '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
  //   print(completeAddress);
  //   locationController.text = completeAddress;
  // }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return file == null ? buildSplashScreen() : buildUploadForm();
  }
}
