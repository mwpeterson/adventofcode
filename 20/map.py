import numpy as np

def enhance(img, algo, step):
    if algo[0] == 1 and not step %2:
        fill = 1
    else:
        fill = 0
    img = np.pad(img, pad_width=2, constant_values=fill)
    out_img = np.full((img.shape[0]-2, img.shape[0]-2), 0, dtype=int)
    for x in range(1, img.shape[0]-1):
        for y in range(1, img.shape[1]-1):
            grid = img[x-1:x+2, y-1:y+2]
            pixel = int(''.join(grid.astype(str).flatten()),2)
            out_img[x-1,y-1] = algo[pixel]
    return out_img.copy()

file = 'input'
lines = []
with open(file) as f:
    for line in f:
        lines.append(line.strip())

algo = [1 if p == '#' else 0 for p in lines[0]]
img = np.array([[1 if p == "#" else 0 for p in l] for l in lines[2:]], dtype=int)

for i in range(1,51):
    img = enhance(img, algo, i)


print(np.count_nonzero(img))