<!-- #### Установка зависимостей:
```sh
sudo apt install v4l-utils
sudo apt install ffmpeg
```

```
sudo apt install v4l2loopback-dkms
```
ИЛИ
```
sudo apt-get install v4l2loopback-source module-assistant
sudo module-assistant auto-install v4l2loopback-source
```
https://github.com/v4l2loopback/v4l2loopback?tab=readme-ov-file#DISTRIBUTIONS

-->
#### Перед началом работы:
Если ошибка в духе "input/output error"/"cannot access /dev/video2"
```sh
chmod 777 *.sh
```

#### Сделать 1 фотографию
```sh
./take_bmp.sh [filename.bmp]
```

#### Сделать фотографии на всех значениях времени экспозиции и усиления
Фото будут сохранены в test_directory из config.cfg (test по умолчанию)
```sh
./test_exp-n-gain.sh
```


#### Сделать 1 фотографию и отправить ее на обработку (wip etc)
Рабочее фото будет сохранено в photos с именем photo_filename из config.cfg (test.bmp по умолчанию)
```sh
./script.sh
```
