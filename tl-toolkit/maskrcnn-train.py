# TLT Jupyter Notebook in .py form

# Set up env variables
import os, argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--key', help='NGC Key')
parser.add_argument('--model', help='Pretrained model folder')
parser.add_argument('--data', help='Data folder')
parser.add_argument('--specs', help='Specification folder')
args = parser.parse_args()

print("Key: {}\nModel: {}\nData: {}\nSpecs: {}\n".format('...'+args.key[-4:], args.model, args.data, args.specs))
