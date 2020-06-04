import cv2
from dst.zigzag import *
from dst.consts import *


def read_file():
    global details, h, w
    with open(FILE_PATH, 'r') as input_file:
        image = input_file.read()
    details = image.split()
    # просто костиль в Пайтоні, щоб добути число
    h = int(''.join(filter(str.isdigit, details[0])))
    w = int(''.join(filter(str.isdigit, details[1])))


# Створюємо масив і інціалізуємо розміром та числами зображення
def init_restore_image():
    global array, j, k, i
    # оголошуємо масив нулів
    array = np.zeros(h * w).astype(int)
    # some loop var initialisation
    j = k = x = 0
    i = 2
    # Цикл, який відновлює масив розміром в зображення
    while k < array.shape[0]:
        # Зображення закінчилось
        if details[i] == ';':
            break

        array[k] = int(''.join(filter(str.isdigit, details[i])))
        # Нам приходиться окремо з файлу зчитувати від'ємні числа за наявністю мінуса
        if "-" in details[i]:
            array[k] *= -1

        if i + 3 < len(details):
            j = int(''.join(filter(str.isdigit, details[i + 3])))

        k += 1 if i == 0 else (j + 1)
        i += 2
    array = np.reshape(array, (h, w))


# Процес відновлення зображення. По блоках записуємо в порядку зворотнього зиг-загу кожний біт.
# Робимо деквантування (множимо на відповідні коефіцієнти квантування, на які ми ділили відповідно при кодуванні)
# Кожний блок проганяємо Зворотнім Дискретним Косинусним Перетворенням (ЗДКП)
# І заповнюємо матрицю, яка представляє наше зображення
def restore_to_compressed_image():
    global i, j, k, padded_img
    i = j = k = 0
    padded_img = np.zeros((h, w))
    while i < h:
        j = 0
        while j < w:
            temp_stream = array[i:i + BLOCK_SIZE, j:j + BLOCK_SIZE]
            block = inverse_zigzag(temp_stream.flatten(), int(BLOCK_SIZE), int(BLOCK_SIZE))
            de_quantized = np.multiply(block, QUANTIZATION_MATRIX)
            padded_img[i:i + BLOCK_SIZE, j:j + BLOCK_SIZE] = cv2.idct(de_quantized)
            j += BLOCK_SIZE
        i += BLOCK_SIZE


# Обрізаємо до розміру 8 бітів (255)
def cut_image():
    padded_img[padded_img > 255] = 255
    padded_img[padded_img < 0] = 0


def main():
    read_file()
    init_restore_image()
    restore_to_compressed_image()
    cut_image()
    cv2.imwrite(OUTPUT_IMAGE_PATH, np.uint8(padded_img))
    print("Готово!")


if __name__ == '__main__':
    main()
