module maskRCNN

include("backbone/resnet.jl")
include("backbone/vgg.jl")
include("rpn/anchors.jl")
include("rpn/sliding_window.jl")
include("rpn/losses.jl")
include("roi_align/roi_align.jl")
include("head/classifier.jl")
include("head/regressor.jl")
include("head/mask_predictor.jl")
include("utils/dataset.jl")
include("utils/metrics.jl")
include("utils/visualizations.jl")








end
