CHECKPOINT_PATH='/home/rka/code/sam_try/sam_vit_b_01ec64.pth'


import torch
DEVICE = torch.device('cuda:0' if torch.cuda.is_available() else 'cpu')
MODEL_TYPE = "vit_b"

from segment_anything import sam_model_registry, SamAutomaticMaskGenerator, SamPredictor


sam = sam_model_registry[MODEL_TYPE](checkpoint=CHECKPOINT_PATH).to(device=DEVICE)


mask_generator = SamAutomaticMaskGenerator(sam)


# gen mask
import cv2
IMAGE_PATH = '/home/rka/code/sam_try/frame_0001.png'

# Read the image from the path
image= cv2.imread(IMAGE_PATH)
# Convert to RGB format
# TODO  Is it necessary??
image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)


# Generate segmentation mask
sam_result = mask_generator.generate(image_rgb)
# print(output_mask)


# import supervision as sv

# mask_annotator = sv.MaskAnnotator(color = "index")
# detections = sv.Detections.from_sam(output_mask)
# annotated_image = mask_annotator.annotate(image, detections)

import matplotlib.pyplot as plt
show_output(output_mask, axes[1])
