import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/Models/user.dart';
import 'package:instagram_flutter/Utils/colors.dart';
import 'package:instagram_flutter/Utils/utils.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final _desciptionController = TextEditingController();
  bool _isloading = false;
  
  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isloading = true;
    });
    try {
      String res = await FireStoreMethod().uploadPost(
        _desciptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          _isloading = false;
        });
        showSnakBar('Posted!', context);
        clearImage();
      } else {
        setState(() {
          _isloading = false;
        });
        showSnakBar(res, context);
      }
    } catch (e) {
      showSnakBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: ((context) {
        return SimpleDialog(
          title: const Text("Create a post!"),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("choose from gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }),
    );
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _desciptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              onPressed: () {
                _selectImage(context);
              },
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                ),
                onPressed: clearImage,
              ),
              title: const Text("Post to"),
              actions: [
                TextButton(
                  onPressed: (() => postImage(
                        user.uid,
                        user.username,
                        user.photoUrl,
                      )),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
            body: Column(
              children: [
                _isloading
                    ? const LinearProgressIndicator()
                    : Container(
                        padding: const EdgeInsets.only(
                          top: 0,
                        ),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoUrl,
                      ),
                    ),
                    SizedBox(
                      width: _screenSize.width * 0.45,
                      child: TextField(
                        controller: _desciptionController,
                        decoration: const InputDecoration(
                          hintText: "Write a caption...",
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
