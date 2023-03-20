import os
import sys
from PIL import Image

spreads = True

folderPath = sys.argv[1]
os.chdir(folderPath)

for i, filename in enumerate(os.listdir('.')):
    ext = filename.rsplit('.', maxsplit=1)[1]
    os.rename(filename, f'{i:05d}.{ext}')
i = 0
for filename in os.listdir('.'):
    ext = filename.rsplit('.', maxsplit=1)[1]
    with Image.open(filename) as img:
        w, h = img.size
    if w > h:
        os.rename(filename, f'{i:03d}-{i+1:03d}.{ext}')
        i += 2
    else:
        os.rename(filename, f'{i:03d}.{ext}')
        i += 1
