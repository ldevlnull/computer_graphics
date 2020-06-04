import cv2
import math
from dst.zigzag import *
from dst.consts import *


def main():
    horizontal_blocks, padded_img, vertical_blocks = create_padded_image()
    cv2.imwrite(Y_LAYER_IMAGE, np.uint8(padded_img))
    encode(horizontal_blocks, padded_img, vertical_blocks)
    cv2.imshow('Закодоване зображення', np.uint8(padded_img))
    print_img_to_file(padded_img)
    print("Готово!")
    cv2.waitKey(0)
    cv2.destroyAllWindows()


# Стовюємо зображення для алгоритму. Переводимо вхідне зображення до системи Y'CrCb і дістаємо перший канал (шар Y).
def create_padded_image():
    img = cv2.imread(INPUT_IMAGE_PATH, cv2.IMREAD_COLOR)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2YCrCb)[:, :, 0]
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


# Запис у текстовий файл зображенян у вигляді бітів (коефіцієнтів ДКП)
def print_img_to_file(padded_img):
    arranged = padded_img.flatten()
    bit_stream = get_run_length_encoding(arranged)
    bit_stream = str(padded_img.shape[0]) + " " + str(padded_img.shape[1]) + " " + bit_stream + ";"
    file1 = open(FILE_PATH, "w")
    file1.write(bit_stream)
    file1.close()


# Серилізування зображення в поток бітів для запису у файл
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
