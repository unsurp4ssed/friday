#### Установка зависимостей:
```sh
sudo apt install v4l-utils
sudo apt install v4l2loopback-utils
```


#### Перед началом работы:
```sh
./init.sh
```

#### Сделать 1 фотографию
```sh
./take_bmp.sh [filename.bmp]
```

#### Сделать фотографии на всех значениях времени экспозиции
Фото будут сохранены в test_directory из config.cfg (test по умолчанию)
```sh
./test_exp.sh
```


#### Сделать 1 фотографию и отправить ее на обработку (wip etc)
Рабочее фото будет сохранено в photos с именем photo_filename из config.cfg (test.bmp по умолчанию)
```sh
./script.sh
```
