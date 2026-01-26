#pip install Pillow pywin32
from PIL import Image

def convert_png_to_ico(png_file_path, ico_file_path):
    # PNG 파일 열기
    img = Image.open(png_file_path)
    
    # PNG 이미지를 ICO 형식으로 저장
    img.save(ico_file_path, format="ICO")
    # img.save(ico_file_path, format="ICO", sizes=[(16, 16), (32, 32), (48, 48), (256, 256)])


# 사용 예시
png_file_path = 'cdsem\ico\cdsem.png'
ico_file_path = 'cdsem\ico\cdsem.ico'

convert_png_to_ico(png_file_path, ico_file_path)
