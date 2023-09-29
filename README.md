# maskRCNN

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://SvenDuve.github.io/maskRCNN.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://SvenDuve.github.io/maskRCNN.jl/dev/)
[![Build Status](https://github.com/SvenDuve/maskRCNN.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/SvenDuve/maskRCNN.jl/actions/workflows/CI.yml?query=branch%3Amain)



# To Do

## Creating Datasets

- [x] Created a struct, for each instance, that holds path, image, category ids, height, width, bboxes coordinates, segmentation coordiantes, and the masks. Potentiall have to add the bounding boxes, that logic wasnt fully understood yet.
- [x] Created a function that requires, the path to the annotations file, in this file ALL annotations are stored in JSON format. Further it requires the path to all the images. This function returns a list of structs, where each struct represents one instance.
- [x] Simple function implemented to load an image as is.
- [x] Simple funciton implemented to convert an image to its tenser representation.
- [x] Function implemented to take in all segmented categories in an image, all coordiantes, returns the segmentation masks as a tensor, (n of instances, h, w).
- [ ] A function that alters the image, by applying random transformations, and returns the altered image, and the altered masks.
- [ ] Perhaps check if it is not possible with imageDraw to draw the masks on the image, and then apply the transformations to the image, and the masks are automatically transformed. The use of Luxor works, but feels a bit hacky.
- [ ] Write Unit tests for the functions.
- [ ] Think if the current approach to pack the structs with all unfolded masks and boxes is the way forward, or if we start with a stract holding the meta data of the image, and apply the logic to create masks and boxes on the fly.
- [ ] We requrire a routine that splits the data, or better, simply load the instances from the respective coco folders.
- [ ] The above mechanism is expected to provide batches of images and annotations, that are then used to train the model. These batches are expected to be of the same size, and the model is expected to be able to handle batches of different sizes. This is not the case yet, and has to be implemented. Further the images need to be appropriately padded and augmented.
- [ ] Extensively test Data Loading and augmentation, perhaps in a Notebook.