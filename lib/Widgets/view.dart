import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelData {
  final String name;
  final String assetPath;
  final String thumbnail; // URL as a string
  final String artist;
  final String date;
  final String history;
  final String description;

  ModelData({
    required this.name,
    required this.assetPath,
    required this.thumbnail,
    required this.artist,
    required this.date,
    required this.history,
    required this.description,
  });
}

class ModelGridPage extends StatefulWidget {
  const ModelGridPage({Key? key}) : super(key: key);

  @override
  ModelGridPageState createState() => ModelGridPageState();
}

class ModelGridPageState extends State<ModelGridPage> {
  final List<ModelData> models = [
    ModelData(
      name: 'American Gothic',
      assetPath: 'assets/models/american_gothic.glb',
      thumbnail:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Grant_Wood_-_American_Gothic_-_Google_Art_Project.jpg/960px-Grant_Wood_-_American_Gothic_-_Google_Art_Project.jpg', //URL can also be specified here
      artist: 'Grant Wood',
      date: '1930',
      history:
      'American Gothic is a painting by Grant Wood from 1930. It depicts a farmer standing beside his daughter.',
      description: 'A famous painting by Grant Wood.',
    ),
    ModelData(
      name: 'Girl with a Pearl Earring',
      assetPath: 'assets/models/girl_with_a_pearl_earring.glb',
      thumbnail:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF4LkLHTSCBL4NYm7WxwNbCVh_VDXuOlA0JQ&s', //URL can also be specified here
      artist: 'Johannes Vermeer',
      date: '1665',
      history:
      'Girl with a Pearl Earring is an oil painting by Dutch Golden Age painter Johannes Vermeer, dated c. 1665.',
      description: 'A famous painting by Johannes Vermeer.',
    ),
    ModelData(
      name: 'Mona Lisa',
      assetPath: 'assets/models/monalisa.glb',
      thumbnail:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ec/Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg/960px-Mona_Lisa%2C_by_Leonardo_da_Vinci%2C_from_C2RMF_retouched.jpg', //URL can also be specified here
      artist: 'Leonardo da Vinci',
      date: '1503-1517',
      history:
      'The Mona Lisa is a half-length portrait painting by Italian artist Leonardo da Vinci. Considered an archetypal masterpiece of the Italian Renaissance.',
      description: 'A famous painting by Leonardo da Vinci.',
    ),
    ModelData(
      name: 'The Baraat',
      assetPath: 'assets/models/the_baraat.glb',
      thumbnail:
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT42Ck2jyH8bv_DKycWZbN_GeolsDJiACjKGg&s', //URL can also be specified here
      artist: 'An Unknown Artist',
      date: '19th Century',
      history: 'The Baraat is a painting from the 19th Century.',
      description: 'A classical painting.',
    ),
    ModelData(
      name: 'The Starry Night',
      assetPath: 'assets/models/the_starry_night.glb',
      thumbnail:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/ea/Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg/500px-Van_Gogh_-_Starry_Night_-_Google_Art_Project.jpg',
      artist: 'Vincent van Gogh',
      date: '1889',
      history:
      'The Starry Night is an oil on canvas painting by Dutch Post-Impressionist painter Vincent van Gogh. Painted in June 1889, it depicts the view from the east-facing window of his asylum room at Saint-Rémy-de-Provence.',
      description: 'A painting from the post-impressionist painter.',
    ),
  ];

  ModelData? selectedModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '3D Model Showcase',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable GridView's scrolling
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: models.length,
              itemBuilder: (context, index) {
                final model = models[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedModel = model;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          // Load from URL
                          model.thumbnail,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            model.name,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            if (selectedModel != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      key: ValueKey(
                          selectedModel!.assetPath), // Unique key for each model
                      height: 400, // Increased model size
                      child: ModelViewer(
                        src: selectedModel!.assetPath,
                        alt: 'A 3D model of ${selectedModel!.name}',
                        autoRotate: true,
                        cameraControls: true,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Text(
                      selectedModel!.name,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Artist: ${selectedModel!.artist}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Date: ${selectedModel!.date}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'History: ${selectedModel!.history}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        selectedModel!.description,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
