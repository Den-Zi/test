/* Используется база данных MariaDb 10.3.25 */
create database slave_baza;
use slave_baza;

create table slave_geolocation(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,

    PRIMARY KEY(id)
)
COMMENT 'Список мест где раб может быть пойман/выращен';

/* Для категорий используется nested sets, для упрощения работы с многоуровневой иерархией вместо
 использования parent_id */
create table slave_category(
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    lft SMALLINT UNSIGNED NOT NULL,
    rgt SMALLINT UNSIGNED NOT NULL,

    PRIMARY KEY(id),
    UNIQUE INDEX (name),
    INDEX (lft, rgt)
) COMMENT 'Список категорий рабов';

create table slave(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    gender ENUM('male', 'female') NOT NULL,
    age TINYINT UNSIGNED NOT NULL,
    weight TINYINT UNSIGNED NOT NULL,
    skin_color ENUM('white', 'black', 'red') NOT NULL,
    place_capture_id INT UNSIGNED NOT NULL,
    description TEXT COMMENT 'Описание и повадки (например, любит играть с собакой)',
    price_per_hour INT UNSIGNED NOT NULL COMMENT 'Ставка почасовой аренды',
    cost INT UNSIGNED NOT NULL,

    PRIMARY KEY(id),
    FOREIGN KEY (place_capture_id)
        REFERENCES place_capture(id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX (weight),
    INDEX (gender)
)
COMMENT 'Список рабов';

create table slave_category_link(
    slave_id INT UNSIGNED NOT NULL,
    slave_category_id SMALLINT UNSIGNED NOT NULL,

    PRIMARY KEY(slave_id, slave_category_id),
    FOREIGN KEY (slave_id)
        REFERENCES slave(id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (slave_category_id)
        REFERENCES slave_category(id)
        ON UPDATE CASCADE ON DELETE CASCADE
)
COMMENT 'Список связей рабов с их категориями';


create table master(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    vip_level ENUM('gold', 'silver', 'bronze') COMMENT 'Уровень VIP',

    PRIMARY KEY(id)
)
COMMENT 'Список хозяев';

create table lease(
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    master_id INT UNSIGNED,
    slave_id INT UNSIGNED,
    start_time DATETIME NOT NULL COMMENT 'дата и время начала аренды',
    end_time DATETIME NOT NULL COMMENT 'дата и время завершения аренды',

    PRIMARY KEY(id)
)
COMMENT 'Список контрактов для аренды рабов';
