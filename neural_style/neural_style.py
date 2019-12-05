import argparse
import os
import sys
import time
import re

import fcn
import skimage.io
import numpy as np
import torch
from torch.autograd import Variable
import torchfcn

from torch.optim import Adam
from torch.utils.data import DataLoader
from torchvision import datasets
from torchvision import transforms
import tqdm
import torch.onnx

import utils

def stylize(args):
    device = torch.device("cuda" if args.cuda else "cpu")

    content_image = utils.load_image(args.content_image, scale=args.content_scale)
    content_transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Lambda(lambda x: x.mul(255))
    ])
    content_image = content_transform(content_image)
    content_image = content_image.unsqueeze(0).to(device)

    with torch.no_grad():
        style_model = torchfcn.models.FCN8s(n_class=21)
        state_dict = torch.load(args.model)
        style_model.cuda()
        for k in list(state_dict.keys()):
            if re.search(r'in\d+\.running_(mean|var)$', k):
                del state_dict[k]
        style_model.load_state_dict(state_dict)
        print("after load state dict")
        style_model.to(device)
        print("before onnx export")
        if args.export_onnx:
            assert args.export_onnx.endswith(".onnx"), "Export model file should end with .onnx"
            output = torch.onnx._export(style_model, content_image, args.export_onnx, export_params=True).cpu()
        else:
               
            utils.save_image(args.output_image, output[0])




def main():
    main_arg_parser = argparse.ArgumentParser(description="parser for model conversion")
    subparsers = main_arg_parser.add_subparsers(title="subcommands", dest="subcommand")


    eval_arg_parser = subparsers.add_parser("eval", help="parser for evaluation/stylizing arguments")
    eval_arg_parser.add_argument("--content-image", type=str, required=True,
                                 help="path to content image you want to stylize")
    eval_arg_parser.add_argument("--content-scale", type=float, default=None,
                                 help="factor for scaling down the content image")
    eval_arg_parser.add_argument("--output-image", type=str, required=True,
                                 help="path for saving the output image")
    eval_arg_parser.add_argument("--model", type=str, required=True,
                                 help="saved model to be used for stylizing the image. If file ends in .pth - PyTorch path is used, if in .onnx - Caffe2 path")
    eval_arg_parser.add_argument("--cuda", type=int, required=True,
                                 help="set it to 1 for running on GPU, 0 for CPU")
    eval_arg_parser.add_argument("--export_onnx", type=str,
                                 help="export ONNX model to a given file")

    args = main_arg_parser.parse_args()

    if args.subcommand is None:
        print("ERROR: Error in argument passing")
        sys.exit(1)
    
    
    stylize(args)


if __name__ == "__main__":
    main()
