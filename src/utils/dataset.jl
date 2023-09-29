using JSON 
using Images
using TestImages, ImageDraw, ImageCore, ImageShow
using FileIO # hide
using Luxor


mutable struct InstanceData

    image_path
    image
    category_ids
    height
    width
    boxes # Each row should be [x, y, w, h]
    segmentation # (height, width, num_instances)
    masks
    function InstanceData(image_path, image, category_ids, height, width, boxes, segmentation, masks)
        new(image_path, image, category_ids, height, width, boxes, segmentation, masks)
    end
end


function load_image(path::String)
    return load(path)
end

function load_channelview(path::String)
    return channelview(load(path))
end



function create_masks(width, height, category_ids, segmentation)

    tensor = Array{Float64}(undef, length(category_ids), height, width)
    
    for (i, el) in enumerate(segmentation)
        Drawing(width, height, :png)
        background("black")
        sethue("white")
        xs = el[1][1:2:end]
        ys = el[1][2:2:end]
        ps = map(x -> Luxor.Point(x[1], x[2]), zip(xs, ys))
        poly(ps, :fill)
        mat = image_as_matrix()
        tensor[i,:,:] = reshape(channelview(Gray.(mat)), (1, height, width))
        finish()
    end

    return tensor

end



function create_instances(annotation_path::String, image_base_path::String, batch_size)

    instances = []
    image = []
    category_ids = []
    boxes = []
    segmentation = []
    image_path = ""
    height = 0
    width = 0

    annotations = JSON.parsefile(annotation_path)

    n = length(annotations["images"])

    image_ids = rand(1:n, batch_size)

    for image_id in image_ids

        image_path = annotations["images"][image_id]["file_name"]
        image = load_channelview(image_base_path * image_path)
        height = annotations["images"][image_id]["height"]
        width = annotations["images"][image_id]["width"]
        
        for annotation in annotations["annotations"]
        
            if annotation["image_id"] == annotations["images"][image_id]["id"]

                push!(category_ids, annotation["category_id"])
                push!(boxes, annotation["bbox"])
                push!(segmentation, annotation["segmentation"])
        
            end
        
        end

        masks = create_masks(width, height, category_ids, segmentation)

        instance = InstanceData(image_path, image, category_ids, height, width, boxes, segmentation, masks)
        push!(instances, instance)

        category_ids = []
        boxes = []
        segmentation = []
    
    end


    return instances

end



# Basic Usage

# get some annotations in COCO format
ann_path = "/Users/svenduve/.julia/dev/maskRCNN/data/annotations/instances_val2017.json"
# load the respective images
image_base_path = "/Users/svenduve/.julia/dev/maskRCNN/data/validate/"
# inspect JSON
annotations = JSON.parsefile(ann_path)


# Create random instances
instcs = create_instances(ann_path, image_base_path, 10);


# view the image
colorview(RGB, instcs[3].image)
instcs[3].category_ids
Gray.(instcs[3].masks[1, :, :])




function apply_mask_overlay(image::AbstractArray, masks::AbstractArray; alpha::Float64=0.5)
    # Ensure the image and mask are of the same size
    

    # Define mask color (red in this example)
    # mask_color = [1.0, 0.0, 0.0]
    
    # Create an output image initialized to the original image
    output_image = deepcopy(image)
    
    
    for i in 1:size(masks, 1)
        @show i
        mask_color = rand(3)
        @show mask_color
        # Iterate over each pixel in the image
        for j in 1:size(masks, 2)
            # @show size(masks, 2)
            for k in 1:size(masks, 3)
                # @show size(masks, 3)
                if masks[i, j, k] == 1  # Apply overlay only where the mask is 1
                    output_image[:, j, k] = alpha .* mask_color .+ (1 - alpha) .* image[:, j, k]
                end
            end
        end

    end

#    @show sum(output_image) - sum(image)

    return output_image
end


n = 4
img = instcs[n].image;
masks = instcs[n].masks;

newimg = apply_mask_overlay(img, masks, alpha=.5)

colorview(RGB, newimg)
colorview(RGB, img)
