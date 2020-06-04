import cv2
import math
from dst.zigzag import *

IMAGE_PATH = 'sample_420x420.bmp'
BLOCK_SIZE = 8
QUANTIZATION_MATRIX = np.array([
    [16, 11, 10, 16, 24,  40,  51,   61],
    [12, 12, 14, 19, 26,  58,  60,   55],
    [14, 13, 16, 24, 40,  57,  69,   56],
    [14, 17, 22, 29, 51,  87,  80,   62],
    [18, 22, 37, 56, 68,  109, 103,  77],
    [24, 35, 55, 64, 81,  104, 113,  92],
    [49, 64, 78, 87, 103, 121, 120, 101],
    [72, 92, 95, 98, 112, 100, 103,  99]
])


def main():
    horizontal_blocks, padded_img, vertical_blocks = create_padded_image()
    cv2.imwrite('y_layer.bmp', np.uint8(padded_img))
    encode(horizontal_blocks, padded_img, vertical_blocks)
    cv2.imshow('Закодоване зображення', np.uint8(padded_img))
    arranged = padded_img.flatten()
    bitstream = get_run_length_encoding(arranged)
    bitstream = str(padded_img.shape[0]) + " " + str(padded_img.shape[1]) + " " + bitstream + ";"
    file1 = open("encoded_image.txt", "w")
    file1.write(bitstream)
    file1.close()
    cv2.waitKey(0)
    cv2.destroyAllWindows()


def create_padded_image():
    img = cv2.imread(IMAGE_PATH, cv2.IMREAD_GRAYSCALE)
    [h, w] = img.shape
    height = h
    width = w
    h = np.float32(h)
    w = np.float32(w)
    vertical_blocks = math.ceil(h / BLOCK_SIZE)
    vertical_blocks = np.int32(vertical_blocks)
    horizontal_blocks = math.ceil(w / BLOCK_SIZE)
    horizontal_blocks = np.int32(horizontal_blocks)
    padded_img_height = BLOCK_SIZE * vertical_blocks
    padded_img_width = BLOCK_SIZE * horizontal_blocks
    padded_img = np.zeros((padded_img_height, padded_img_width))
    padded_img[0:height, 0:width] = img[0:height, 0:width]
    return horizontal_blocks, padded_img, vertical_blocks


# Кодування:
# Розбиваємо зображення на блоки (в нашому випадку 8 на 8)
# До кожного блоку застосовуємо Дискретне Косинусне Перетворення (ДКП)
# Сортуємо коефіцієнти ДКП за принципу зіг-загу і складаємо назад блоками (8 на 8)
def encode(horizontal_blocks, padded_img, vertical_blocks):
    for i in range(vertical_blocks):
        left_row_i = i * BLOCK_SIZE
        right_row_i = left_row_i + BLOCK_SIZE

        for j in range(horizontal_blocks):
            top_col_j = j * BLOCK_SIZE
            bot_col_j = top_col_j + BLOCK_SIZE
            block = padded_img[left_row_i: right_row_i, top_col_j: bot_col_j]
            dct_result = cv2.dct(block)
            dct_result_normalized = np.divide(dct_result, QUANTIZATION_MATRIX).astype(int)
            zigzag_ordered = zigzag(dct_result_normalized)
            block_reshaped = np.reshape(zigzag_ordered, (BLOCK_SIZE, BLOCK_SIZE))
            padded_img[left_row_i: right_row_i, top_col_j: bot_col_j] = block_reshaped


def get_run_length_encoding(img):
    i = skipped = 0
    stream = []
    bit_stream = ""
    img = img.astype(int)
    while i < img.shape[0]:
        if img[i] != 0:
            stream.append((img[i], skipped))
            bit_stream += str(img[i]) + " " + str(skipped) + " "
            skipped = 0
        else:
            skipped += 1
        i += 1
    return bit_stream


if __name__ == '__main__':
    main()
